function [X, center_square, center_sphere] = squareSphereTriangle(n_X, d, T, expo, para)
%ROTATINGSPHERE creates a 2D sequence of a square and spheres that change
%their speed on a straigt trajectory combined with a static triangle

% DESCRIPTION:
%   toDo
%
% USAGE:
%   X = squareSphereTriangle(200, 0.1, 10, 1, [])
%
% INPUTS:
%   n_X  - number of voxels in both spatial directions
%   d   - geometric parameter in [0 2/5] that determines where the sphere
%   and square start and how large all objects are
%   T   - total number of frames
%   exp - exponent of the radial position function. 1 for a constant
%   velocity, higher exponents lead to faster acceleration in the middle
%
% OUTPUTS:
%   X - n_X x n_X x T array of 2D images
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

if(T > 1)
    t2unit   = @(t) (t-1)/(T-1);
else
    t2unit   = @(t) 0.5;
end

unit2dis = @(s) (1- 3/2 * d) * ((0.5^-(expo-1) * (s.^expo) .* (s < 0.5)) ...
    - ((0.5^-(expo-1)*abs(s-1).^expo-1).*(s>=0.5)));


radius_sphere  = d/2;
edges_square   = [d,d];
n_sub_div       = checkSetInput(para, 'nSubDiv', 'i,>0', 4);
grid_lim       = [-1, 1;-1, 1];




center_sphere         = zeros(T, 2);
center_square         = zeros(T, 2);
low_bottom_tri        = [1 - 2*d, - 1 + d/2];
edge_tri               = sqrt(2) * d;

for t=1:T
    
    x_here   = zeros(n_X, n_X);
    dyn     = unit2dis(t2unit(t));
    
    center_sphere(t,:) =  [-(1-d), 180/100 * dyn - (1 - 230/100 * d)]; 
    x_here = x_here + makeSphere([n_X, n_X], grid_lim, center_sphere(t,:), radius_sphere, n_sub_div);
    
    
    center_square(t,:) =  [180/100 * dyn - (1- 230/100 * d), 2*dyn - (1-d)];
    x_here        = x_here + makeRectangle([n_X, n_X], grid_lim, center_square(t,:), edges_square, n_sub_div);
    
    x_here        = x_here + makeTriangle([n_X, n_X], grid_lim, ...
        [low_bottom_tri edge_tri, sqrt(3/4) * edge_tri], n_sub_div);
    
    X(:, :, t) = x_here;
    
end

end