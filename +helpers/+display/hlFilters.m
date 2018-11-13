function [] = hlFilters(HLFilters)
%HLFILTERS Summary of this function goes here
    nbFilters = length(HLFilters);
    [~, ~, nbOrientations] = size(HLFilters{1});

    for i = 1:nbOrientations
        figure
        for j = 1:16
            subplot(4, 4, j)
            imagesc(HLFilters{helpers.randInt(1, nbFilters)}(:,:,i));
        end
    end
end

