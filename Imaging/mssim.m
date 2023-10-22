function res = mssim(x, ref, channel_dim)
%MSSIM COMPUTES THE MEAN SSIM ACROSS ONE DIMENTION OF A MULTIDIMENIONAL
%IMAGE ARRAY
%
% DETAILS: 
%   mssim.m treats the last dimension of x as a channel or time dimension, 
%   computes the ssim for each channel / time point separately and then
%   averages them
%
% USAGE:
%   im  = double(imread('peppers.png'));
%   res = mssim(im + 3*randn(size(im)), im , 3)
%
% INPUTS:
%   x - multidimensional array, in which the first 2 or 3 dimensions
%   correspond to spatially distributed quantities (images) and the last
%   dimensions correspond to unordered channel dimensions
%   ref - reference array to which x is compared
%
% OPTIONAL INPUTS:
%   channel_dim - dimensions over which the ssim should be averaged
%   (default: the last dimension)
%
% OUTPUTS:
%   res - average ssim accros channels
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 21.10.2023
%
% See also

sz_x     = size(x);
n_dims_x = nDims(x);

if(nargin < 3)
    switch n_dims_x
        case {2,3}
            image_dim   = 2;
            channel_dim = 3;
        case 4
            image_dim   = 3;
            channel_dim = 4;
        otherwise
            image_dim   = 2;
            channel_dim = sz_x(3:end);
    end
else
    image_dim = (channel_dim-1);
end

% reshape x
x   = reshape(x,   [sz_x(1:image_dim), prod(sz_x(channel_dim))]);
ref = reshape(ref, [sz_x(1:image_dim), prod(sz_x(channel_dim))]);

res   = 0;
for i = 1 : size(x, 3)
    switch image_dim
        case 2
            res = res + ssim( x(:, :, i), ref(:, :, i));
        case 3
            res = res + ssim( x(:, :, :, i), ref(:, :, :, i));
    end
end
res = res / size(x, 3);

end
