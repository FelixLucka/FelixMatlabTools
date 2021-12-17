function rectangle = makeRectangle(Nxyz, gridLim, center, edgeLength, nSubDiv)
%MAKERECTANGLE creates a rectangle within a 2D or 3D grid.
%
% DESCRIPTION:
%       makeRectangle creates an image of a filled rectangle within a
%       two or three-dimensional grid with Nxyz voxels. 
%
% USAGE:
%       rectangle = makeRectangle([100,100], [0,1;0,1], [0.5,0.5], [0.2, 0.4], 2)
%
% INPUTS:
%       Nxyz    - number of voxels in each spatial direction 
%       gridLim - ndim x 2 array with the spatial limits of the grid 
%       center  - centre of the rectangle as [x,y] or [x,y,z]
%       edgeLength  - length of the edges
%
% OPTIONAL INPUTS:
%       nSubDiv - The voxels will be subdived to obtain a smooth representation
%                 of the rectangle. nSubDiv defines the number of
%                 subdivisions in one dimension
%
% OUTPUTS:
%       rectangle - 2D/3D volume of a filled rectangle
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 25.06.2019
%       last update     - 16.11.2021
%
% See also


% check for user defined value for nSubDiv, otherwise assign default value
if nargin < 5
    nSubDiv = 2;
end

% read out dimension and spacing dx
dim      = length(Nxyz);
dx       = diff(gridLim, 1 ,2)./Nxyz(:);

% create base grid
for d=1:dim
    baseGridVec{d} = linspace(gridLim(d,1), gridLim(d,2), Nxyz(d)+1);
    baseGridVec{d} = (baseGridVec{d}(1:end-1) + baseGridVec{d}(2:end))/2;
end

% create subgrid around each source grid point
subGridVec = linspace(-1,1,2*nSubDiv+1);
subGridVec = subGridVec(2:2:end)/2;
        
% create empty matrix
rectangle = zeros(Nxyz);

switch dim
    case 2
        [baseGridX, baseGridY] = ndgrid(baseGridVec{1},  baseGridVec{2});
        [subGridX, subGridY] = ndgrid(dx(1) * subGridVec, dx(2)*subGridVec);
        for iSubGrid=1:numel(subGridX)
            shiftX = baseGridX + subGridX(iSubGrid);
            shiftY = baseGridY + subGridY(iSubGrid);
            inside = abs(shiftX - center(1)) < edgeLength(1)/2;
            inside = inside & abs(shiftY - center(2)) < edgeLength(2)/2;
            rectangle = rectangle + inside;
        end
    case 3
        [baseGridX, baseGridY, baseGridZ] = ndgrid(baseGridVec{1},  ...
            baseGridVec{2}, baseGridVec{3});
        [subGridX, subGridY, subGridZ] = ndgrid(dx(1) * subGridVec, ...
            dx(2) * subGridVec, dx(3) *subGridVec);
        
        for iSubGrid=1:numel(subGridX)
            shiftX = baseGridX + subGridX(iSubGrid);
            shiftY = baseGridY + subGridY(iSubGrid);
            shiftZ = baseGridZ + subGridZ(iSubGrid);
            inside = abs(shiftX - center(1)) < edgeLength(1)/2;
            inside = inside & abs(shiftY - center(2)) < edgeLength(2)/2;
            inside = inside & abs(shiftZ - center(3)) < edgeLength(3)/2;
            rectangle = rectangle + inside;
        end
        
    otherwise
        notImpErr
end
rectangle = rectangle/numel(subGridX);

end