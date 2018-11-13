function [DO] = getDODescriptor(SO, gaborFilters)

    nbScales = length(gaborFilters);
	[h, w, nbOrientations, nbChans] = size(SO{1});

	%gabor filters on each channel
    dochans = cell(1, nbScales);
    for scale = 1:nbScales
        for chan=1:nbChans
            for th = 1:nbOrientations
                filtr = gaborFilters{scale}(:,:,th);
                dochans{scale}(:,:,th,chan) = abs(imfilter(SO{scale}(:,:,th,chan),filtr,'symmetric'));                 
            end
        end
    end

	for scale=1:nbScales
		idx = dochans{scale}<0;
		dochans{scale}(idx) = 0;
		dochans{scale} = dochans{scale}.^2;
	end

	%normalization
	DOnorm=cell(1,nbScales);
	for scale=1:nbScales
		DOnorm{scale}=zeros(h,w,nbOrientations,nbChans);
	end
	k=1;
	sigma=0.225;
	sigma2=sigma^2;
	for scale=1:nbScales
		for th=1:nbOrientations
            for chan=1:nbChans
                sm = sum(dochans{scale}(:,:,:,chan),3); 
                DOnorm{scale}(:,:,th,chan) = sqrt((k*dochans{scale}(:,:,th,chan))./(sigma2+sm));
            end
		end
	end


    %summation of opponent pairs
    DO=cell(nbChans/2,nbScales);
    for scale=1:nbScales
        for i = 1:nbChans/2
            DO{i, scale}=zeros(h,w,nbOrientations);
        end
    end
    
    for scale=1:nbScales
        for i=1:nbChans/2
            for th=1:nbOrientations
                DO{i, scale}(:,:,th) = DOnorm{scale}(:,:,th,i)+DOnorm{scale}(:,:,th,i+nbChans/2);
            end
        end
    end
    
end