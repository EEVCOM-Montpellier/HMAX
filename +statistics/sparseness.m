function sparseness = sparseness(X)
%SPARSNESS Summary of this function goes here
%   Detailed explanation goes here
    sparseness = 1 - nnz(X)/numel(X);
end

