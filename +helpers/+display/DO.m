function DO(DO)
%SO Summary of this function goes here

    [ nbChans, nbScales ] = size(DO);
    for scale= 1:nbScales
        width = nbChans;
        figure
        iFig = 1;
        for iChan = 1 : nbChans
            [ ~, ~, nbOrientations] = size(DO{iChan, scale});
            height = nbOrientations;
            for iOrientation = 1:nbOrientations
                imaf = DO{iChan, scale}(:,:,iOrientation);
                subplot(height,width,iFig);
                iFig = iFig + 1;
                imshow(imaf,[]); 
                title(sprintf('\\theta = %d°, Chan = ',  (iOrientation - 1)*(180/nbOrientations), iChan));
            end
            a = axes;
            t1 = title(sprintf('D0 | Scale = %d', scale));
            set(a,'Visible','off');
            set(t1,'Visible','on');
        end
    end
end

