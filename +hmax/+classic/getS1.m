function [ S1 ] = getS1(image, gaborFilters)
%GETS1 Compute S1 layer
    
    nbScales = length(gaborFilters);
    [~, ~, nbOrientations] = size(gaborFilters{1});

    S1 = cell(1, nbScales);
	for scale = 1:nbScales
        for iOrientation = 1:nbOrientations
		  filter = gaborFilters{scale}(:,:,iOrientation);
          S1{scale}(:,:,iOrientation) = abs(imfilter(image,filter,'same','conv'));
        end
	end
end