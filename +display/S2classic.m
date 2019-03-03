function figs = S2classic(S2)
%S2 Summary of this function goes here

    nbScales = length(S2);
    [~,~,nHL] = size(S2{1});
    
    s2Max = 0;
    s2Min = inf;
    
    for scale=1:nbScales
        currentMax = max(S2{scale}(:));
        currentMin = min(S2{scale}(:));
        
        if s2Max < currentMax
            s2Max = currentMax;
        end
        
        if s2Min > currentMin
            s2Min = currentMin;
        end
    end
    
    figs = zeros(nbScales);
    for scale=1:nbScales
        figs(scale) = figure;
        o = 1;
        imaf = [];
        [w, h] = size(S2{scale}(:,:,1));
        for i = 1 : ceil(sqrt(nHL))
            buff = [];
            for j = 1 : ceil(sqrt(nHL))
                try 
                    imgS2 = S2{scale}(:,:,o);
                    imgS2 = imgS2-min(imgS2(:));
                    imgS2 = imgS2 ./ max(imgS2(:));
                    imgS2 = 1-(imgS2); % convert from a distance map to an activation map (high distance between filter and patch = low activation)
                    buff = horzcat(buff, imgS2);
                catch
                    buff = horzcat(buff, zeros(w, h));
                end
                o = o + 1;
            end
            imaf = vertcat(imaf, buff);
        end

        imshow(imaf);
        a = axes;
        t1 = title(sprintf('S2 | Scale = %d', scale));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

