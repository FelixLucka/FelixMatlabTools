function res = repIntoCell(x, sizeCell)
%REPINTOCELL returns a cell array of a given size with each cell containing the 
% same object
%
% DESCRIPTION:
%   repIntoCell is a simple way to clone an object into a cell array each
%   containing the original object
%
% USAGE:
%       xCell = repIntoCell(x, [3, 4])
%
% INPUTS:
%       x        - an object
%       sizeCell - size of the resulting cell array
%
% OUTPUTS:
%       res - a cell array of the given size, with each cell containing x
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 05.04.2018
%   last update     - 05.04.2018
%
% See also cellfun, cell, applyToMatOrCell

res = cell(sizeCell);
res = cellfun(@(y) x, res, 'UniformOutput', false);

end