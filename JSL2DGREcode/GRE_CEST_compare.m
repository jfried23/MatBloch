classdef GRE_CEST_compare
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=public)
        inputs;
        spec;
    end
    
    methods
        function obj = GRE_CEST_compare( varargin )           
            obj.inputs = GRE_CEST.empty(0,nargin);
            for k=1:nargin, obj.inputs(k) = varargin{k}; end   
        end
        
        function obj = get_area( obj )
            [sp1, v] = obj.inputs(1).get_area();
             sp2     = obj.inputs(1).get_area(v);
             obj.spec=[sp1;sp2];
             
             figure(2);
             plot(obj.spec);
    
        end
        
        
    end
end

