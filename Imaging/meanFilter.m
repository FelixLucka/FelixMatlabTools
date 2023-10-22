function x = meanFilter(x, window_para, normalize, mean_type, weigth_type)
%MEANFILTER applies a local averaging filter to an image
%
% DESCRIPTION:
%       meanFilter applies a local filter to an image that replaces a pixel
%       by a weighted average of Pythagorean type (arithmetic, harmonic,
%       geometric, see https://en.wikipedia.org/wiki/Pythagorean_means)
%
% USAGE:
%       x = meanFilter(x, windowSize, true, 'arithmetic', 'flatCube')
%       replaces x by its normal average over a square window
%
%       x = meanFilter(x, [1,2], true, 'harmonic', 'Gaussian')
%       replaces x by its weighted harmonic mean using a weight kernel with
%       Gaussian weights with standard deviation one pixel that is cut off
%       after 2 standard deviations
%
%
% INPUTS:
%       x          - input image
%       window_para - size of the local averaging window for weigth_type's
%       'flatCube', 'flatSphere', 'flatDiamond' and std and cut off for
%       Gaussian weigth_type
% 
% OPTIONAL INPUTS:
%       normalize - logical controlling whether local averaging is
%                   performed (true) or just summation (false). Default:
%                   true
%       mean_type - 'arithmetic', 'harmonic', 'geometric'
%       weigth_type - type of weights using. For 'flatCube', 'flatSphere', 
%           weight 1 is used in a square / spherical / diamond shaped
%           region around each pixel (l_inf, l_2, l_1 norm balls)
%           For 'Gaussian', a Gaussian with std window_para(1) and cut off 
%           window_para(2) is used. 
%
% OUTPUTS:
%       x - mean filtered image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 10.03.2023
%
% See also convn, radialNeighbourhood, gaussianKernel

% check user defined value for normalize, otherwise assign default value
if(nargin < 3)
    normalize = true;
end

% check user defined value for mean_type, otherwise assign default value
if(nargin < 4)
    mean_type = 'arithmetic';
end

% check user defined value for mean_type, otherwise assign default value
if(nargin < 5)
    weigth_type = 'flatCube';
end

dim               = ndims(x);
switch weigth_type
    case 'flatCube'
        kernel = ones(window_para * ones(1, dim));
    case 'flatSphere'
        kernel = radialNeighbourhood(window_para(1), dim, 2);
    case 'flatDiamond'
        kernel = radialNeighbourhood(window_para(1), dim, 1);
    case 'Gaussian'
        kernel = gaussianKernel(dim, window_para(1), window_para(2));
end

% up cast to avoid unwanted rounding errors
class_x = class(x);
x = double(x);

% transform
switch mean_type
    case 'arithmetic'
        % nothing to do here
    case 'harmonic'
        x = 1./x;
    case 'geometric'
        x = double(x);
        x = log(x);
end

% convolute and normalize
x                 = convn(x, kernel, 'same');
if(normalize)
    normalization = convn(ones(size(x)), kernel, 'same');
    x             = x./normalization;
end

% back-transform
switch mean_type
    case 'arithmetic'
        % nothing to do here
    case 'harmonic'
        x = 1./x;
    case 'geometric'
        x = exp(x);
end

% cast back to original type
x = cast(x, class_x);

end