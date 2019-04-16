function [value, row, col] = imMin(im)
%IMMAX returns value and i, j indices of the minimal value of an image
%
% USAGE:
%   [value row col] = imMin(im)
%
% INPUTS:
%   im - 2D numerical array
%
% OUTPUTS:
%   value - minimal numerical value in im
%   row   - row index of minimum 
%   col   - column index of minimum
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also imMax

[value, row] = min(im);
[value, col] = min(value);
row = row(col);

end