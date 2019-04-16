function x = meanFilter(x, windowSize, normalize, geometric_mean)
%MEANFILTER applies a local mean filter to an image
%
% DESCRIPTION:
%       meanFilter applies a local mean filter to an image
%
% USAGE:
%       x = meanFilter(x, windowSize, normFL)
%
% INPUTS:
%       x          - input image
%       windowSize - size of the local averaging window
% 
% OPTIONAL INPUTS:
%       normalize - logical controlling whether local averaging is
%                   performed (true) or just summation (false). Default:
%                   true
%       geometric_mean - logical controlling wether the geometrical mean
%                        instead of the arithmetic should be taken. Default:
%                        false
%
% OUTPUTS:
%       x - averaged image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 03.09.2017
%
% See also convn

% check user defined value for normalize, otherwise assign default value
if(nargin < 3)
    normalize = true;
end

% check user defined value for geometric_mean, otherwise assign default value
if(nargin < 4)
    geometric_mean = false;
end

dim               = ndims(x);
h                 = ones(windowSize * ones(1, dim));

if(geometric_mean)
    x = log(x);
end

x                 = convn(x, h, 'same');

if(normalize)
    normalization = convn(ones(size(x)), h, 'same');
    x             = x./normalization;
end

if(geometric_mean)
    x = exp(x);
end

end