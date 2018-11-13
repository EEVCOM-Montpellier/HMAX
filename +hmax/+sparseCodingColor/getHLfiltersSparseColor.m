function [hlFilters] = getHLfiltersSparseColor(images, parameters, W, outChansHalf, gaborFilters, gaborFiltersSO, poolSizes)

    import hmax.color.*
    import hmax.classic.getC1;
    
	nbImages = size(images,2);
    nbScales = length(gaborFilters);
    [~, ~, nbOrientations, ~] = size(gaborFilters{1});
    C1 = cell(nbImages, outChansHalf, nbScales-1);
    
    for ii=1:nbImages
        SO = getSODescriptor(images{ii}, W, outChansHalf, gaborFiltersSO);
        DO = getDODescriptor(SO, gaborFilters);
        [nbChans, nbScales] = size(DO);
        C1tmp = cell(1, nbChans);
        for chan = 1:nbChans
            tmp = cell(1, nbScales);
            for i = 1:nbScales; tmp{i} = DO{chan, i};end
            C1tmp{chan} = getC1(tmp, poolSizes, false);
        end

        for scale=1:nbScales-1
            for chan = 1:nbChans
                C1{ii, chan, scale}(:,:,:) = C1tmp{chan}{scale}(:,:,:);
            end
        end
    end
    
    %%%%% Apply Sparse Coding algorithm %%%%%
    pars.display_images = true;
    pars.display_every = 1;
    pars.save_every = 1;
    pars.save_basis_timestamps = false;
    
    hlFilters = cell(1,outChansHalf);
    for chan = 1:outChansHalf 
         X = zeros(parameters.winsize^2,1); % define empty vector to store patches of all images     
         for scale = 1:nbScales-1
             for imgii = 1:nbImages
                 for th = 1:nbOrientations
                    npatchint = size(X,2)-1;
                    npatchim =  floor(parameters.nbPatches/nbImages/(nbScales-1)/nbOrientations);
                    if (scale==(nbScales-1) && imgii == nbImages && th == nbOrientations), npatchim = parameters.nbPatches-npatchint; end
                    toconvert = double((C1{imgii, chan, scale}(:,:,th)));
                    Y = getdata_imagearray(toconvert, parameters.winsize, npatchim);
                    X = [X Y];              
                 end
             end
         end
         X(:,1) = [];

        fprintf('create dictionnary of channel %d \n',chan);
        [spHLfilters, ~, ~] = sparse_coding(X, parameters.nbFilters, parameters.beta, 'L1', [], parameters.nbIterations, parameters.batchSize, [], []);
        hlFilters{chan} = spHLfilters;
    end
 end
