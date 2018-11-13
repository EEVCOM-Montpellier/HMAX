classdef HMaxSparseCodingColorModel < hmax.color.HMaxColorModel
    %HMAXSPARSECODINGCOLORMODEL Class representing a HMax model with sparse
    %coding and color extensions
    
    properties
        sparseParameters
    end
    
    methods
        function obj = HMaxSparseCodingColorModel(gaborParameters, poolSizes, W, outChansHalf, sparseParameters)
            %HMAXSPARSECODINGCOLORMODEL Construct an instance of this class
            addpath(genpath('./fast_sc/code/'));
             obj@ hmax.color.HMaxColorModel(gaborParameters, poolSizes, W, outChansHalf);
             obj.sparseParameters = sparseParameters;
        end
        
        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist('data/sparseCodingColor_hlFilters.mat', 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load('data/sparseCodingColor_hlFilters.mat');
                    obj.hlFilters = data.hlFilters;
                    hlFilters = obj.hlFilters;
                end
            end
        end
        
        function hlFilters = train(obj, images, sparseParameters)
            %TRAIN Train the HMax model to get HLFilters
            
            for ii = 1:length(images)
                images{ii} = im2double(images{ii});
            end
            
            obj.hlFilters = hmax.sparseCodingColor.getHLfiltersSparseColor(images, sparseParameters, obj.W, obj.outChansHalf , obj.GaborFilters(), obj.poolSizes);
            hlFilters = obj.hlFilters;
            obj.sparseParameters = sparseParameters;
            save('data/sparseCodingColor_hlFilters.mat', 'hlFilters');
        end
        
        function encode(obj, image, useGPU, savefile)
            %ENCODE
            import hmax.classic.*
            import hmax.color.*
            import hmax.sparseCoding.*
            
            image = im2double(image);

            hlFilters = obj.HLFilters();
            if ~exist('useGPU', 'var') || ~useGPU
                SO = getSODescriptor(image, obj.W, obj.outChansHalf, obj.GaborFilters());
                DO = getDODescriptor(SO, obj.GaborFilters());
                [nbChans, nbScales] = size(DO);
                C1 = cell(1, nbChans); S2 = cell(1, nbChans); C2 = cell(1, nbChans);
                for chan = 1:nbChans
                    tmp = cell(1, nbScales);
                    for i = 1:nbScales; tmp{i} = DO{chan, i};end
                    C1{chan} = getC1(tmp, obj.poolSizes, false);
                    S2{chan} = getS2Sparse(C1{chan}, hlFilters{chan}, obj.sparseParameters.winsize, obj.sparseParameters.beta, false);
                    C2{chan} = getC2Sparse(S2{chan});
                end
            else
                image = gpuArray(image);
                SO = getSODescriptor(image, obj.W, obj.outChansHalf, obj.GaborFilters());
                DO = getDODescriptor(SO, obj.GaborFilters());
                C1 = cell(1, nbChan); S2 = cell(1, nbChan); C2 = cell(1, nbChan);
                for chan = 1:nbChan
                    C1{chan} = getC1(DO{chan}, obj.poolSizes, useGPU);
                    S2{chan} = getS2Sparse(C1{chan}, hlFilters{chan}, obj.sparseParameters.winsize, obj.sparseParameters.beta, useGPU);
                    C2{chan} = getC2(S2);
                end
            end
            if exist('savefile', 'var')
                save(savefile, 'C2');
            end
        end
        
    end
end

