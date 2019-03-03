function [] = hlFiltersClassic(HLFilters)
%HLFILTERS Summary of this function goes here
    nbFilters = length(HLFilters);
    [preW, preH, nbOrientations] = size(HLFilters{1}); % Previus width and height

%     for i = 1:nbOrientations
%         figure
%         for j = 1:16
%             subplot(4, 4, j)
%             imshow(HLFilters{helpers.randInt(1, nbFilters)}(:,:,i), []);
%         end
%     end

    cpt = 1;
    [curW, curH, ~] = size(HLFilters{1});
    buff = [];
    imaf = cell(0);
    for ii = 1:nbFilters
        filter = sum(HLFilters{ii}, 3);
        [curW, curH] = size(filter); % Current width and height
        if (preW ~= curW || preH ~= curH)
            %figure();
            %imshow(buff);
            imaf{cpt} = buff;
            cpt = cpt + 1;
            buff = [];
            preW = curW;
            preH = curH;
        end
        buff = horzcat(buff, filter);
    end
    
    figure();
    for ii = 1:cpt-1
        subplot(cpt, 1, ii);
        imshow(imaf{ii}, []);
    end
    % imshow(imaf, []);
end

