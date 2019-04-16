function xPro = firstNonZero(x, dim)
%FIRSTNONZERO     projects an n-dim array onto the first non zero value
%along a specified dimension
%
% DESCRIPTION:
%       firstNonZero returns a (n-1) dimensional array that, in each
%       dimension, contains the first non-zero value along a specified
%       dimension.
%
% USAGE:
%       firstNonZero([0 0 4 1 0 1]) returns 4
%       firstNonZero([0 3;4 0], 1)  returns [4,3]
%
% INPUTS:
%       x   - n-dim input array
%       dim - dimension along which to perform projection

% OUTPUTS:
%       x_pro - (n-1)-dim array containing the first elements of x along
%               specified dimension
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 27th February 2017
%       last update     - 27th February 2017
%
% See also min, max, sum, cumsum

% a simple implementation making use of matlabs build-in functions
xPro               = cumsum(x, dim);
xPro(xPro == 0)    = NaN;
xPro               = squeeze(min(xPro, [], dim));
xPro(isnan(xPro))  = 0;

