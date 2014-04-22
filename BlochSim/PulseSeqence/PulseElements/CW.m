classdef CW < PulseElement
    %CW Continious wave irradiation
    
    properties
    end
    
    methods
        
        function obj = CW( time, B1, o1 )
            obj = obj@PulseElement( 'H1', time, B1, 0, o1 );
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

