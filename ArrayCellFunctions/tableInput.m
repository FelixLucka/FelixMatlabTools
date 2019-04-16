function [ind, table] = tableInput(input)
%TABLEINPUT computes a hash table for the rows of the input
%
% DESCRIPTION: 
%   tableInput.m is a wrapper for 
%   [table, ~, ind] = unique(input, 'rows','last')
%   which constructs a hash table for the input based on row sorting
%
% USAGE:
%   [ind, table] = tableInput(data)
%
% INPUTS:
%   iput - data to be sorted and hashed 
%
% OUTPUTS:
%   ind   - index of original rows of input in table, i.e., 
%           input = table(ind, :) 
%   table - sorted, unique rows of data
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 24.10.2018
%       last update     - 24.10.2018
%
% See also unique

[table, ~, ind] = unique(input, 'rows','last');

end