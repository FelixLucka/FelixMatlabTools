function x = cell2vec(x)
%CELL2VEC VECTORIZES A WHOLE CELL ARRAY
%
% DETAILS: 
%   cell2vec.m can be used to obtain all numerical vales in a cell in one
%   vector
%
% USAGE:
%   x_vec = cell2vec(x)
%
% INPUTS:
%   x - a cell array of arbitrary shape
%
% OUTPUTS:
%   x - vector containing all numerical values, e.g.
%   [x{1}(:);...;x{end}(:)]
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 24.09.2023
%
% See also vec, cell2mat

x = x(:);
x = cellfun(@(x) x(:), x, 'UniformOutput', false);
x = cell2mat(x);

end