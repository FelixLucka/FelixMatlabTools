function res = sumAll(x)
%SUMALL is a wrapper for sum(x(:))
%
% DESCRIPTION: 
%   sumAll.m can be used to execute sum(x(:)) directly
%
% USAGE:
%   res = sumAll(x)
%
% INPUTS:
%   x - numerical array of arbitrary dimension
%
% OUTPUTS:
%   res - sum of all entries of x
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 30.10.2018
%       last update     - 30.10.2018
%
% See also vec, sum, sumAllBut

res = sum(x(:));

end