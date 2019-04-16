function sphere = makeSphere(Nxyz, gridLim, center, radius, nSubDiv)
%MAKESPHERE Creates a sphere within a 2D or 3D grid.
%
% DESCRIPTION:
%       myMakeBall creates a map of a filled sphere within a
%       two or three-dimensional grid with Nxyz voxels. 
%
% USAGE:
%       sphere = makeSphere([101,101], [-1,1;-1,1], [0,0], 0.5, 4)
%
% INPUTS:
%       Nxyz    - number of voxels in each spatial direction 
%       gridLim - ndim x 2 array with the spatial limits of the grid 
%       center  - centre of the sphere as [x,y] or [x,y,z]
%       radius  - sphere radius
%
% OPTIONAL INPUTS:
%       nSubDiv - The voxels will be subdived to obtain a smooth representation
%                 of the sphere. nSubDiv defines the number of
%                 subdivisions in one dimension
%
% OUTPUTS:
%       sphere - 2D/3D volume of a filled ball
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
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
sphere = zeros(Nxyz);

switch dim
    case 2
        [baseGridX, baseGridY] = ndgrid(baseGridVec{1},  baseGridVec{2});
        [subGridX, subGridY] = ndgrid(dx(1) * subGridVec, dx(2)*subGridVec);
        for iSubGrid=1:numel(subGridX)
            shiftX = baseGridX + subGridX(iSubGrid);
            shiftY = baseGridY + subGridY(iSubGrid);
            sqDistCenter = (shiftX - center(1)).^2 + (shiftY - center(2)).^2;
            inside = sqDistCenter < radius.^2;
            sphere = sphere + inside;
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
            sqDistCenter = (shiftX - center(1)).^2 + (shiftY - center(2)).^2 ...
                + (shiftZ - center(3)).^2;
            inside = sqDistCenter < radius.^2;
            sphere = sphere + inside;
        end
        
    otherwise
        notImpErr
end
sphere = sphere/numel(subGridX);

end