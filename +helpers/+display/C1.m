function C1(C1)
%C1 Display C1 layer

    [ ~, nbScales ] = size(C1);
    for scale= 1:nbScales
        [ ~, ~, nbOrientations ] = size(C1{scale});
        height = floor(sqrt(nbOrientations));
        width = ceil(nbOrientations/height);
        figure
        for iOrientation = 1:nbOrientations
          imaf = C1{scale}(:,:,iOrientation);
          subplot(height, width, iOrientation)
          imshow(imaf,[])
          title(sprintf('\\theta = %d°', iOrientation*(360/nbOrientations)));
        end
        a = axes;
        t1 = title(sprintf('C1 | Scale = %d', scale));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

