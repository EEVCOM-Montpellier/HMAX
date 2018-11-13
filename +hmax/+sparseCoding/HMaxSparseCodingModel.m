classdef HMaxSparseCodingModel < hmax.classic.HMaxModel
    %HMAXSPARSECODINGMODEL Class representing a HMax model with sparse
    %coding extension

    properties
        sparseParameters
    end
    
    methods
        function obj = HMaxSparseCodingModel(gaborParameters, poolSizes, sparseParameters)
            %HMAXSPARSECODINGMODEL Construct an instance of this class
            addpath(genpath('./fast_sc/code/'));
            obj@ hmax.classic.HMaxModel(gaborParameters, poolSizes);
            obj.sparseParameters = sparseParameters;
        end

        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist('data/sparseCoding_hlFilters.mat', 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load('data/sparseCoding_hlFilters.mat');
                    obj.hlFilters = data.hlFilters;
                    hlFilters = obj.hlFilters;
                end
            end
        end

        function hlFilters = train(obj, images, sparseParameters, useGPU, useParallel)
            %TRAIN Train the HMax model to get HLFilters
            for ii = 1:length(images)
                if size(images{ii},3) == 3
                    images{ii} = im2double(rgb2gray(images{ii}));% Convert it to grayscale
                else
                    images{ii} = im2double(images{ii});
                end
            end
            obj.hlFilters = hmax.sparseCoding.getHLFiltersSparse(images, sparseParameters, obj.GaborFilters(), obj.poolSizes);
            hlFilters = obj.hlFilters;
            obj.sparseParameters = sparseParameters;
            save('data/sparseCoding_hlFilters.mat', 'hlFilters');
        end
        
        function encode(obj, image, useGPU, savefile)
            %ENCODE Encode the image with the 'classic' HMax algorithm
            %   Detailed explanation goes here            import hmax.classic.*
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
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, false);
                clear('C1');
                C2 = getC2Sparse(S2);
                clear('S2');
            else
                image = gpuArray(image);
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, useGPU);
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, useGPU);
                clear('C1');
                C2 = getC2Sparse(S2);
                clear('S2');
            end
            if exist('savefile', 'var')
                save(savefile, 'C2');
            end
        end
    end
end

