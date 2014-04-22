classdef PulseSequence < handle
    %PulseSequence: Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        B0      ; %Static magnetic field strengh in Tesla
        sequence;
    end
    
    properties ( Hidden = true )
        step;
    end
    
    methods
        function obj = PulseSequence( varargin )
            if nargin == 1
                obj.B0 = varargin{1};
            else obj.B0= 9.4;
            end
            obj.step = 1;
        end

        function obj = add( obj, elem )
            assert( isa(elem, 'PulseElement'), 'Only PulseElements can be added to a pulse seqence!');
            obj.sequence{end+1} = elem;
        end
        
        function obj = reset(obj), obj.step=1; end
        
        function nxt = next(obj)
            
            thisStep = obj.sequence{obj.step};
            if isa( thisStep, 'Loop')
                if thisStep.cycles > 0
                    thisStep.cycles = thisStep.cycles - 1;
                    obj.step = thisStep.step;
                else
                    thisStep.reset;
                    obj.step = obj.step+1;
                end
            end
         
            nxt = obj.sequence{obj.step};
            obj.step=obj.step+1;
            
            if obj.step > length( obj.sequence ), obj.step = 1; end
        end
        
        
    end
    
end

