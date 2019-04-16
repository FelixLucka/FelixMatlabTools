function [maxVec, minVec] = cumMinMax(y)
%cumMinMax returns a vector of of the min and max values encoutered long
%the vector
%
% DESCRIPTION: 
%   cumMinMax.m returns a vector of of the min and max values encoutered long
%   the vector, i.e, maxVec(n) = max(y(1:n))
%
% USAGE:
%   cumMinMax([4 3 2 3 5 7 9]) returns 
%   maxVec = [4 4 4 4 5 7 9] and minVec = [4 3 2 2 2 2 2]
%
% INPUTS:
%   y - vector
%
% OUTPUTS:
%   maxVec - vetor of accumulated max values, maxVec(n) = max(y(1:n))
%   minVec - vetor of accumulated min values, minVec(n) = min(y(1:n))
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 17.12.2018
%
% See also min, max, cumsum

if(~isvector(y))
    error('input must be a vector')
end

minVec = y;
maxVec = y;
maxY   = y(1);
minY   = y(1);

for i=1:length(y)
    yHere = y(i);
    if(yHere > maxY)
        maxY = yHere;
    else
        maxVec(i) = maxY;
    end
    if(yHere < minY)
        minY = yHere;
    else
        minVec(i) = minY;
    end
end

end