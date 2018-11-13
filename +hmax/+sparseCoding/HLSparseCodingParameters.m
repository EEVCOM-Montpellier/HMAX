classdef HLSparseCodingParameters
    %HL Parameters for Sparse Coding

    properties
        winsize
        nbPatches
        batchSize
        nbIterations
        beta
        nbFilters
    end
    
    methods
        function obj = HLSparseCodingParameters(winsize, nbPatches, batchSize, ...
                                     nbIterations, beta, nbFilters)
            obj.winsize = winsize;
            obj.nbPatches = nbPatches;
            obj.batchSize = batchSize;
            obj.nbIterations = nbIterations;
            obj.beta = beta;
            obj.nbFilters = nbFilters;
        end
    end
    
end

