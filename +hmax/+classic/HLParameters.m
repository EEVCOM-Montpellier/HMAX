classdef HLParameters
    %HL Parameters for HL filters

    properties
        nbFilters
        filterSizes
    end
    
    methods
        function obj = HLParameters(nbFilters, filterSizes)
            obj.nbFilters = nbFilters;
            obj.filterSizes = filterSizes;
        end
    end
    
end

