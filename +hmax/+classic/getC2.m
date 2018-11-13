function C2 = getC2(S2, useGPU)
    %GETC2 Compute C2 layer

    nbScales = length(S2);
    [~,~,nHL] = size(S2{1});

    if exist('useGPU', 'var') && useGPU
        C2=zeros(1,nHL, 'gpuArray');
    else
        C2=zeros(1,nHL);
    end

    for hl=1:nHL
        if exist('useGPU', 'var') && useGPU
            scalmax = zeros(1,nbScales, 'gpuArray');
        else
            scalmax = zeros(1,nbScales);
        end
            for scale=1:nbScales
                m=S2{scale}(:,:,hl);
                scalmax(scale) = min(m(:)); %(max activation = minium ditance between HLFilter and C1)
            end
        C2(hl) = min(scalmax);
    end
end