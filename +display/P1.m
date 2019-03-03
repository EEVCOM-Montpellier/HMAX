function fig = P1(P1)
%P1 Display "phase 1" layers (C1 and S1 maps)

    [ ~, nbScales] = size(P1);
    fig = figure('Name', 'Phase 1');
    for scale= 1:nbScales
        subplot(ceil(sqrt(nbScales)), ceil(sqrt(nbScales)), scale);
        [w, h, nbOrientations ] = size(P1{scale});
        
        o = 1;
        imaf = [];
        for i = 1 : ceil(sqrt(nbOrientations))
            buff = [];
            for j = 1 : ceil(sqrt(nbOrientations))
                try 
                    buff = horzcat(buff, P1{scale}(:,:,o));
                catch
                    buff = horzcat(buff, zeros(w, h));
                end
                o = o + 1;
            end
            imaf = vertcat(imaf, buff);
        end
        imshow(imaf,[]);

        title(sprintf('Scale = %d', scale));
    end
end
