function [nodes_m, elements_m] = mergeSurfaces(nodes_1, elements_1, nodes_2, elements_2)
%MERGESURFACSE MERGES TWO SURFACE TRIANGULATIONS INTO ONE MESH
%
% DETAILS: 
%   mergeSurfaces.m can be used to merge two surface triangulations into
%   one mesh
%
% USAGE:
%   [nodes_m, elements_m] = mergeSurfaces(nodes_1, elements_1, nodes_2, elements_2)
%
% INPUTS:
%   nodes_1    - nodes of mesh one as n_nodes_1 x 3 array 
%   elements_1 - elements of mesh one as n_elements_1 x 3 array of indices
%       into 1,...,n_nodes_1
%   nodes_2 - nodes of mesh two as n_nodes_1 x 3 array 
%   elements_2 - elements of mesh two as n_elements_2 x 3 array of indices
%       into 1,...,n_nodes_2
%
% OUTPUTS:
%   nodes_m    - nodes of merged mesh 
%   elements_m - elements of merged mesh
%
% ABOUT:
%       author          - Felix Lucka
%       date            - ??.??.????
%       last update     - 27.09.2023
%
% See also

n_nodes_1   = size(nodes_1, 1);
nodes_mm    = [nodes_1; nodes_2];
elements_mm = [elements_1; elements_2 + n_nodes_1];

% get rid of node dublicates
[nodes_m, ~, n] = unique(nodes_mm,'rows');
elements_m      = n(elements_mm);

end