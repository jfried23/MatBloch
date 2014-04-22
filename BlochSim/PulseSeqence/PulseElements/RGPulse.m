classdef RGPulse < PulseElement
    %RGPulse Achieves a desired pulse angle in alloted time
    %   A pulse element wrapper sets B1 inorder to achive a desiered pulse
    %   flip angle in the alloted time.
    
    properties
    end
    
    methods
        
        function obj = RGPulse( angle, time, phase, varargin )
                
            if nargin == 4
                nuc='H1'; o1=varargin{4};
            elseif nargin == 5
                nuc=varargin{5}; o1=varargin{4};
            else
                nuc='H1'; o1=0.0;
            end

            Hz = (angle/360.0)/time;
            obj = obj@PulseElement( nuc, time, Hz, phase, o1 ); 
        end
        
        
        function obj = inc_t(obj)
            disp( 'A RGPulse has a fixed durration! Cannot increment time!'); 
        end
        
        function obj = inc_B1(obj)
            disp( 'A RGPulse has a fixed B1! Can not increment B1!'); 
        end
        
    end
    
end

