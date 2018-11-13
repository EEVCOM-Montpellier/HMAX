function [hlFilters] = getHLFilters(c1s, parameters, useParallel)
%GETHLFILTER Compute HLFilters
    nbC1s = length(c1s);
    hlFilters = cell(1, parameters.nbFilters);
    nbFilterSizes = length(parameters.filterSizes);
    nbFilters = parameters.nbFilters;
    
    if exist('useParallel', 'var') && useParallel
        parfor ii = 1:nbFilters
            %Required data for sampling
            iC1 = floor(ii/nbFilterSizes) + 1;
            ifilter = floor((ii-0.000001)/(nbC1s - 1)) + 1; %This is a tweak
            C1 = c1s{iC1};
            filterSize = parameters.filterSizes(ifilter);
            [dsx, dsy, ~] = size(C1{1});
            maxX = dsx - filterSize;
            maxY = dsy - filterSize;
            if maxX <= 0 || maxY <=0
                throw(MException('HMAX: Filters size is bigger than activation map'));
            end
            rand_x = helpers.randInt(0, floor(2*maxX/filterSize));
            rand_y = helpers.randInt(0, floor(2*maxY/filterSize));
            sample_x = floor(1 + rand_x * filterSize/2);
            sample_y = floor(1 + rand_y * filterSize/2);
            hlFilters{ii} = C1{1}(sample_x:sample_x+filterSize-1, sample_y:sample_y+filterSize-1,:);
        end
    else
        for ii = 1:parameters.nbFilters
            %Required data for sampling
            iC1 = floor(ii/nbFilterSizes) + 1;
            ifilter = floor((ii-0.000001)/(nbC1s - 1)) + 1; %This is a tweak
            C1 = c1s{iC1};
            if ifilter > length(parameters.filterSizes)
                ifilter = length(parameters.filterSizes);
            end
            filterSize = parameters.filterSizes(ifilter);
            [dsx, dsy, ~] = size(C1{1});
            maxX = dsx - filterSize;
            maxY = dsy - filterSize;
            if maxX <= 0 || maxY <=0
                filterSize = parameters.filterSizes(1);
                maxX = dsx - filterSize;
                maxY = dsy - filterSize;
            end
            rand_x = helpers.randInt(0, floor(2*maxX/filterSize));
            rand_y = helpers.randInt(0, floor(2*maxY/filterSize));
            sample_x = floor(1 + rand_x * filterSize/2);
            sample_y = floor(1 + rand_y * filterSize/2);
            hlFilters{ii} = C1{1}(sample_x:sample_x+filterSize-1, sample_y:sample_y+filterSize-1,:);
        end
    end
end
