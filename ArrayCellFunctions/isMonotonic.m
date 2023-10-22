function tf = isMonotonic(f, strict_inequality)
%ISMONOTONIC checks if the values in a given vector increase monotonically 
%
% DESCRIPTION: 
%   isMonotonic.m can be used to check if the values in a vector 
%   increase monotonically 
%
% USAGE:
%   isMonotonic([1 2 3]) returns true
%   isMonotonic([1 0 3]) returns false
%   isMonotonic([1 1], true) returns false
%   isMonotonic([1 1], false) returns true
%
% INPUTS:
%   f - input vector 
%
% OPTIONAL INPUTS:
%   strictInequality - boolean indicating whether a strict inequality is
%   checked for 
%
% OUTPUTS:
%   tf - boolean indicating whether entries in f are monotonically
%   increasing
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 24.09.2023
%
% See also sort

% check user defined value for strictInequality, otherwise assign default value
if(nargin < 2)
    strict_inequality = false;
end

if(isvector(f))
    d = diff(f);
else
    error('input f must be a vector')
end

if(strict_inequality)
    tf = all(d >  0) | all(d <  0);
else
    tf = all(d >= 0) | all(d <= 0);
end

end