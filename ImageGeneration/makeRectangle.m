function rectangle = makeRectangle(n_xyz, grid_lim, center, edge_length, n_sub_div)
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
%       n_xyz    - number of voxels in each spatial direction 
%       grid_lim - ndim x 2 array with the spatial limits of the grid 
%       center   - centre of the rectangle as [x,y] or [x,y,z]
%       edge_length - length of the edges
%
% OPTIONAL INPUTS:
%       n_sub_div - The voxels will be subdived to obtain a smooth representation
%                 of the rectangle. nSubDiv defines the number of
%                 subdivisions in one dimension
%
% OUTPUTS:
%       rectangle - 2D/3D volume of a filled rectangle
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 25.06.2019
%       last update     - 29.09.2023
%
% See also


% check for user defined value for nSubDiv, otherwise assign default value
if nargin < 5
    n_sub_div = 2;
end

% read out dimension and spacing dx
dim      = length(n_xyz);
dx       = diff(grid_lim, 1 ,2)./n_xyz(:);

% create base grid
for d=1:dim
    base_grid_vec{d} = linspace(grid_lim(d,1), grid_lim(d,2), n_xyz(d)+1);
    base_grid_vec{d} = (base_grid_vec{d}(1:end-1) + base_grid_vec{d}(2:end))/2;
end

% create subgrid around each source grid point
sub_grid_vec = linspace(-1,1,2*n_sub_div+1);
sub_grid_vec = sub_grid_vec(2:2:end)/2;
        
% create empty matrix
rectangle = zeros(n_xyz);

switch dim
    case 2
        [base_grid_x, base_grid_y] = ndgrid(base_grid_vec{1},  base_grid_vec{2});
        [sub_grid_x, sub_grid_y] = ndgrid(dx(1) * sub_grid_vec, dx(2)*sub_grid_vec);
        for iSubGrid=1:numel(sub_grid_x)
            shift_x = base_grid_x + sub_grid_x(iSubGrid);
            shift_y = base_grid_y + sub_grid_y(iSubGrid);
            inside = abs(shift_x - center(1)) < edge_length(1)/2;
            inside = inside & abs(shift_y - center(2)) < edge_length(2)/2;
            rectangle = rectangle + inside;
        end
    case 3
        [base_grid_x, base_grid_y, baseGridZ] = ndgrid(base_grid_vec{1},  ...
            base_grid_vec{2}, base_grid_vec{3});
        [sub_grid_x, sub_grid_y, subGridZ] = ndgrid(dx(1) * sub_grid_vec, ...
            dx(2) * sub_grid_vec, dx(3) *sub_grid_vec);
        
        for iSubGrid=1:numel(sub_grid_x)
            shift_x = base_grid_x + sub_grid_x(iSubGrid);
            shift_y = base_grid_y + sub_grid_y(iSubGrid);
            shiftZ = baseGridZ + subGridZ(iSubGrid);
            inside = abs(shift_x - center(1)) < edge_length(1)/2;
            inside = inside & abs(shift_y - center(2)) < edge_length(2)/2;
            inside = inside & abs(shiftZ - center(3)) < edge_length(3)/2;
            rectangle = rectangle + inside;
        end
        
    otherwise
        notImpErr
end
rectangle = rectangle/numel(sub_grid_x);

end