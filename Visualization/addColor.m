function new_color = addColor(color_table, avoid_colors, iter)
%ADDCOLOR tries to add a color to a table of colors that is as different as
%possible to them (in terms of euklidean distance)
%
% DESCRIPTION:
%       addColor draws a number of random colors as [R, G, B] and computes
%       the distance between those and the colors already in the table and 
%       colors that should be avoided. It then returns the one with the
%       maximal distance
%
% USAGE:
%       newColor = addColor([1,1,1;1,0,0;0,1,0;0,0,1], [0 0 0], 1000)
%
% INPUTS:
%       color_table  - [n x 3] table with RGB colors (in [0,1])
%       avoid_colors - [n x 3] table with RGB colors (in [0,1])
%       iter         - number of colors to generate and check
%
% OUTPUTS:
%       new_color  - [1x3] RGB vector
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 23.10.2017
%       last update     - 13.10.2023
%
% See also 

% add colors to avoid and those in the table
tmp_color_table = [color_table; avoid_colors];

% generate random colors
pro_colors = rand(iter, 3);
dist       = zeros(iter, size(tmp_color_table, 1));

for i_color=1:size(tmp_color_table, 1)
    
    % compute distance to colors in the table 
    dist(:,i_color) = sqrt(sum((bsxfun(@minus, pro_colors, ...
                               tmp_color_table(i_color, :))).^2,2));
    
end

% return the one with the maximal distance
[~, ind]  = max(min(dist, [], 2));
new_color = pro_colors(ind, :);

end
