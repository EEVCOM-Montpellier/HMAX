function image = resizeImage(image, sizeWanted)
%RESIZEIMSQUARE Resize image 
    [width, height, ~] = size(image);
    if width > height
        image = imresize(image, [sizeWanted NaN]);
    else
        image = imresize(image, [NaN sizeWanted]);
    end
end

