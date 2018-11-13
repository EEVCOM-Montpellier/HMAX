function gaborFilters = getGaborFilters(parameters)
    %GETGABORFILTERS High level function to get gabor filters as output, 
    %given Gabor parameters in input

    nbScales = parameters.NbScales();
	gaborFilters = cell(1, nbScales);

	for i = 1:nbScales
		nxy = parameters.scales{i}.filterSize;
		xx = (-(nxy-1)/2:(nxy-1)/2);
		yy = xx;
		[x,y] = meshgrid(xx,yy);
		[filter] = hmax.classic.gabor(x,y, ...
            parameters.Orientations('radian'), ...
            parameters.scales{i}.wavelength, ...
            parameters.scales{i}.effectiveWidth, ...
            parameters.aspectRatio ...
         );

        mn = mean(mean(filter));
        % Centering
        for j=1:parameters.nbOrientations
            filter(:,:,j) = filter(:,:,j) - mn(j); 
        end

        % Normalization (L2 norm)
        filter = filter ./ sqrt(sum(sum(sum((filter.^2)))));
		gaborFilters{i} = filter;
	end
end
