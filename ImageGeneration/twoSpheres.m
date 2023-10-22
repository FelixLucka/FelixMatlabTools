function [X, cen1, cen2] = twoSpheres(n_X, d, T, expo, para)
%ROTATINGSPHERE creates a 2D sequence of four spheres that change
%their speed on a straigt trajectory combined with a menger sponge in the
%middle

% DESCRIPTION:
%   toDo
%
% USAGE:
%   X = fourSpheresAndASponge(200, 10, 100, 2)
%
% INPUTS:
%   nX  - number of voxels in both spatial directions
%   d   - geometric parameter in [0 2/5] that determines where the spheres
%   start
%   T   - total number of frames
%   exp - exponent of the radial position function. 1 for a constant
%   velocity, higher exponents lead to faster acceleration in the middle
%
% OUTPUTS:
%   X - n_X x n_X x T array of 2D images
%   cen1 - coordinatets of the center of the first sphere
%   cen2 - coordinatets of the center of the second sphere
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 29.09.2023
%
% See also rotatingSpheres

X = zeros(n_X, n_X, T);

t2unit   = @(t) (t-1)/T;
unit2dis = @(s) (1- 3/2 * d) * ((0.5^-(expo-1) * (s.^expo) .* (s < 0.5)) ...
    - ((0.5^-(expo-1)*abs(s-1).^expo-1).*(s>=0.5)));

radius_sphere  = d/2;
n_sub_div       = checkSetInput(para, 'nSubDiv', 'i,>0', 4);
grid_lim       = [-1, 1;-1, 1];

cen1          = zeros(T, 2);
cen2          = zeros(T, 2);

for t=1:T
    
    x_here   = zeros(n_X, n_X);
    dyn     = unit2dis(t2unit(t));
    
    cen1(t,:) =  [-(1-d), 2*dyn - (1-2*d)];
    x_here = x_here + makeSphere([n_X, n_X], grid_lim, cen1(t,:), radius_sphere, n_sub_div);
    
    cen2(t,:) =  [2*dyn - (1-2*d), 2*dyn - (1-d)];
    x_here = x_here + makeSphere([n_X, n_X], grid_lim, cen2(t,:), radius_sphere, n_sub_div);
    
    X(:, :, t) = x_here;
    
end

end