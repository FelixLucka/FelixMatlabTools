function [linesStructs, values] = extractContourLines(C)
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
%       last update     - 05.11.2018
%
% See also contour

linesStructs  = [];
N_lines = 0;

while(~isempty(C))
    N_lines = N_lines + 1;
    % extract the next line
    linesStructs(N_lines).val = C(1,1);
    values(N_lines) = C(1,1);
    linesStructs(N_lines).nPoints = C(2,1);
    C(:,1) = [];
    linesStructs(N_lines).x = C(1,1:linesStructs(N_lines).nPoints);
    linesStructs(N_lines).y = C(2,1:linesStructs(N_lines).nPoints);
    C(:,1:linesStructs(N_lines).nPoints) = [];
end

values = unique(values);

end