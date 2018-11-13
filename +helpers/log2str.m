function str = log2str(logical)
%LOG2STR Transform a logical in his string equivalent
%   Example:
%   log2str(true) will return the string 'true'
%   log2str(1) will also return the string 'true'
%   false or 0 will return the string 'false'
%   Any other number will return the string 'true'

if(logical)
    str = 'true';
else
    str = 'false';
end
end

