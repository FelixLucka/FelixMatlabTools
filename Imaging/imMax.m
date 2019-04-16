function [value, row, col] = imMax(im)
%IMMAX returns value and i, j indices of the maximal value of an image
%
% USAGE:
%   [value row col] = imMax(im)
%
% INPUTS:
%   im - 2D numerical array
%
% OUTPUTS:
%   value - maximal numerical value in im
%   row   - row index of maximum 
%   col   - column index of maximum
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also imMin

[value, row] = max(im);
[value, col] = max(value);
row = row(col);

end