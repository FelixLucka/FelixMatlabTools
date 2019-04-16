function im = convexClosure(im)
% CONVEXCLOSURE takes a binary image and fills it by closing the convex
% hull
%
% DESCRIPTION:
%   convexClosure is a morphological operation that constructs the convex 
%   hull of the input image and labels all pixels inside the convex hull as
%   positive
%
% USAGE:
%   im = convexClosure(im)
%
%  INPUTS:
%   im - 2D or 3D array
% 
%  OUTPUTS:
%   im - 2D or 3D array
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 08.04.2017
%   last update     - 08.04.2017
%
% See also convexHull

sizeIm = size(im);

% construct cooridinates of pixel/voxel grid
switch ndims(im)
    case 2
        [X, Y] = ndgrid(1:sizeIm(1), 1:sizeIm(2));
        XYZ    = [X(:), Y(:)];
    case 3
        [X, Y, Z] = ndgrid(1:sizeIm(1), 1:sizeIm(2), 1:sizeIm(2));
        XYZ    = [X(:), Y(:), Z(:)];
end

% extract grid points that are labeled true 
P  = XYZ(im(:), :);

% get grid points spanning the convex hull
C  = convexHull(delaunayTriangulation(P));

% construct triangulation of the convex hull points
warning('off', 'MATLAB:delaunayTriangulation:DupPtsWarnId')
DT = delaunayTriangulation(P(C, :));
warning('on', 'MATLAB:delaunayTriangulation:DupPtsWarnId')

% compute location of all grid points in the triagulation 
% this returns nan if points are outside the convex hull
im = pointLocation(DT, XYZ);
% detect non-nan locations and reshape to image 
im = reshape(not(isnan(im)), sizeIm);

end