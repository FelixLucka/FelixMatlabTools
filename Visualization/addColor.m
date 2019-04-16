function newColor = addColor(colorTable, avoidColors, iter)
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
%       last update     - 23.10.2017
%
% See also 

% add colors to avoid and those in the table
tempColorTable = [colorTable; avoidColors];

% generate random colors
proColors = rand(iter, 3);
dist       = zeros(iter, size(tempColorTable, 1));

for iColor=1:size(tempColorTable,1)
    
    % compute distance to colors in the table 
    dist(:,iColor) = sqrt(sum((bsxfun(@minus, proColors, ...
                               tempColorTable(iColor, :))).^2,2));
    
end

% return the one with the maximal distance
[~, ind] = max(min(dist, [], 2));
newColor = proColors(ind, :);

end
