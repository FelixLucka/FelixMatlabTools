function nh = radialNeighbourhood(R, dim_mask, p)
% RADIALNEIGHBOURHOOD returns a radial neighbourhood logical mask which can
% be used for morphological operations
%
% DESCRIPTION:
%   radialNeighbourhood creates the smallest mask where all pixels/voxels with
%   a certain distance to the center have been labeled true
%
% USAGE:
%   nh = radialNeighbourhood(5, 3)
%
%  INPUTS:
%   R       - radius in pixels, the mask will be 2*R + 1 large
%   dim_mask - dimension of the mask (2, 3 or 4)
%   p       - type of Lp norm used to measure distance (default: 2)
% 
%  OUTPUTS:
%   nh - dimMask-dimensional array containing the mask
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 08.04.2017
%   last update     - 16.05.2023
%
% See also imclose

% check user defined value for p, otherwise assign default value
if(nargin < 3)
    p = 2;
end

% creaste grid vector
xVec      = -floor(R):floor(R);

switch dim_mask
    case 2
       [X1, X2]          = ndgrid(xVec, xVec);
       dist_power_p      = abs(X1).^p + abs(X2).^p;
    case 3
       [X1, X2, X3]      = ndgrid(xVec, xVec, xVec);
       dist_power_p      = abs(X1).^p + abs(X2).^p + abs(X3).^p;
    case 4
       [X1, X2, X3, X4]  = ndgrid(xVec, xVec, xVec, xVec);
       dist_power_p      = abs(X1).^p + abs(X2).^p + abs(X3).^p + X4.^p;
end

nh = dist_power_p <= R^p;

end
