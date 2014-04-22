classdef Bruker < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path;
        npts;
        sw  ;
        fid ;
        
    end
    
    methods
%% Class Constructor
        function obj = Bruker( BasePath )
            obj.path = BasePath;
            obj.npts = ones(1,2);
            obj.sw   = zeros(1,2);
            
            if exist( fullfile(obj.path, 'acqu2s'), 'file' )
                acqu2s = parse_acqus( fullfile(obj.path, 'acqu2s')  );
                obj.npts(2) =  str2num(acqu2s('TD'));
                obj.sw(2)   = str2double( acqu2s('SW_h') );
                fidPath = fullfile(obj.path, 'ser');  
            else
                fidPath = fullfile(obj.path, 'fid');
            end
            
            acqus = parse_acqus( fullfile(obj.path, 'acqus')  );
            obj.npts(1) = str2num(acqus('TD'));
            obj.sw(1)   = str2double( acqus('SW_h') );
            
        
            switch str2num(acqus('BYTORDA'))
                case 0, byte_format='l';         %little endian       
                case 1, byte_format='b';         %big endian
                otherwise, error('unknown data format (BYTORDA)')
            end
           
            switch str2num(acqus('DTYPA'))
                case 0, byte_size='int32';
                case 1, byte_size='double';
                otherwise, error('unknown data format (BYTORDA)')
            end
            
            %Incase direct dimenision is not multiple of 256
            corrpoints=rem(obj.npts(1),256);
            if corrpoints>0
                corrpoints=256-corrpoints;
                obj.npts(1)=obj.npts(1)+corrpoints;
            end
            
            obj.fid = zeros( obj.npts(2), obj.npts(1)/2 );
            
            %Now read the fid binary file
            fl_ptr = fopen(fidPath, 'r', byte_format);
            impfid=fread(fl_ptr, obj.npts(1)*obj.npts(2), byte_size);
            compfid=complex(impfid(1:2:end),-impfid(2:2:end));
            
            for k=1:obj.npts(2)
                obj.fid(k,:)=compfid( (k-1)*(obj.npts(1)/2)+1:k*(obj.npts(1)/2) );
            end

            
            
        end
        
    
    end
    
end