function [X, center_square, center_sphere] = squareSpherePhantom(n_X, d, T, expo, para)
%ROTATINGSPHERE creates a 2D sequence of a square and spheres that change
%their speed on a straigt trajectory combined with a phantom

% DESCRIPTION:
%   toDo
%
% USAGE:
%   X = fourSpheresAndASponge(200, 0.1, 10, 1, [])
%
% INPUTS:
%   n_X  - number of voxels in both spatial directions
%   d   - geometric parameter in [0 2/5] that determines where the sphere
%   and square start and how large they are
%   T   - total number of frames
%   exp - exponent of the radial position function. 1 for a constant
%   velocity, higher exponents lead to faster acceleration in the middle
%
% OUTPUTS:
%   X - nX x nX x T array of 2D images
%   center_square - coordinates of the center of the square 
%   center_sphere - coordinates of the center of the sphere 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 25.06.2019
%       last update     - 29.09.2023
%
% See also rotatingSpheres

X = zeros(n_X, n_X, T);

t2unit   = @(t) (t-1)/T;
unit2dis = @(s) (1- 3/2 * d) * ((0.5^-(expo-1) * (s.^expo) .* (s < 0.5)) ...
    - ((0.5^-(expo-1)*abs(s-1).^expo-1).*(s>=0.5)));


radius_sphere  = d/2;
edges_square   = [d,d];
n_sub_div       = checkSetInput(para, 'nSubDiv', 'i,>0', 4);
grid_lim       = [-1, 1;-1, 1];


phan_ind     = [round(5*n_X/8),ceil(1*n_X/64)];
phan_sz      = round(5*n_X/16);
phantom_im_fine   = phantom(n_sub_div * phan_sz);
phantom_im_coarse = zeros(phan_sz);
% downsample by averaging
for i=1:n_sub_div
    for j=1:n_sub_div
        phantom_im_coarse = phantom_im_coarse + phantom_im_fine(i:n_sub_div:end, j:n_sub_div:end);
    end
end
phantom_im_coarse = phantom_im_coarse / n_sub_div^2;

center_sphere          = zeros(T, 2);
center_square          = zeros(T, 2);

for t=1:T
    
    x_here   = zeros(n_X, n_X);
    dyn     = unit2dis(t2unit(t));
    
    center_sphere(t,:) =  [-(1-d), 2*dyn - (1-2*d)]; 
    x_here = x_here + makeSphere([n_X, n_X], grid_lim, center_sphere(t,:), radius_sphere, n_sub_div);
    
    center_square(t,:) =  [2*dyn - (1-2*d), 2*dyn - (1-d)];
    x_here        = x_here + makeRectangle([n_X, n_X], grid_lim, center_square(t,:), edges_square, n_sub_div);
    
    
    X(:, :, t) = x_here;
    
    X(phan_ind(1) + (0:phan_sz-1), phan_ind(2) + (0:phan_sz-1), t) = phantom_im_coarse;
end

end