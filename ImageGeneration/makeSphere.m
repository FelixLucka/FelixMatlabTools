function sphere = makeSphere(n_xyz, grid_lim, center, radius, n_sub_div)
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
%       n_xyz    - number of voxels in each spatial direction 
%       grid_lim - ndim x 2 array with the spatial limits of the grid 
%       center   - centre of the sphere as [x,y] or [x,y,z]
%       radius   - sphere radius
%
% OPTIONAL INPUTS:
%       n_sub_div - The voxels will be subdived to obtain a smooth representation
%                 of the sphere. nSubDiv defines the number of
%                 subdivisions in one dimension
%
% OUTPUTS:
%       sphere - 2D/3D volume of a filled ball
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 29.09.2023
%
% See also


% check for user defined value for n_sub_div, otherwise assign default value
if nargin < 5
    n_sub_div = 2;
end

% read out dimension and spacing dx
dim      = length(n_xyz);
dx       = diff(grid_lim, 1 ,2)./(n_xyz(:)-1);

% create base grid
for d=1:dim
    base_grid_vec{d} = linspace(grid_lim(d,1), grid_lim(d,2), n_xyz(d)+1);
    base_grid_vec{d} = (base_grid_vec{d}(1:end-1) + base_grid_vec{d}(2:end))/2;
end

% create subgrid around each source grid point
sub_grid_vec = linspace(-1,1,2*n_sub_div+1);
sub_grid_vec = sub_grid_vec(2:2:end)/2;
        
% create empty matrix
sphere = zeros(n_xyz);

switch dim
    case 2
        [base_grid_x, base_grid_y] = ndgrid(base_grid_vec{1},  base_grid_vec{2});
        [sub_grid_x,  sub_grid_y]  = ndgrid(dx(1) * sub_grid_vec, dx(2)*sub_grid_vec);
        for i_sub_grid=1:numel(sub_grid_x)
            shift_x = base_grid_x + sub_grid_x(i_sub_grid);
            shift_y = base_grid_y + sub_grid_y(i_sub_grid);
            sq_dist_center = (shift_x - center(1)).^2 + (shift_y - center(2)).^2;
            inside = sq_dist_center < radius.^2;
            sphere = sphere + inside;
        end
    case 3
        [base_grid_x, base_grid_y, base_grid_z] = ndgrid(base_grid_vec{1},  ...
            base_grid_vec{2}, base_grid_vec{3});
        [sub_grid_x, sub_grid_y, subGridZ] = ndgrid(dx(1) * sub_grid_vec, ...
            dx(2) * sub_grid_vec, dx(3) *sub_grid_vec);
        
        for i_sub_grid=1:numel(sub_grid_x)
            shift_x = base_grid_x + sub_grid_x(i_sub_grid);
            shift_y = base_grid_y + sub_grid_y(i_sub_grid);
            shift_z = base_grid_z + subGridZ(i_sub_grid);
            sq_dist_center = (shift_x - center(1)).^2 + (shift_y - center(2)).^2 ...
                + (shift_z - center(3)).^2;
            inside = sq_dist_center < radius.^2;
            sphere = sphere + inside;
        end
        
    otherwise
        notImpErr
end
sphere = sphere/numel(sub_grid_x);

end