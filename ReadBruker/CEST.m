classdef CEST < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path;  %Path to data directory
        fids;  %FID at each freqency offset
        zfreq;   %List of offset freqencies in Hz
        fullppm; %List of offset freqencies in ppm
        echos; %1-D Sample Projections at each freqency offset 
        zspec; %CEST Z-spectrum
        asymm; %CEST asymmetry analysis
        
        B1   ; %Just reccords the B1 power [x, y] for this dataset
        pulse_seq; %A pulse sequence this was collected with
    end
    
    methods
%% Class Constructor
        function obj = CEST( BasePath, varargin )
            if ~isempty(varargin)
                if isa( varargin{1}, 'PulseSequence')
                    obj.pulse_seq = varargin{1};
                    obj.B1 = nan;
                elseif isa( varargin{1}, 'numeric')   
                    obj.B1 = varargin{1};
                    obj.pulse_seq = false;
                else
                    obj.B1 = nan;
                    obj.pulse_seq = false;
                end
            end
            
            obj.path = BasePath;
            obj.fids = read_bruker(obj.path);
            obj.echos= fftshift( abs( fft(obj.fids, [], 2 ) ), 2 );
            obj.zspec= trapz(obj.echos,2);
            obj.zspec= (obj.zspec - obj.zspec(1));
            %for j=1:length(obj.zspec), obj.zspec(j) = obj.zspec(j)+obj.zspec(1); end
            obj.zfreq= zeros(1, length(obj.zspec) );
            
            np = length( obj.zspec);
            if mod(np,2), np=np-1; end %if np odd ignore central point
            obj.asymm = zeros(1,np/2);
            for p = 1:np/2
                obj.asymm(p) = 1-obj.zspec(p)/obj.zspec(np-p) ;
            end
           
            lstname = dir(fullfile(obj.path, 'fq*list'));
            lstpth  = fullfile( obj.path, lstname.name);
            if exist(lstpth, 'file')
                obj.zfreq   = importdata( lstpth );
                obj.fullppm = obj.zfreq/400;
            end
            
            
        end
        
        function obj = plot( obj, varargin )
                        
            if ~isempty(varargin)
                c = varargin{1};
            else
                c = 'k';
            end
            plot( obj.fullppm, obj.zspec, c )
        end
        
    
    end
    
end