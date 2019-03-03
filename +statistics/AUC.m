function AUC = AUC(X)
%AUC Summary of this function goes here
%   Detailed explanation goes here
    X = abs(X);
    X = X / max(X(:));
    X = sort(X, 2, 'descend');
    AUC = trapz(X);
end

