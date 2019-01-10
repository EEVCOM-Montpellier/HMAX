classdef HMaxModel < handle
    %HMAX.CLASSIC.HMAXMODEL Class representing a classic HMax model
    
    properties
        gaborParameters
        poolSizes
        imageSize
    end
    
    properties (Access = protected)
      nbScales
      hlFilters
      gaborFilters
      len_string = 0
    end

    methods
        function obj = HMaxModel(gaborParameters, poolSizes)
            %HMAXMODEL Construct an instance of this class
            obj.gaborParameters = gaborParameters;
            obj.poolSizes = poolSizes;
        end
        
        function nbScales = NbScales(obj)
            if ~exist(obj.nbScales, 'var')
                obj.nbScales = min([ ...
                    obj.gaborParameters.NbScales(), ...
                    length(obj.poolSizes) ...
                ]);
            end
            nbScales = obj.nbScales;
        end        
        
        function gaborFilters = GaborFilters(obj)
            import hmax.classic.*
            if ~exist('obj.gaborFilters', 'var')
                obj.gaborFilters = getGaborFilters(obj.gaborParameters);
                gaborFilters = obj.gaborFilters;
                save('data/classic_gaborFilters.mat', 'gaborFilters');
            end
        end

        function hlFilters = HLFilters(obj)
            if ~exist('obj.hlFilters', 'var')
                if ~exist('data/classic_hlFilters.mat', 'file')
                    throw(MException('HMax:ModelNotTrained','You need to train the model before use it'));
                else
                    data = load('data/classic_hlFilters.mat');
                    obj.hlFilters = data.hlFilters;
                    hlFilters = obj.hlFilters;
                end
            end
        end
        
        function hlFilters = train(obj, images, hlParameters, useGPU, useParallel)
            %TRAIN Train the HMax model to get HLFilters
            import hmax.classic.*
            
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
            c1s = cell(1, nbImgSample);

            %Compute C1s cards
            if exist('useParallel', 'var') && useParallel
                parfor ii = 1:nbImgSample
                    image = imagesSample{ii};
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
            
            %Compute HL Filters
            obj.hlFilters = getHLFilters(c1s, hlParameters);
            hlFilters = obj.hlFilters;
            save('data/classic_hlFilters.mat', 'hlFilters');
        end

        function encode(obj, image, useGPU, savefile)
            %ENCODE Encode the image with the 'classic' HMax algorithm
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
                    save(savefile, 'S1', 'C1');
                end
                clear('S1');
                S2 = getS2(C1, obj.HLFilters(), false);
                clear('C1');
                C2 = getC2(S2, false);
                if exist('savefile', 'var')
                    save(savefile, "S2", "C2", '-append');
                end
                clear('S2');
            else
                image = gpuArray(image);
                S1 = getS1(image, obj.GaborFilters());
                C1 = getC1(S1, obj.poolSizes, useGPU);
                if exist('savefile', 'var')
                    save(savefile, "S1", "C1");
                end
                clear('S1');
                S2 = getS2(C1, obj.HLFilters(), useGPU);
                clear('C1');
                C2 = getC2(S2, useGPU);
                if exist('savefile', 'var')
                    save(savefile, "S2", "C2", '-append');
                end
                clear('S2');
            end
        end
        
        function showProgression (obj, ~, ~, nbImages, savefiles)
            counter = 0;
            for ii = 1: length(savefiles)
                if isfile(savefiles(ii))
                    counter = counter + 1;
                end
            end
            etr = ceil(3.3671893939393939393939393939394 * (nbImages - counter)/60);
            for ii = 2:obj.len_string
                fprintf('\b');
            end
            string = [int2str(counter) '/' int2str(nbImages) ' (~' int2str(round(100*counter/nbImages)) '%%) - Estimated time remaining: ' int2str(etr) ' minutes'];
            obj.len_string = length(string);
            fprintf(string);
        end

        function encodeMultiples(obj, images, useGPU, useParallel, savefiles)
            %ENCODEMULTIPLES Encode several images with the 'classic' HMax algorithm
            if exist('savefiles', 'var')
                nbImages = min(length(images), length(savefiles));
                if useParallel
                    t = timer;
                    t.Period = 5;
                    t.StartDelay = 10;
                    t.TimerFcn = {@obj.showProgression, nbImages, savefiles};
                    t.ExecutionMode = 'fixedSpacing';
                    start(t);
                    
                    try
                        parfor ii = 1:nbImages
                            obj.encode(images{ii}, useGPU, savefiles{ii});
                        end
                    catch e
                        stop(t);
                        disp(e.getReport());
                    end
                    stop(t);
                    clear('t');
                else
                    for ii = 1:nbImages
                        obj.encode(images{ii}, useGPU, savefiles{ii});
                    end
                end
            else
                nbImages = length(images);
                if exist('useParallel', 'var') && useParallel
                    parfor ii = 1:nbImages
                        obj.encode(images{ii}, useGPU, savefiles{ii});
                    end
                else
                    if ~exist('useGPU', 'var')
                        for ii = 1:nbImages
                            obj.encode(images{ii}, false);
                        end
                    else
                        for ii = 1:nbImages
                            obj.encode(images{ii}, useGPU);
                        end
                    end
                end
            end
        end
    end
end