function SO(SO)
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
    greenredmap = [1 0 0
                    0.9 0.1 0
                    0.8 0.2 0
                    0.7 0.3 0
                    0.6 0.4 0
                    0.5 0.5 0
                    0.4 0.6 0
                    0.3 0.7 0
                    0.2 0.8 0
                    0.1 0.9 0
                    0 1 0];
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
    yellowbluemap = [0 0 1
                    0.1 0.1 0.9
                    0.2 0.2 0.8
                    0.3 0.3 0.7
                    0.4 0.4 0.6
                    0.5 0.5 0.5
                    0.6 0.6 0.4
                    0.7 0.7 0.3
                    0.8 0.8 0.2
                    0.9 0.9 0.1
                    1 1 0];
	blackwhitemap = [0 0 0
                    0.1 0.1 0.1
                    0.2 0.2 0.2
                    0.3 0.3 0.3
                    0.4 0.4 0.4
                    0.5 0.5 0.5
                    0.6 0.6 0.6
                    0.7 0.7 0.7
                    0.8 0.8 0.8
                    0.9 0.9 0.9
                    1 1 1];
    whiteblackmap = [1 1 1
                    0.9 0.9 0.9
                    0.8 0.8 0.8
                    0.7 0.7 0.7
                    0.6 0.6 0.6
                    0.5 0.5 0.5
                    0.4 0.4 0.4
                    0.3 0.3 0.3
                    0.2 0.2 0.2
                    0.1 0.1 0.1
                    0 0 0];
    maps = {redgreenmap, greenredmap, blueyellowmap, yellowbluemap};
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
                colormap(gca, maps{iChan});
                title(sprintf('\\theta = %d°, Chan = %d',  (iOrientation - 1)*(180/nbOrientations), iChan));
            end
        end
        a = axes;
        t1 = title(sprintf('S0 | Scale = %d', scale));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

