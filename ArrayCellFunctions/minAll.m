function res = minAll(x)
%FUNCTIONTEMPLATE is a wrapper for min(x(:)) 
%
% USAGE:
%   res = minAll(x)
%
% INPUTS:
%   x - multi-dimensional array
%
% OUTPUTS:
%   res - minimal value found in x
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also maxAll, maxAllBut, sumAll, anyAll

res = min(x(:));

end