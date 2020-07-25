function [X, cen1, cen2] = twoSpheres(nX, d, T, expo, para)
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
%   X - nX x nX x T array of 2D images
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 19.12.2018
%
% See also rotatingSpheres

X = zeros(nX, nX, T);

t2unit   = @(t) (t-1)/T;
unit2dis = @(s) (1- 3/2 * d) * ((0.5^-(expo-1) * (s.^expo) .* (s < 0.5)) ...
    - ((0.5^-(expo-1)*abs(s-1).^expo-1).*(s>=0.5)));

radiusSphere  = d/2;
nSubDiv       = checkSetInput(para, 'nSubDiv', 'i,>0', 4);
gridLim       = [-1, 1;-1, 1];

cen1          = zeros(T, 2);
cen2          = zeros(T, 2);

for t=1:T
    
    xHere   = zeros(nX, nX);
    dyn     = unit2dis(t2unit(t));
    
    cen1(t,:) =  [-(1-d), 2*dyn - (1-2*d)];
    xHere = xHere + makeSphere([nX, nX], gridLim, cen1(t,:), radiusSphere, nSubDiv);
    
    cen2(t,:) =  [2*dyn - (1-2*d), 2*dyn - (1-d)];
    xHere = xHere + makeSphere([nX, nX], gridLim, cen2(t,:), radiusSphere, nSubDiv);
    
    X(:, :, t) = xHere;
    
end

end