function X = rotatingSpheres(nX, T, exp)
%ROTATINGSPHERE creates a 2D sequence of three rotating spheres that change
%their rotation speed

% DESCRIPTION:
%   toDo
%
% USAGE:
%   X = rotatingSpheres(Nx, T, exp)
%
% INPUTS:
%   nX  - number of voxels in both spatial directions
%   T   - total number of frames
%   exp - exponent of the radial position function. 1 for a constant
%   velocity, higher exponents lead to faster acceleration in the middle
%
% OUTPUTS:
%   X - nX x nX x T array of 2D images
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also

X = zeros(nX, nX, T);

t2unit   = @(t) (t-1)/T;
unit2phi = @(s) (0.5^-(exp-1) * (s.^exp) .* (s < 0.5)) ...
    - ((0.5^-(exp-1)*abs(s-1).^exp-1).*(s>=0.5));


radiusSphere  = 0.2;
radiusCircle  = 0.9 - radiusSphere;
nSpheres      = 3;
nSubDiv       = 4;
gridLim       = [-1, 1;-1, 1];

for t=1:T
    xHere   = zeros(nX, nX);
    phi     = unit2phi(t2unit(t)) * (2/3) * pi;
    
    for iSphere = 1:nSpheres
        phiSphere    = phi + (iSphere-1) * 2*pi/nSpheres;
        centerSphere = radiusCircle * [cos(phiSphere),sin(phiSphere)];
        xHere        = xHere + makeSphere([nX, nX], gridLim, centerSphere,...
            radiusSphere, nSubDiv);
    end
    X(:, :, t) = xHere;
end

end