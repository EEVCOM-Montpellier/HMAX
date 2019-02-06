function [sparsity, kurt, poiss, meanRanks, chauvenet, decile, qt] = getSparsityKurtosis(C2s)
%GETSPARSITYKURTOSIS Summary of this function goes here
%   Detailed explanation goes here
    [n, m] =  size(C2s);
    sparsity = zeros(n, 1);
    kurt = zeros(n, 1);
    poiss = zeros(n, 1);
    chauvenet = zeros(n, 1);
    decile = zeros(n, 1);
    qt = zeros(n, 1);
    tmpChauv = zeros(n, m);
    for ii=1:n
        tmp = C2s(ii, :);
        sparsity(ii,1) = sum(tmp(:)~=0)/length(tmp(:));
        poiss(ii, 1) = poissfit(tmp);
        kurt(ii,1) = kurtosis(tmp);
        moyenne = mean(tmp);
        ecartType = std(tmp);
        quantmp = quantile(tmp, 0.1:0.1:1);
        decile(ii, 1) = quantmp(9);
        quantmp = quantile(tmp, 0.1:0.05:1);
        qt(ii, 1) = quantmp(19);
        for jj=1:m
            tmpChauv(ii, jj) = abs(tmp(jj) - moyenne)/ecartType; 
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

