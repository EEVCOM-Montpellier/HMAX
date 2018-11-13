function X = toImageArray(IMAGE, winsize, num_patches)

[h, w]=size(IMAGE);
sz= winsize;
BUFF=4;

totalsamples = 0;
% extract subimages at random from this image to make data vector X
% Step through the images
X= zeros(sz^2, num_patches);

this_image=IMAGE;

% Determine how many patches to take
getsample = num_patches-totalsamples;

    % Extract patches at random from this image to make data vector X
    for j=1:getsample
        r=BUFF+ceil((h-sz-2*BUFF)*rand);
        c=BUFF+ceil((w-sz-2*BUFF)*rand);
        totalsamples = totalsamples + 1;
        temp =reshape(this_image(r:r+sz-1,c:c+sz-1),sz^2,1);
        X(:,totalsamples) = temp - mean(temp);
    end
end
