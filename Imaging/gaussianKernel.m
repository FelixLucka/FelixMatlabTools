function kernel = gaussianKernel(n, sigma, cut_off)
%GAUSSIANKERNEL returns a multi-dimensional gaussian kernel that can be used
% for convolutions 
%
% USAGE:
%   kernel = gaussianKernel(3, [1,1,2], 3)
%
% INPUTS:
%   n - dimension of the kernel
%
% OPTIONAL INPUTS:
%   sigma  - Standard deviation of the kernel. If it is a vector of
%            dimension n, different sigmas will be used in different spatial
%            dimensions (default: 1)
%   cut_off - Multiple of sigma after which the kernel will be cut-off and
%            set to 0 (default: 3). This determines the size of the kernel.
%            Can also be a vector (see above)
%
% OUTPUTS:
%   kernel - n-dimensional array 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.03.2019
%       last update     - 29.09.2023
%
% See also

% check user defined value for sigma, otherwise assign default value
if(nargin < 2)
    sigma = 1;
end

% check user defined value for cutOff, otherwise assign default value
if(nargin < 3)
    % cut off at 3 * sigma
    cut_off = 3;
end

% generate vectors of sigma and cutOff
if(isscalar(sigma))
    sigma = repmat(sigma, n, 1);
end
if(isscalar(cut_off))
    cut_off = repmat(cut_off, n, 1);
end

if(n > 1)
    kernel = 1;
    for iDim = 1:n
        width      = ceil(cut_off(iDim) * sigma(iDim));
        aux        = ones(1, n);
        aux(iDim)  = 2*width + 1;
        arg_1d      = zeros(aux);
        arg_1d(:)   = (-width:width).^2 / (2 * sigma(iDim)^2);
        kernel     = repmat(kernel, aux);
        kernel     = bsxfun(@plus, kernel, arg_1d);
    end
else
    width      = ceil(cut_off * sigma);
    kernel     = (-width:width).^2 / (2 * sigma^2);
end

% apply ex0
kernel = exp(- kernel);

% set all values that are too small anyhow to 0
kernel(kernel < eps * max(kernel(:))) = 0;

% re-normalize
kernel = kernel / sum(kernel(:));

end