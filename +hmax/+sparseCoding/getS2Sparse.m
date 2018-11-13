function [ S2 ] = getS2Sparse( C1, HLfilters, winsize, beta, useGPU)

    if exist('useGPU', 'var') && useGPU
        X = zeros(winsize^2,1, 'gpuArray'); % define empty vector to store patches of all images
    else
        X = zeros(winsize^2,1); % define empty vector to store patches of all images
    end
    
    nbScales = length(C1);
    [~, ~, nbOrientations] = size(C1{1});
    
    for scal = 1:nbScales
        for th = 1:nbOrientations
            toconvert = C1{scal}(:,:,th);
            Y = im2col(toconvert,[winsize winsize],'sliding'); % extract non-overlapping patches for one C1
            X = [X Y];
        end
    end

    X(:,1) = []; % remove first column with zeros
    S2 = l1ls_featuresign (HLfilters, X, beta);
end 
