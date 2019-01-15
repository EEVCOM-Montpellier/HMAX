function [sparsity, kurt] = getSparsityKurtosis(C2s)
%GETSPARSITYKURTOSIS Summary of this function goes here
%   Detailed explanation goes here
    [n, ~] =  size(C2s);
    sparsity = zeros(n, 1);
    kurt = zeros(n, 1);
    for ii=1:n
        tmp = C2s(ii, :);
        sparsity(ii,1) = length(tmp(~tmp));
        kurt(ii,1) = kurtosis(tmp);
    end
end

