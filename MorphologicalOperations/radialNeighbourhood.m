function NH = radialNeighbourhood(R, dimMask)
% RADIALNEIGHBOURHOOD returns a radial neighbourhood logical mask which can
% be used for morphological operations
%
% DESCRIPTION:
%   radialNeighbourhood creates the smallest mask where all pixels/voxels with
%   a certain distance to the center have been labeled true
%
% USAGE:
%   NH = radialNeighbourhood(5, 3)
%
%  INPUTS:
%   R       - radius in pixels, the mask will be 2*R + 1 large
%   dimMask - dimension of the mask (2, 3 or 4)
% 
%  OUTPUTS:
%   NH - dimMask-dimensional array containing the mask
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 08.04.2017
%   last update     - 08.04.2017
%
% See also imclose

% creaste grid vector
xVec      = -floor(R):floor(R);

switch dimMask
    case 2
       [X1, X2]          = ndgrid(xVec, xVec);
       sqNormDist        = X1.^2 + X2.^2;
    case 3
       [X1, X2, X3]      = ndgrid(xVec, xVec, xVec);
       sqNormDist        = X1.^2 + X2.^2 + X3.^2;
    case 4
       [X1, X2, X3, X4]  = ndgrid(xVec, xVec, xVec, xVec);
       sqNormDist        = X1.^2 + X2.^2 + X3.^2 + X4.^2;
end

NH = sqNormDist <= R^2;

end
