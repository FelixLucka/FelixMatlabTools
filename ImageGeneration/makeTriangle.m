function triangle = makeTriangle(Nxyz, gridLim, parameter, nSubDiv)
%MAKERECTANGLE creates a triangle that is  within a 2D or 3D grid.
%
% DESCRIPTION:
%       makeRectangle creates an image of a filled rectangle within a
%       two or three-dimensional grid with Nxyz voxels. 
%
% USAGE:
%       triangle = makeTriangle([100,100], [0,1;0,1], [0.3,0.3 , 0.2, 0.4], 2)
%
% INPUTS:
%       Nxyz    - number of voxels in each spatial direction 
%       gridLim - ndim x 2 array with the spatial limits of the grid 
%       center  - centre of the rectangle as [x,y] or [x,y,z]
%       parameter  - parameter of the triangle
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
%       date            - 27.06.2019
%       last update     - 27.06.2019
%
% See also


% check for user defined value for nSubDiv, otherwise assign default value
if nargin < 4
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
triangle = zeros(Nxyz);

switch dim
    case 2
        [baseGridX, baseGridY] = ndgrid(baseGridVec{1},  baseGridVec{2});
        [subGridX, subGridY] = ndgrid(dx(1) * subGridVec, dx(2)*subGridVec);
        for iSubGrid=1:numel(subGridX)
            shiftX = baseGridX + subGridX(iSubGrid);
            shiftY = baseGridY + subGridY(iSubGrid);
            
            inside = true(Nxyz);
            % make box
            cenX   = (shiftX - (parameter(1) + parameter(3)/2));
            cenY   =  shiftY -  parameter(2);
            inside = inside & abs(cenX) <= parameter(3)/2; 
            inside = inside & (cenY >= 0) & (cenY <= parameter(4));
            % add vertical areas
            inside = inside & (abs(cenY)/parameter(4) + abs(cenX)/(parameter(3)/2)) <= 1; 
            
            triangle = triangle + inside;
        end
    case 3
        notImpErr
    otherwise
        notImpErr
end
triangle = triangle/numel(subGridX);

end