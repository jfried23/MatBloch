classdef BlochSim < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        spins       ;%Vector of all "Spin" objects in the simulation (1xn)
        kex         ;%Matrix of dim length(spins) x length(spins) enumerating
                     %the rate of magnetization exchnage (kex) between
                     %Rmtx(s2,s1) i.e. from s2 -> s1
        kex_ub      ;
        kex_lb      ;
    end
    
    methods
                
        function obj = BlochSim( varargin )
            obj.spins = Spin.empty(0,nargin);
            for k=1:nargin, obj.spins(k) = varargin{k}; end            
            obj.kex = zeros(nargin,nargin);
            obj.kex_lb = zeros(nargin,nargin);
            obj.kex_ub = zeros(nargin,nargin);
        end
        
        %Function add_kex adds an exchange term from spin(frm)->spin(to) &
        %its mass-action correlary spin(to)->spin(frm)
        function obj = add_kex(obj, frm, to, kex, varargin) 
            assert( all( size(kex) == [ 1 1] ) && isa(kex, 'double') );
            if  (obj.spins(frm).c ~= 0 && obj.spins(to).c ~= 0)
                obj.kex(frm, to) = kex;
                obj.kex(to, frm) = (obj.spins(frm).c / obj.spins(to).c) * kex;
                
                %Now reset the Apparent R2
                obj.kex(frm,frm) = 0;
                obj.kex(to,to  ) = 0;
                c = sum( obj.kex, 2); 
                obj.kex(frm,frm) = c(frm);
                obj.kex(to, to ) = c(to );
                               
                if length(varargin) == 2
                    obj.kex_lb( frm, to ) = varargin{1};
                    obj.kex_ub( frm, to ) = varargin{2};
                end
                
            end
        end
        
        function M0 = run( obj, pulseq)
           assert( isa(pulseq,'PulseSequence') );
           assert( isa( pulseq.sequence{end}, 'END') );
           
           %Assemble the M0 vector
           M0=ones( 1, (3*length(obj.spins))+1); 
           for i = 1:length( obj.spins)
                num= (3*(i-1))+1;
                M0(1,num:num+2) = obj.spins(i).I;
           end
           M0=M0';
           %Setup and run the Bloch matrix, reassigning M0
           
           pls = pulseq.next();
           while ~isa( pls, 'END')
               dmtrx = obj.dM( pls.B1, pulseq.B0, pls.nuclei, pls.o1);
               M0 = (expm( pls.t*dmtrx) * M0);
               pls = pulseq.next();
           end
           
           for i = 1:length( obj.spins)
                num= (3*(i-1))+1;
                obj.spins(i).I_vec = M0(num:num+2)'/obj.spins(i).c ; 
           end
           
           
        end
        
        %Function dM returns the Bloch equations in matrix form describing
        %the evolution of spin magnitization under the influence of the 
        %magnetic field B.
        %If additional argument is provided the [x, y] componets of B are
        %applied at the freqency offset varargin{1} in Hz
        function dM = dM(obj, B1_hz, B0, nuc, dw1 )
            
            assert( or( ismember(nuc, properties( GyromagneticRatio )),  strcmp('',nuc) ) );
            
            sz = length( obj.spins );
            dM = zeros( (3*sz)+1, (3*sz)+1 );
            for i = 1:sz %Go through each spin
                
                
                x = (3*(i-1))+1;
                y = (3*(i-1))+2;
                z = (3*(i-1))+3;
                
                if  or( strcmp('',nuc), ~strcmp( obj.spins(i).nucli, nuc) ) 
                    B = [0, 0];
                else
                    B = B1_hz;
                end
                
                
                %Set the paramters for dM_a = param*dM_a
                dM(x,x) = -(obj.spins(i).R2 + obj.kex(i,i));
                dM(x,y) = -2*pi*(obj.spins(i).w0( B0 ) - dw1);
                dM(x,z) =  B(2);
                
                dM(y,y) = -(obj.spins(i).R2 + obj.kex(i,i));
                dM(y,x) =  2*pi*(obj.spins(i).w0( B0 ) - dw1);
                dM(y,z) = -B(1);
                
                dM(z,z) = -(obj.spins(i).R1 + obj.kex(i,i));
                dM(z,x) = -B(2);
                dM(z,y) =  B(1);
                
                dM(z,end)=  obj.spins(i).c  * obj.spins(i).R1;
                
                %Set paramters for exchange between spins
                for ii = 1:sz
                    if ii == i, continue
                    
                    else    
                    ox = (3*(ii-1))+1;
                    oy = (3*(ii-1))+2;
                    oz = (3*(ii-1))+3;
                    
                    dM(x,ox)=obj.kex(ii,i);
                    dM(y,oy)=obj.kex(ii,i);
                    dM(z,oz)=obj.kex(ii,i);
                    end
                end
            end
        end
        
        
        
        %% Optimization Stuff
        %The following functions are interface rountines for optimiation
        %algorithms
        
        %The function get_x0 assembles a guess, lb, and ub using the
        %parameters contained in SpinObjs ( c, R1, R2, w0 ) and this Bloch
        %sim kex's
        function [x,lb,ub] = get_x0(obj)
            x=[]; lb=[]; ub=[];
            %first collect starting parameters from spins
            for thisSpin=obj.spins
                params = thisSpin.opt_vals.keys; %Find parameters to be fit
                for n=1:length(params)
                    mem = params(n);
                    if thisSpin.opt_vals( mem{1} )
                        x(end+1) = thisSpin.( mem{1} );
                        limit = thisSpin.limit( mem{1} );
                        lb(end+1)= limit{1};
                        ub(end+1)= limit{2};
                    end
                end
            end
            %Now collect starting parameters for kex
            [row,col]=find(obj.kex_ub);
            for indx = 1:length(row)
                x(end+1) = obj.kex( row(indx), col(indx) );
                lb(end+1)= obj.kex_lb( row(indx), col(indx) );
                ub(end+1)= obj.kex_ub( row(indx), col(indx) );
            end
        end
        
        %The function set_x0 updates the values of the Bloch's SpinObj's
        %and Rmtx based upon the definition of x0 defined by the order of get_x0
        function all = set_x0(obj, x0)
            count=1;
           for thisSpin=obj.spins
                params = thisSpin.opt_vals.keys; %Find parameters to be fit
                for n=1:length(params)
                    mem = params(n);
                    if thisSpin.opt_vals( mem{1} )
                        thisSpin.( mem{1} ) = x0(count);
                        count=count+1;
                    end
                end
           end
            %Now collect starting parameters for kex
            [row,col]=find(obj.kex_ub);
            for indx = 1:length(row)
                obj.add_kex( row(indx), col(indx), x0(count) );
                count=count+1;
            end
            
            for i = 1:length( row )
                if row(i) > col(i)
                    obj.add_kex( row(i), col(i), obj.kex(row(i), col(i) ) );
                end
            end
            
            if ( count-1 ~= length(x0) );
                all = 0;
            else
                all = 1;
            end
            
        end 
        
    end
    
    
    
end
    
    

