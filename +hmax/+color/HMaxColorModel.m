classdef HMaxColorModel < hmax.classic.HMaxModel
    %HMAXCOLORMODEL Class representing a HMax model with color extension
    
    properties
        W
        NbChannels
    end

    methods
        function obj = HMaxColorModel(gaborParameters, poolSizes, W, NbChannels)
            %HMAXCOLORMODEL Construct an instance of this class
            obj@ hmax.classic.HMaxModel(gaborParameters, poolSizes);
            obj.W = W;
            obj.NbChannels = NbChannels;
        end

        function hlFilters = train(obj, images, hlParameters, useGPU, useParallel)
            %TRAIN Train the HMax model to get HLFilters
            import hmax.color.*
            for ii = 1:length(images)
                images{ii} = im2double(images{ii});
            end
            %Sample images
            nbFilterSizes = length(hlParameters.filterSizes);
            filtersPerSize = floor(hlParameters.nbFilters / nbFilterSizes);
            nbImages = length(images);
            if nbImages >= filtersPerSize
                imagesSample = datasample(images, filtersPerSize + 1, 'Replace', false);
            else
                imagesSample = datasample(images, filtersPerSize + 1, 'Replace', true);
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
                obj.hlFilters{chan} = hmax.classic.getHLFilters(C1, hlParameters);
            end
            hlFilters = obj.hlFilters;
            save('data/color_hlFilters.mat', 'hlFilters');
        end
        
        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist('data/color_hlFilters.mat', 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load('data/color_hlFilters.mat');
                    obj.hlFilters = data.hlFilters;
                    hlFilters = obj.hlFilters;
                end
            end
        end

        function encode(obj, image, useGPU, savefile, save)
            %ENCODE Encode the image with the 'classic' HMax algorithm
            import hmax.classic.*
            import hmax.color.*
            hlFilters = obj.HLFilters();
            image = im2double(image);
            if ~exist('useGPU', 'var') || ~useGPU
                SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                DO = getDODescriptor(SO, obj.GaborFilters());
                [nbChans, nbScales] = size(DO);
                C2 = cell(1, nbChans);
                for chan = 1:nbChans
                    tmp = cell(1, nbScales);
                    for i = 1:nbScales; tmp{i} = DO{chan, i};end
                    C1 = getC1(tmp, obj.poolSizes, false);
                    S2 = getS2(C1, hlFilters{chan}, false);
                    C2{chan} = getC2(S2, false);
                end
            else
                image = gpuArray(image);
                SO = getSODescriptor(image, obj.W, obj.NbChannels, obj.GaborFilters());
                DO = getDODescriptor(SO, obj.GaborFilters());
                C2 = cell(1, nbChan);
                for chan = 1:nbChan
                    C1 = getC1(DO{chan}, obj.poolSizes, useGPU);
                    S2 = getS2(C1, hlFilters{chan}, useGPU);
                    C2{chan} = getC2(S2, useGPU);
                end
            end
            if (exist('savefile', 'var') && exist('save', 'var') && save == "all")
                save(savefile, "SO", "DO", "C1", "S2", "C2");
            elseif exist('savefile', 'var')
                save(savefile, "C2");
            end
        end

    end
end

