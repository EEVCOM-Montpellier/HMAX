function SO(SO)
%SO Summary of this function goes here

    [ ~, nbScales ] = size(SO);
    for scale= 1:nbScales
        [ ~, ~, nbOrientations, nbChans] = size(SO{scale});
        height = nbOrientations;
        width = nbChans;
        figure
        iFig = 1;
        for iOrientation = 1:nbOrientations
            for iChan = 1 : nbChans
                imaf = SO{scale}(:,:,iOrientation, iChan);          
                subplot(height,width,iFig);
                iFig = iFig + 1;
                imshow(imaf,[]); 
                title(sprintf('\\theta = %d°, Chan = ',  (iOrientation - 1)*(180/nbOrientations), iChan));
            end
        end
        a = axes;
        t1 = title(sprintf('S0 | Scale = %d', scale));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

