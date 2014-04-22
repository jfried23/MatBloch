classdef ZSpecBlochSim1331 < BlochSim
    %ZSpecBlochSim A wrapper class for preforming Z-Spectra Bloch Sims 
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function obj = ZSpecBlochSim1331( varargin )
            obj = obj@BlochSim( varargin{1:end} );
        end
        
        
        function zspec = run( obj, pulseq, ncycle_list, o1_list )
            zspec=zeros( length(ncycle_list), length(o1_list) );
            
            for io=1:length(o1_list)                    
                for spn = obj.spins, spn.reset(); end
                for ip=1:length(ncycle_list)
                    
                    if ip > 1
                        cycle_inc = ncycle_list(ip) - ncycle_list(ip-1);
                    else
                        cycle_inc = ncycle_list(ip);
                    end
                    
                    %Update the CEST Pulses
                    for pls=pulseq.sequence
                        if isa(pls{1}, 'CW')
                            pls{1}.o1_ = o1_list(io);
                        elseif isa( pls{1}, 'Loop' )
                            pls{1}.cycles = cycle_inc;
                        end
                    end
                    M= run@BlochSim(obj,pulseq);
                    zspec(ip,io) = M(3);
                end
                zspec(ip,:) = zspec(ip,:) - zspec(ip,1);
            end
           
        end
        
        
    end
    
end

