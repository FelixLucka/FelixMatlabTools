function tf = pointsInGrid(p, grid_cell)
%POINTSINGRID DETERMINES WHETHER GIVES POINTS LIE INSIDE A GIVEN GRID
%
% DETAILS: 
%   pointsInGrid.m can be used to determine whether a collection of points
%   fall into a given numerical grid
%
% USAGE:
%   tf = pointsInGrid(XY, {'x_vec', 'y_vec'})
%
% INPUTS:
%   p - n x d array of n points in d dimensions 
%   grid_cell - cell array containing d grid vectors 
%
% OUTPUTS:
%   tf - boolean vector of lenght n indicating whether the correspoinding
%   point is in the grid. 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 13.10.2023
%
% See also

dim  = size(p,2);
lims = zeros(dim, 2);

% figure out in which way grid_cell is given
if(isvector(grid_cell{1}))
    for i_dim=1:dim
        lims(i_dim,1) = grid_cell{i_dim}(1);
        lims(i_dim,2) = grid_cell{i_dim}(end);
    end
else
    notImpErr
end

tf = true(size(p,1), 1);
for i_dim = 1:dim
   tf = tf & (lims(i_dim, 1) <= p(:,i_dim)) & (p(:,i_dim) <= lims(i_dim, 2));
end

end