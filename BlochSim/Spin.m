classdef Spin < handle
    %Spin: Really just a structure representing a spin type object for use
    %durring Bloch simulation
    
    properties
        R1    ;     % Spin-Latice relaxation rate in Hz
        R2    ;     % Spin-Spin   relaxation rate in Hz
        x     ;     %Spin precession freqency in ppm
        nucli ;     %String representivtive nucli name
        I_vec ;     % Vector (3d) of [x y z] spin magnitizaion
        c     ;
    end
    
    properties ( Hidden=true )    
        limit    ;  %Map of limits for each paramter                  
        opt_vals ;  %Map of bools specifing which parameters to optimize 

    end
    
    methods    
        
        function obj = Spin( R1, R2, x, I, varargin )
            obj.nucli = 'H1';
            if nargin == 5, 
                obj.nucli = varargin{1};
                assert( ismember( obj.nucli, properties( GyromagneticRatio ) ) );
            end                    
            
            obj.c = sum(abs(I));
            
            assert( ( R1 > 0 ) && isa( R1, 'double'), 'Input "R1" must be a non negative real in unit Hz'  );
            assert( ( R2 > 0 ) && isa( R2, 'double'), 'Input "R2" must be a non negative real in unit Hz'  );
            assert( isa(x,'double'), 'Input "x0" must be a double in ppm!' );
            
            obj.R1=R1;
            obj.R2=R2;
            obj.x = x;
            
            assert( all( size(I) == [ 1 3] ) && isa(I,'double'), 'Input "I" must be a 1x3 vector of doubles!' );
            obj.I_vec  = I/obj.c;
            
            %Limits for fitting
            obj.limit      = containers.Map({'c', 'R1', 'R2', 'x'}, { {0, 1e9}, {0,5}, {0,obj.R2+200}, {obj.x-2, obj.x+2} });    
            obj.opt_vals   = containers.Map({'c', 'R1', 'R2', 'x'}, {1, 1, 1, 1} );
            
        end
        
        
        function obj = set_lb_ub(obj, key, lb, ub)
            obj.limit(key)={lb, ub};
        end
        
       
        %Acessor Functions
        function M = M( obj ), M = obj.c ; end
        function I = I ( obj ), I = obj.I_vec*obj.c   ; end
        function x = Ix( obj ), x = obj.I_vec(1)*obj.c; end
        function y = Iy( obj ), y = obj.I_vec(2)*obj.c; end
        function z = Iz( obj ), z = obj.I_vec(3)*obj.c; end
        function obj = reset(obj)
            obj.I_vec = [0 0 1]; 
        end
        
        function w0 = w0( obj, B0 )
            assert( isa(B0, 'double') );
            w0 = getfield( GyromagneticRatio, obj.nucli) * obj.x * B0/1.e6;
        end
        
    end    
end


