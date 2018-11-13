function image = resizeImSquare(image, sizeWanted)
%RESIZEIMSQUARE Resize image but with a square format
    [height, width, ~] = size(image);
    if width > height
        image = imresize(image, [sizeWanted NaN]);
         [~, width, ~] = size(image);
         image = imcrop(image, [width/2 - sizeWanted/2, 0, sizeWanted, sizeWanted]);
    else
        image = imresize(image, [NaN sizeWanted]);
         [height, ~, ~] = size(image);
         image = imcrop(image, [0, height/2 - sizeWanted/2, sizeWanted, sizeWanted]);
    end
end

