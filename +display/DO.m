function DO(DO)
%SO Summary of this function goes here
    redgreenmap = [0 1 0
                    0.1 0.9 0
                    0.2 0.8 0
                    0.3 0.7 0
                    0.4 0.6 0
                    0.5 0.5 0
                    0.6 0.4 0
                    0.7 0.3 0
                    0.8 0.2 0
                    0.9 0.1 0
                    1 0 0];
    blueyellowmap = [1 1 0
                    0.9 0.9 0.1
                    0.8 0.8 0.2
                    0.7 0.7 0.3
                    0.6 0.6 0.4
                    0.5 0.5 0.5
                    0.4 0.4 0.6
                    0.3 0.3 0.7
                    0.2 0.2 0.8
                    0.1 0.1 0.9
                    0 0 1];
    maps = {redgreenmap, blueyellowmap};

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
                colormap(gca, maps{iChan});
                title(sprintf('\\theta = %d°, Chan = %d',  (iOrientation - 1)*(180/nbOrientations), iChan));
            end
            a = axes;
            t1 = title(sprintf('D0 | Scale = %d', scale));
            set(a,'Visible','off');
            set(t1,'Visible','on');
        end
    end
end

