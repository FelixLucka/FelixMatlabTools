function [X, centerSquare, centerSphere] = squareSphereTriangle(nX, d, T, expo, para)
%ROTATINGSPHERE creates a 2D sequence of a square and spheres that change
%their speed on a straigt trajectory combined with a static triangle

% DESCRIPTION:
%   toDo
%
% USAGE:
%   X = squareSphereTriangle(200, 0.1, 10, 1, [])
%
% INPUTS:
%   nX  - number of voxels in both spatial directions
%   d   - geometric parameter in [0 2/5] that determines where the sphere
%   and square start and how large all objects are
%   T   - total number of frames
%   exp - exponent of the radial position function. 1 for a constant
%   velocity, higher exponents lead to faster acceleration in the middle
%
% OUTPUTS:
%   X - nX x nX x T array of 2D images
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 25.06.2019
%       last update     - 25.06.2019
%
% See also rotatingSpheres

X = zeros(nX, nX, T);

if(T > 1)
    t2unit   = @(t) (t-1)/(T-1);
else
    t2unit   = @(t) 0.5;
end

unit2dis = @(s) (1- 3/2 * d) * ((0.5^-(expo-1) * (s.^expo) .* (s < 0.5)) ...
    - ((0.5^-(expo-1)*abs(s-1).^expo-1).*(s>=0.5)));


radiusSphere  = d/2;
edgesSquare   = [d,d];
nSubDiv       = checkSetInput(para, 'nSubDiv', 'i,>0', 4);
gridLim       = [-1, 1;-1, 1];




centerSphere          = zeros(T, 2);
centerSquare          = zeros(T, 2);
lowBottomTri          = [1 - 2*d, - 1 + d/2];
edgeTri               = sqrt(2) * d;

for t=1:T
    
    xHere   = zeros(nX, nX);
    dyn     = unit2dis(t2unit(t));
    
    centerSphere(t,:) =  [-(1-d), 180/100 * dyn - (1 - 230/100 * d)]; 
    xHere = xHere + makeSphere([nX, nX], gridLim, centerSphere(t,:), radiusSphere, nSubDiv);
    
    
    centerSquare(t,:) =  [180/100 * dyn - (1- 230/100 * d), 2*dyn - (1-d)];
    xHere        = xHere + makeRectangle([nX, nX], gridLim, centerSquare(t,:), edgesSquare, nSubDiv);
    
    xHere        = xHere + makeTriangle([nX, nX], gridLim, ...
        [lowBottomTri edgeTri, sqrt(3/4) * edgeTri], nSubDiv);
    
    X(:, :, t) = xHere;
    
end

end