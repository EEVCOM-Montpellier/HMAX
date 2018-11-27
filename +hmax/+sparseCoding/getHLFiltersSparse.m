function [HLfilters] = getHLFiltersSparse(C1s, parameters)

    import hmax.classic.*
    
	nimg = size(C1s,2);
    C1_bis = cell(1, nimg);
    
    for imgcpt=1:nimg
		c1 = C1s{imgcpt};
  
        c1tow = max(c1{1}, [], 3);
        [N, M] = size(c1tow);
        [fx, fy]=meshgrid(-M/2:M/2-1,-N/2:N/2-1);
        rho=sqrt(fx.*fx+fy.*fy);
        f_0=0.4*sqrt(N)*sqrt(M);
        filt=rho.*exp(-(rho/f_0).^4);
        
        imagew = zeros(N, M);
        If=fft2(c1tow);
        imagew(:,:)=real(ifft2(If.*fftshift(filt)));

        C1_bis{imgcpt}(:,:) = imagew;
    end

    variances = zeros(1, nimg);
    for j = 1:nimg
        tmp = C1_bis{imgcpt}(:, :);
        variances(j) = var(tmp(:));
    end
    for j = 1:nimg
        tmp = C1_bis{imgcpt}(:, :);
        C1_bis{imgcpt}(:, :) = sqrt(0.1)*tmp/sqrt(mean(variances(:)));
    end

    %%%%% Apply Sparse Coding algorithm %%%%%
    pars.display_images = true;
    pars.display_every = 1;
    pars.save_every = 1;
    pars.save_basis_timestamps = false;

    X = zeros(parameters.winsize^2,1); % define empty vector to store patches of all images
    for scalnimg = 1:nimg
        foonpatchint = size(X,2)-1;
        foonpatchim =  floor(parameters.nbPatches/nimg);
        if (scalnimg==nimg), foonpatchim = parameters.nbPatches-foonpatchint; end
        toconvert = C1_bis{scalnimg}(:,:);
        Y = hmax.sparseCoding.toImageArray(toconvert, parameters.winsize, foonpatchim);
        X = [X Y];
    end
    X(:,1) = []; % remove first column with zeros

    HLfilters = sparse_coding(X, parameters.nbFilters, parameters.beta, 'L1', [], parameters.nbIterations, parameters.batchSize, [], []);
end
