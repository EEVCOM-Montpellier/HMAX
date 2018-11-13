function S2 = getS2(C1, HLfilters, useGPU)
%% GETS2 Compute the S2 layer

    nHL = length(HLfilters);
    nbScales = length(C1);
    S2 = cell(1,nbScales);

    for scale=1:nbScales
        [~,~,nbOrientations] = size(C1{scale});
        C1sq = C1{scale}.^2;
        C1sq = sum(C1sq,3);
        for cpt=1:nHL   
            X = HLfilters{cpt};
            sz = size(X,1);

            XSqSum = sum(sum(sum(X.^2)));

            sumSup = [ceil(sz/2)-1,ceil(sz/2)-1,...
                          floor(sz/2),floor(sz/2)];
            if exist('useGPU', 'var') && useGPU
                C1sq2 = conv2(double(C1sq), double(ones(sumSup(2)+sumSup(4)+1,sumSup(1)+sumSup(3)+1, 'gpuArray')), 'same'); 
            else
                C1sq2 = conv2(double(C1sq), double(ones(sumSup(2)+sumSup(4)+1,sumSup(1)+sumSup(3)+1)), 'same'); 
            end
            XC1 = zeros(size(C1sq2));
            
            for i = 1:nbOrientations
                X2 = rot90(double(X(:,:,i)),2);
                XC1 = XC1 + conv2(double(C1{scale}(:,:,i)),double(X2), 'same');
            end

            Rsq = C1sq2 - 2*XC1 + XSqSum;
            Rsq(Rsq < 0) = 0;
            R = sqrt(Rsq) + 10^-10;
            S2{scale}(:,:,cpt) = R;
        end
    end    
end