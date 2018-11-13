function S2(S2)
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
            
    for cpt=1:10
        figure
        for scale=1:nbScales
            imgS2 = S2{scale}(:,:,cpt);        
            imgS2 = imgS2-s2Min;
            imgS2 = imgS2 ./ s2Max;             
            imgS2 = 1-(imgS2); % convert from a distance map to an activation map (high distance between filter and patch = low activation)
            subplot(ceil(sqrt(nbScales+1)),ceil(sqrt(nbScales+1)), scale) 
            imshow(imgS2)
            title(sprintf('Scale = %d', i));
        end
        a = axes;
        t1 = title(sprintf('S2 | Filter = %d', cpt));
        set(a,'Visible','off');
        set(t1,'Visible','on');
    end
end

