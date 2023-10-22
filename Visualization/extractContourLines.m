function [lines_structs, values] = extractContourLines(C)
%EXTRACTCONTOURLINES extracts the countour lines from the contour matrix
% retruned by contour.m
%
% USAGE:
%   C = contour(peaks(200))
%   [LinesCell, Values] = extractContourLines(C)
%
% INPUTS:
%   C - contour matrix returned by contour.m (see corresponding
%   documentation)
%
% OUTPUTS:
%   linesStructs - struct array with the fields 
%           'val' - function value of that isoline
%           'nPoints' - # points defining the line
%           'x' - x-coordinates of the lines
%           'y' - y-coordinates of the lines 
%   values    - vector of function values of the isolines
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 14.10.2023
%
% See also contour

lines_structs  = [];
n_lines = 0;

while(~isempty(C))
    n_lines = n_lines + 1;
    % extract the next line
    lines_structs(n_lines).val = C(1,1);
    values(n_lines) = C(1,1);
    lines_structs(n_lines).n_noints = C(2,1);
    C(:,1) = [];
    lines_structs(n_lines).x = C(1,1:lines_structs(n_lines).n_noints);
    lines_structs(n_lines).y = C(2,1:lines_structs(n_lines).n_noints);
    C(:,1:lines_structs(n_lines).n_noints) = [];
end

values = unique(values);

end