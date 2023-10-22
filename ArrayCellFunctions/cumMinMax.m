function [max_vec, min_vec] = cumMinMax(y)
%cumMinMax RETURNS A VECTOR OF THE MIN AND MAX VALUES ENCOUNTERED ALONG THE VECTOR
%
% DESCRIPTION: 
%   cumMinMax.m returns a vector of of the min and max values encoutered long
%   the vector, i.e, maxVec(n) = max(y(1:n))
%
% USAGE:
%   cumMinMax([4 3 2 3 5 7 9]) returns 
%   max_vec = [4 4 4 4 5 7 9] and min_vec = [4 3 2 2 2 2 2]
%
% INPUTS:
%   y - vector
%
% OUTPUTS:
%   max_vec - vetor of accumulated max values, maxVec(n) = max(y(1:n))
%   min_vec - vetor of accumulated min values, minVec(n) = min(y(1:n))
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 24.09.2023
%
% See also min, max, cumsum

if(~isvector(y))
    error('input must be a vector')
end

min_vec = y;
max_vec = y;
maxY   = y(1);
minY   = y(1);

for i=1:length(y)
    y_here = y(i);
    if(y_here > maxY)
        maxY = y_here;
    else
        max_vec(i) = maxY;
    end
    if(y_here < minY)
        minY = y_here;
    else
        min_vec(i) = minY;
    end
end

end