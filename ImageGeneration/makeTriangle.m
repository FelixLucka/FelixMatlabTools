function triangle = makeTriangle(n_xyz, grid_lim, parameter, n_sub_div)
%MAKERECTANGLE creates a simple triangle within a 2D or 3D grid.
%
% DESCRIPTION:
%       makeRectangle creates an image of a filled triangle within a
%       two or three-dimensional grid with Nxyz voxels. One side of the
%       triangle is aligned with the x-axis, the other two sides have the
%       same length. The triangle is pointing into positive y-direction
%       (think of the "play" button")
%
% USAGE:
%       triangle = makeTriangle([100,100], [0,1;0,1], [0.3,0.3 , 0.2, 0.4], 2)
%
% INPUTS:
%       n_xyz    - number of voxels in each spatial direction 
%       grid_lim - ndim x 2 array with the spatial limits of the grid 
%       center  - centre of the rectangle as [x,y] or [x,y,z]
%       parameter  - parameter of the triangle:
%           parameter(1): x-coordinate of left upper corner
%           parameter(2): y-coordinate of left upper corner
%           parameter(3): length of side aligned with the x-axis
%           parameter(4): height of triangle
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
%       date            - 27.06.2019
%       last update     - 29.09.2023
%
% See also


% check for user defined value for nSubDiv, otherwise assign default value
if nargin < 4
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
triangle = zeros(n_xyz);

switch dim
    case 2
        [base_grid_x, base_grid_y] = ndgrid(base_grid_vec{1},  base_grid_vec{2});
        [sub_grid_x, sub_grid_y] = ndgrid(dx(1) * sub_grid_vec, dx(2)*sub_grid_vec);
        for i_sub_grid=1:numel(sub_grid_x)
            shift_x = base_grid_x + sub_grid_x(i_sub_grid);
            shift_y = base_grid_y + sub_grid_y(i_sub_grid);
            
            inside = true(n_xyz);
            % make box
            cen_x   = (shift_x - (parameter(1) + parameter(3)/2));
            cen_y   =  shift_y -  parameter(2);
            inside = inside & abs(cen_x) <= parameter(3)/2; 
            inside = inside & (cen_y >= 0) & (cen_y <= parameter(4));
            % add vertical areas
            inside = inside & (abs(cen_y)/parameter(4) + abs(cen_x)/(parameter(3)/2)) <= 1; 
            
            triangle = triangle + inside;
        end
    case 3
        notImpErr
    otherwise
        notImpErr
end
triangle = triangle/numel(sub_grid_x);

end