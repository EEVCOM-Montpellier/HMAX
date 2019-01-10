classdef HMaxClassicSparseCodingModel < hmax.classic.HMaxModel
    %HMAXCLASSICSPARSECODINGMODEL Class representing a HMax model with sparse
    %coding extension

    properties
        sparseParameters
    end
    
    methods
        function obj = HMaxClassicSparseCodingModel(gaborParameters, poolSizes, sparseParameters)
            %HMAXSPARSECODINGMODEL Construct an instance of this class
            addpath(genpath('./fast_sc/code/'));
            obj@ hmax.classic.HMaxModel(gaborParameters, poolSizes);
            obj.sparseParameters = sparseParameters;
        end
        
        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist('data/classic_hlFilters.mat', 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load('data/classic_hlFilters.mat');
                    obj.hlFilters = zeros(length(data.hlFilters{1}(:, 1, 1))*length(data.hlFilters{1}(1, :, 1)), length(data.hlFilters));
                    for ii = 1:length(data.hlFilters)
                        tmp = sum(data.hlFilters{ii}, 3);
                        tmp = tmp - mean(tmp);
                        tmp = tmp ./ std(tmp);
                        obj.hlFilters(:, ii) = tmp(:);
                    end
                    hlFilters = obj.hlFilters;
                end
            end
        end
        
        function encode(obj, image, useGPU, savefile)
            %ENCODE Encode the image with the 'classic' HMax algorithm
            import hmax.sparseCoding.*
            import hmax.classic.*

            if size(image,3) == 3
                image = im2double(rgb2gray(image));% Convert it to grayscale
            else
                image = im2double(image);
            end
            
            if ~exist('useGPU', 'var') || ~useGPU
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, false);
                if exist('savefile', 'var')
                    save(savefile, ["S1", "C1"], '-append');
                end
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, false);
                clear('C1');
                C2 = getC2Sparse(S2);
                if exist('savefile', 'var')
                    save(savefile, ["S2", "C2"], '-append');
                end
                clear('S2');
            else
                image = gpuArray(image);
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, useGPU);
                if exist('savefile', 'var')
                    save(savefile, ["S1", "C1"], '-append');
                end
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, useGPU);
                clear('C1');
                C2 = getC2Sparse(S2);
                if exist('savefile', 'var')
                    save(savefile, ["S2", "C2"], '-append');
                end
                clear('S2');
            end
        end
    end
end

