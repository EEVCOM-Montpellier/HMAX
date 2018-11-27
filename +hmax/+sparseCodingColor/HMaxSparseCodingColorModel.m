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
        
        function hlFilters = train(obj, images, sparseParameters, useGPU, useParallel)
            %TRAIN Train the HMax model to get HLFilters
            import hmax.color.*
            
            %Sample images
            nbImages = length(images);
            if nbImages >= sparseParameters.nbFilters
                imagesSample = datasample(images, sparseParameters.nbFilters + 1, 'Replace', false);
            else
                imagesSample = datasample(images, sparseParameters.nbFilters + 1, 'Replace', true);
            end
            nbImgSample = length(imagesSample);

            %Compute C1s cards
            if exist('useParallel', 'var') && useParallel
                c1s_tmp = cell(nbImgSample, 1);
                parfor ii = 1:nbImgSample; c1s_tmp{ii} = cell(obj.NbChannels/2, 1);end
                parfor ii = 1:nbImgSample
                    image = imagesSample{ii};
                    image = im2double(image);% Convert it to grayscale
                    if ~useGPU
                        SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                        DO = getDODescriptor(SO, obj.GaborFilters());
                        [nbChans, nbScales] = size(DO);
                        for chan = 1:nbChans
                            tmp = cell(1, nbScales);
                            for i = 1:nbScales; tmp{i} = DO{chan, i};end
                            c1s_tmp{ii}{chan} = hmax.classic.getC1(tmp, obj.poolSizes, false);
                        end
                    else
                        image = gpuArray(image);
                        SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                        DO = getDODescriptor(SO, obj.GaborFilters());
                        [nbChans, nbScales] = size(DO);
                        for chan = 1:nbChans
                            tmp = cell(1, nbScales);
                            for i = 1:nbScales; tmp{i} = DO{chan, i};end
                            c1s_tmp{ii}{chan} = hmax.classic.getC1(tmp, obj.poolSizes, false);
                        end
                    end
                end
                c1s = cell(obj.NbChannels/2, nbImgSample);
                for ii = 1:nbImgSample
                    for jj = 1:obj.NbChannels/2
                        c1s{jj, ii} = c1s_tmp{ii}{jj};
                    end
                end
            else
                c1s = cell(obj.NbChannels/2, nbImgSample);
                for ii = 1:nbImgSample
                    image = imagesSample{ii};
                    image = im2double(image);% Convert it to grayscale
                    if ~useGPU
                        SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                        DO = getDODescriptor(SO, obj.GaborFilters());
                        [nbChans, nbScales] = size(DO);
                        for chan = 1:nbChans
                            tmp = cell(1, nbScales);
                            for i = 1:nbScales; tmp{i} = DO{chan, i};end
                            c1s{chan,ii} = hmax.classic.getC1(tmp, obj.poolSizes, false);
                        end
                    else
                        image = gpuArray(image);
                        SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                        DO = getDODescriptor(SO, obj.GaborFilters());
                        [nbChans, nbScales] = size(DO);
                        for chan = 1:nbChans
                            tmp = cell(1, nbScales);
                            for i = 1:nbScales; tmp{i} = DO{chan, i};end
                            c1s{chan,ii} = hmax.classic.getC1(tmp, obj.poolSizes, false);
                        end
                    end
                end
            end
            
            %Compute HL Filters
            obj.hlFilters = cell(1, obj.NbChannels/2);
            for chan = 1:obj.NbChannels/2
                C1 = cell(1, nbImgSample);
                for jj = 1:nbImgSample; C1{jj} = c1s{chan, jj}; end
                obj.hlFilters{chan} = hmax.sparseCoding.getHLFiltersSparse(C1, sparseParameters);
            end

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
                SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
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

