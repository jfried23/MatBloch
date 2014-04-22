classdef Delay < PulseElement
    %Delay A pulse seqence delay
    %   Magntiziation will evlove under influence of B0
    
    properties
    end
    
    methods
        
        function obj = Delay( time )
            obj = obj@PulseElement( 'void', time, 0.0, 0, 0.0 ); 
        end
        
        function obj = inc_ph(obj) 
            disp( 'A delay has no phase! Cannot increment delay phase!'); 
        end
        
        function obj = inc_o1(obj)
            disp( 'A delay has no offset! Cannot increment delay o1!'); 
        end
        
        function obj = inc_B1(obj)
            disp( 'A delay has no B1 field! Cannot increment delay B1!'); 
        end
        
    end
    
end

