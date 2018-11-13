function SO = getSODescriptor(image, W, nbChannels, gaborFilters)
    Wexcit = (W>0).*W;
    Winhib = (W<0).*W;

	outChansHalf = nbChannels/2;
	[h,w,inChans] = size(image);

	nbScales = length(gaborFilters);
    [~, ~, nbOrientations] = size(gaborFilters{1});
    
	ochans=cell(1, nbScales);
	excit=cell(1, nbScales);
	inhib=cell(1, nbScales);
    for scale = 1:nbScales
		ochans{scale} = zeros(h,w,nbOrientations,nbChannels);
		excit{scale} = zeros(h,w,nbOrientations, inChans);
		inhib{scale} = zeros(h,w,nbOrientations, inChans);
    end

    for scale = 1:nbScales
	    for th = 1:nbOrientations
	        filterexcit = (gaborFilters{scale}(:,:,th)>0).*gaborFilters{scale}(:,:,th);            	        
            filterinhib = -(gaborFilters{scale}(:,:,th)<0).*gaborFilters{scale}(:,:,th);
    
	        for color=1: inChans
                excit{scale}(:,:,th,color) = abs(imfilter(image(:,:,color),filterexcit,'symmetric')); 
                inhib{scale}(:,:,th,color) = abs(imfilter(image(:,:,color),filterinhib,'symmetric'));
 	        end
	    end
    end
    
    for scale = 1:nbScales
        for th=1:nbOrientations
            for i=1:outChansHalf
                for j=1: inChans
                    ochans{scale}(:,:,th,i) = ochans{scale}(:,:,th,i) + Wexcit(j,i).*excit{scale}(:,:,th,j) + Winhib(j,i).*inhib{scale}(:,:,th,j);
                    ochans{scale}(:,:,th,i+outChansHalf) = -(ochans{scale}(:,:,th,i) + Wexcit(j,i).*excit{scale}(:,:,th,j) + Winhib(j,i).*inhib{scale}(:,:,th,j));
                end
            end
        end
    end


	%half-squaring
    for scale = 1:nbScales
		idx = ochans{scale}<0;
		ochans{scale}(idx) = 0;
		ochans{scale} = ochans{scale}.^2;
    end

	%divisive normalization
	SO=cell(1, nbScales);
    for scale = 1:nbScales
		SO{scale}=zeros(h,w,nbOrientations,nbChannels);
    end  
	k=1;
	sigma=0.225;
	sigma2=sigma^2;
    for scale = 1:nbScales
        for th=1:nbOrientations
            for chan=1:nbChannels
                sm = sum(ochans{scale}(:,:,th,:),4); 
                SO{scale}(:,:,th,chan) = sqrt((k*ochans{scale}(:,:,th,chan))./(sigma2+sm)); % JULIEN : change de normalization à voir avec FRED
            end
        end
    end
end
