function res = maxAll(x)
%FUNCTIONTEMPLATE is a wrapper for max(x(:)) 
%
% DESCRIPTION: 
%   maxAll.m is a wrapper for max(x(:)) 
%
% USAGE:
%   res = maxAll(x)
%
% INPUTS:
%   x - multi-dimensional array
%
% OUTPUTS:
%   res - maximal value found in x
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also minAll, maxAllBut, sumAll, anyAll

res = max(x(:));

end