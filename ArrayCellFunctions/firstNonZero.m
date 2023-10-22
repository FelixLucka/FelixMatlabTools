function x_pro = firstNonZero(x, dim)
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
%       date            - 27.02.2017
%       last update     - 24.09.2023
%
% See also min, max, sum, cumsum

% a simple implementation making use of matlabs build-in functions
x_pro               = cumsum(x, dim);
x_pro(x_pro == 0)    = NaN;
x_pro               = squeeze(min(x_pro, [], dim));
x_pro(isnan(x_pro))  = 0;

