function x = randInt(a, b)
%RANDINT Get a random integer in the interval [a, b]
%   Example: 
%   randInt(1, 3)  %Possible values: [1, 2, 3]
%   randInt(-3, 3) %Possible values: [-3, -2, -1, 0, 1, 2, 3]
if nargin < 2
    throw(MException('RANINT:TooFewArgs','Some arguments are missing (expecting 2)'));
end
if a > b
    throw(MException('RANDINT:MinGTMax','Minimum is greater than maximum'));
end
x = floor(rand()*(b - a + 1) + a);
end