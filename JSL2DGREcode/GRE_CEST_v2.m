classdef GRE_CEST_v2
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    datasets;
    end
    
    methods
       
        
        function obj = GRE_CEST_v2( varargin )
            obj.datasets = GRE.empty(0,nargin);
            for k=1:nargin, obj.datasets(k) = varargin{k}; end   
        end
        
        function obj = set_S0( obj, S0_GRE )
            for i = 1:length(obj.datasets)
                for n = 1:obj.datasets(i).Nexp
                    obj.datasets(i).imgs(:,:,n) = 1-(obj.datasets(i).imgs(:,:,n)./S0_GRE.imgs);
                end
            end
        
        end
        
        
    end
end
