function Xfiltered = threshold(X)
%THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    Xfiltered = X .* (abs(X) > std(X(:)));
end

