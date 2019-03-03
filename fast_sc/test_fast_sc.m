[images_train, ~] = helpers.readImages("../natural");
[images_test, paths] = helpers.readImages("../visages/panel1", "res_fastsc_panel1");

parameters.winsize = 12;
parameters.nbFilters = 100;
parameters.beta = 0.8;
parameters.nbIterations = 20;
parameters.batchSize = 1000;
parameters.nbPatches = 10000;

nbImages = length(images_train);
if nbImages >= parameters.nbFilters
    imagesSample = datasample(images_train, parameters.nbFilters + 1, 'Replace', false);
else
    imagesSample = datasample(images_train, parameters.nbFilters + 1, 'Replace', true);
end
nbImgSample = length(imagesSample);

parfor ii = 1:nbImgSample
    image = helpers.resizeImSquare(imagesSample{ii}, 512);
    if size(image,3) == 3
      image = im2double(rgb2gray(image));% Convert it to grayscale
    else
      image = im2double(image);
    end
    imagesSample{ii} = image;
end

images_bis = cell(1, nbImgSample);
for imgcpt=1:nbImgSample
    image = imagesSample{imgcpt};

    imagetow = image;
    [N, M] = size(imagetow);
    [fx, fy]=meshgrid(-M/2:M/2-1,-N/2:N/2-1);
    rho=sqrt(fx.*fx+fy.*fy);
    f_0=0.4*sqrt(N)*sqrt(M);
    filt=rho.*exp(-(rho/f_0).^4);

    imagew = zeros(N, M);
    If=fft2(imagetow);
    imagew(:,:)=real(ifft2(If.*fftshift(filt)));

    images_bis{imgcpt}(:,:) = imagew;
end

variances = zeros(1, nbImgSample);
for j = 1:nbImgSample
    tmp = images_bis{j}(:, :);
    variances(j) = var(tmp(:));
end
for j = 1:nbImgSample
    tmp = images_bis{j}(:, :);
    images_bis{j}(:, :) = sqrt(0.1)*tmp/sqrt(mean(variances(:)));
end

pars.display_images = true;
pars.display_every = 1;
pars.save_every = 1;
pars.save_basis_timestamps = false;

X = zeros(parameters.winsize^2,1); % define empty vector to store patches of all images
for scalnimg = 1:nbImgSample
    foonpatchint = size(X,2)-1;
    foonpatchim =  floor(parameters.nbPatches/nbImgSample);
    if (scalnimg==nbImgSample), foonpatchim = parameters.nbPatches-foonpatchint; end
    toconvert = images_bis{scalnimg}(:,:);
    Y = hmax.sparseCoding.toImageArray(toconvert, parameters.winsize, foonpatchim);
    X = [X Y];
end
X(:,1) = []; % remove first column with zeros

HLfilters = sparse_coding(X, parameters.nbFilters, parameters.beta, 'L1', [], parameters.nbIterations, parameters.batchSize, [], []);

%%
X = [];
for ii=1:length(images_test)
    toconvert = helpers.resizeImSquare(images_test{ii}, 512);
    toconvert = im2double(rgb2gray(toconvert));
    X = [X, im2col(toconvert,[parameters.winsize, parameters.winsize],'sliding')];
end
X(:,1) = [];
S2 = l1ls_featuresign (HLfilters, X, parameters.beta);
C2 = max(S2,[],2);
C2 = C2';
