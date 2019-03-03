function [sparseness, kurt, poiss, meanRanks, chauvenet, decile, qt, sparsenessNorm, curveArea, curveAreaBis, populationSparseness] = getStatisticData(C2s)
%GETSPARSITYKURTOSIS Summary of this function goes here
%   Detailed explanation goes here
    [n, m] =  size(C2s);
    sparseness = zeros(n, 1);
    sparsenessNorm = zeros(n, 1);
    kurt = zeros(n, 1);
    poiss = zeros(n, 1);
    chauvenet = zeros(n, 1);
    decile = zeros(n, 1);
    qt = zeros(n, 1);
    curveArea = zeros(n, 1);
    curveAreaBis = zeros(n, 1);
    tmpChauv = zeros(n, m);
    populationSparseness = zeros(n, 1);
    
    for ii=1:n
        tmp = C2s(ii, :);
        sparseness(ii,1) = 1 - sum(tmp(:)~=0)/length(tmp(:));
        poiss(ii, 1) = poissfit(tmp);
        kurt(ii,1) = kurtosis(tmp);
        moyenne = mean(tmp);
        ecartType = std(tmp);
        quantmp = quantile(tmp, 0.1:0.1:1);
        decile(ii, 1) = quantmp(9);
        quantmp = quantile(tmp, 0.1:0.05:1);
        qt(ii, 1) = quantmp(19);
        traptmp = abs(tmp);
        traptmp = traptmp / max(traptmp);
        curveAreaBis(ii, 1) = trapz(traptmp);
        traptmp = sort(traptmp, 'descend');
        curveArea(ii, 1) = trapz(traptmp);
        for jj=1:m
            tmpChauv(ii, jj) = abs(tmp(jj) - moyenne)/ecartType; 
        end
        %tmpNorm = tmp / max(tmp(:));
        tmpThreshold = tmp .* (abs(tmp) > std(tmp(:)));
        sparsenessNorm(ii) = 1 - nnz(tmpThreshold)/numel(tmpThreshold);
        populationSparseness(ii) = 1 - (pow2(sum(abs(tmp)) / numel(tmp))) / (sum(pow2(tmp) / numel(tmp)));
        if (sparsenessNorm(ii) > 1)
            disp(nnz(tmpThreshold));
        end
    end
    chauvenet(:, 1) = mean(tmpChauv, 2);
    T = array2table(C2s);
    T.ranks=zeros(n,m);
    for jj=1:m
        T = sortrows(T,jj, 'descend');
        T.ranks(:,jj) = 1:n;
    end
    meanRanks = mean(T.ranks, 2);
end

