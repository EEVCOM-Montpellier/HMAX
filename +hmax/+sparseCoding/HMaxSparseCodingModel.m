classdef HMaxSparseCodingModel < hmax.classic.HMaxModel
    %HMAXSPARSECODINGMODEL Class representing a HMax model with sparse
    %coding extension

    properties
        sparseParameters
    end
    
    methods
        function obj = HMaxSparseCodingModel(gaborParameters, poolSizes, sparseParameters, hlFiltersLocation)
            %HMAXSPARSECODINGMODEL Construct an instance of this class
            addpath(genpath('./fast_sc/code/'));
            obj@ hmax.classic.HMaxModel(gaborParameters, poolSizes, hlFiltersLocation);
            obj.sparseParameters = sparseParameters;
        end

        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist(obj.hlFiltersLocation, 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load(obj.hlFiltersLocation);
                    obj.hlFilters = data.hlFilters;
                    hlFilters = obj.hlFilters;
                end
            end
        end

        function hlFilters = train(obj, images, sparseParameters, useGPU, useParallel)
            %TRAIN Train the HMax model to get HLFilters
            import hmax.classic.*
            
            %Sample images
            nbImages = length(images);
            if nbImages >= sparseParameters.nbFilters
                imagesSample = datasample(images, sparseParameters.nbFilters + 1, 'Replace', false);
            else
                imagesSample = datasample(images, sparseParameters.nbFilters + 1, 'Replace', true);
            end
            nbImgSample = length(imagesSample);
            c1s = cell(1, nbImgSample);

            %Compute C1s cards
            if exist('useParallel', 'var') && useParallel
                parfor ii = 1:nbImgSample
                    image = imcomplement(imagesSample{ii});
                    if size(image,3) == 3
                      image = im2double(rgb2gray(image));% Convert it to grayscale
                    else
                      image = im2double(image);
                    end
                    if ~useGPU
                        S1 = getS1(image, obj.GaborFilters());
                        c1s{ii} = getC1(S1, obj.poolSizes, false);
                    else
                        image = gpuArray(image);
                        S1 = getS1(image, obj.GaborFilters());
                        c1s{ii} = getC1(S1, obj.poolSizes, useGPU);
                    end
                end
            else
                for ii = 1:nbImgSample
                    image = imagesSample{ii};
                    if size(image,3) == 3
                      image = im2double(rgb2gray(image));% Convert it to grayscale
                    else
                      image = im2double(image);
                    end
                    if ~exist('useGPU', 'var') || ~useGPU
                        S1 = getS1(image, obj.GaborFilters());
                        c1s{ii} = getC1(S1, obj.poolSizes, false);
                    else
                        image = gpuArray(image);
                        S1 = getS1(image, obj.GaborFilters());
                        c1s{ii} = getC1(S1, obj.poolSizes, useGPU);
                    end
                end
            end

            obj.hlFilters = hmax.sparseCoding.getHLFiltersSparse(c1s, sparseParameters);
            hlFilters = obj.hlFilters;
            obj.sparseParameters = sparseParameters;
            save(obj.hlFiltersLocation, 'hlFilters');
        end
        
        function encode(obj, image, useGPU, savefile, savetype)
            %ENCODE Encode the image with the 'classic' HMax algorithm
            %   Detailed explanation goes here            import hmax.classic.*
            import hmax.sparseCoding.*
            import hmax.classic.*
            
            image = imcomplement(image);
            if size(image,3) == 3
                image = im2double(rgb2gray(image));% Convert it to grayscale
            else
                image = im2double(image);
            end
            
            if ~exist('useGPU', 'var') || ~useGPU
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, false);
                if (exist('savefile', 'var') && exist('save', 'var') && savetype == "all")
                    savetype(savefile, "S1", "C1");
                end
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, false);
                clear('C1');
                C2 = getC2Sparse(S2);
                if (exist('savefile', 'var') && exist('savetype', 'var') && savetype == "all")
                    save(savefile, "S2", "C2", '-append');
                elseif exist('savefile', 'var')
                    save(savefile, "C2");
                end
                clear('S2');
            else
                image = gpuArray(image);
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, useGPU);
                if (exist('savefile', 'var') && exist('savetype', 'var') && savetype == "all")
                    save(savefile, "S1", "C1");
                end
                clear('S1');
                S2 = getS2Sparse(C1, obj.HLFilters(), obj.sparseParameters.winsize, obj.sparseParameters.beta, useGPU);
                clear('C1');
                C2 = getC2Sparse(S2);
                if (exist('savefile', 'var') && exist('savetype', 'var') && savetype == "all")
                    save(savefile, "S2", "C2", '-append');
                elseif exist('savefile', 'var')
                    save(savefile, "C2");
                end
                clear('S2');
            end
            if exist('savefile', 'var')
                save(savefile, 'C2');
            end
        end
    end
end

