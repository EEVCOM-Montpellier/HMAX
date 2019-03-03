function populationSparseness = populationSparseness(X)
%POPULATIONSPARSENESS Summary of this function goes here
%   Detailed explanation goes here
    populationSparseness = 1 - (pow2(sum(abs(X)) / numel(X))) / (sum(pow2(X) / numel(X)));
end
