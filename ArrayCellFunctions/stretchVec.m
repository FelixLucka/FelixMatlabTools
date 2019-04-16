function y = stretchVec(x, ind, n, defaultVal)
%STRETCHVEC creates a new vector of a certain length from a smaller set of 
% entries
%
% DESCRIPTION: 
%   stretchVec.m can be used to create a new vector with given length and 
%   fill its entries with a given set of values
%
% USAGE:
%    y = stretchVec(x, ind)
%    y = stretchVec(x, ind, n)
%    y = stretchVec(x, ind, n, defaultVal)
%
% INPUTS:
%   x   - entries of the new vector
%   ind - index set into the new vector where the entries of x should be 
%         filled in
%
% OPTIONAL INPUTS:
%   n          - length of the vector (default: max(ind))
%   defaultVal - value at non-specified locations in new vector (default:
%   0=
%
% OUTPUTS:
%   x - new vector such that y(ind) == x
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 30.10.2018
%       last update     - 30.10.2018
%
% See also cutArray, padArray, insertIntoArray

% check user defined value for n, otherwise assign default value
if(nargin < 3)
    n = max(ind);
end

% check user defined value for defaultVal, otherwise assign default value
if(nargin < 4)
    defaultVal = 0;
end


y      = defaultVal * ones(n,1);
y(ind) = x;

end