function S1(S1)
%S1 Summary of this function goes here

    [ ~, nbScales ] = size(S1);
    for scale= 1:nbScales
        [ ~, ~, nbOrientations ] = size(S1{scale});
        height = floor(sqrt(nbOrientations));
        width = ceil(nbOrientations/height);
        figure
        for iOrientation = 1:nbOrientations
          imaf = S1{scale}(:,:,iOrientation);          
          subplot(height,width,iOrientation)			  
          imshow(imaf,[]); 
          title(sprintf('\\theta = %d°',  (iOrientation - 1)*(180/nbOrientations)));
        end
        a = axes;
        t1 = title(sprintf('S1 | Scale = %d', scale));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

