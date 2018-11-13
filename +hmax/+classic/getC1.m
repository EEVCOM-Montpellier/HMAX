function C1 = getC1(S1, poolSizes, useGPU)
%GETC1 Compute C1 layer
%   S1 are cells representing scales containing activation layers given by 
%   getS1.
%   poolSizes is an array of each max pooling size by scales.
%   useGPU is a boolean

    nbScales = length(S1);
    C1 = cell(1,nbScales - 1);
    [dx, dy, nbOrientations ] = size(S1{1});
    
    for scale=1:nbScales-1
		sz = (poolSizes(scale));
        szz = sz/2; % TODO: This can be a parameter
		pxm = floor((dx-sz)/szz); pym = floor((dy-sz)/szz);

        for iOrientation = 1:nbOrientations
            C = max(S1{scale}(:,:, iOrientation), S1{scale+1}(:,:, iOrientation));
            
            if exist('useGPU', 'var') && useGPU == true
                A = zeros(pym, pxm, szz, szz, 'gpuArray');
            else
                A = zeros(pym, pxm, szz, szz);
            end

            for py = 0:pym-1
                for px = 0:pxm-1
                    A(py+1, px+1, :, :) = C(px*szz+1:(px+1)*szz, py*szz+1:(py+1)*szz);
                end
            end
            C1{scale}(:,:,iOrientation) = max(max(A, [], 4), [], 3)';
        end
    end
end