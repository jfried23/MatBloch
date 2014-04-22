classdef ZSpecBlochSim < BlochSim
    %ZSpecBlochSim A wrapper class for preforming Z-Spectra Bloch Sims 
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function obj = ZSpecBlochSim( varargin )
            obj = obj@BlochSim( varargin{1:end} );
        end
        
        
        function zspec = run( obj, pulseq, pwr_list, o1_list )
            zspec=zeros( length(pwr_list), length(o1_list) );
                       
            for ip=1:length(pwr_list)
                for io=1:length(o1_list)
                   
                    for spn = obj.spins, spn.reset(); end
                    %Update the CEST Pulses
                    for pls=pulseq.sequence
                        if isa(pls{1}, 'CW')
                            pls{1}.B1_ = pwr_list(ip);
                            pls{1}.o1_ = o1_list(io);
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

