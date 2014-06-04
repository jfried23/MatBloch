classdef CEST_data < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pulse_seq;
        B1;
        path;
        zspec;
        fullppm;
        asymm;
        zfreq;
    end
    
    methods
%% Class Constructor
        function obj = CEST_data( ppm, spec, varargin )
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
            
            obj.path = 'None';

            obj.zspec = spec';
            obj.zfreq = ppm*298';
            obj.fullppm = ppm';
            
            
            np = length( obj.zspec);
            if mod(np,2), np=np-1; end %if np odd ignore central point
            obj.asymm = zeros(1,np/2);
            for p = 1:np/2
                obj.asymm(p) = 1-obj.zspec(p)/obj.zspec(np-p + 1) ;
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