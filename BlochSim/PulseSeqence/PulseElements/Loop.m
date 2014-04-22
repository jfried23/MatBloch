classdef Loop < PulseElement
    %Delay A pulse seqence delay
    %   Magntiziation will evlove under influence of B0
    
    properties
        step;
        cycles;
        init_cyc;
    end
    
    methods
        
        function obj = Loop( step, cycles )
            obj = obj@PulseElement( 'void', 0.0, 0.0, 0, 0.0 );
            obj.step = step;
            obj.cycles = cycles;
            obj.init_cyc = cycles;
        end
        
        function obj = reset(obj)
            obj.cycles = obj.init_cyc;
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

