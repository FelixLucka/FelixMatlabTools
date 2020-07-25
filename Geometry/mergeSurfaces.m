function [nodes_m, elements_m] = mergeSurfaces(nodes1, elements1, nodes2, elements2)

N_nodes1    = size(nodes1, 1);
N_nodes2    = size(nodes2, 1);
N_elements1 = size(elements1, 1);
N_elements2 = size(elements2, 1);

nodes_mm    = [nodes1; nodes2];
elements_mm = [elements1; elements2 + N_nodes1];

% get rid of node dublicates
[nodes_m, ~, n] = unique(nodes_mm,'rows');
elements_m      = n(elements_mm);

end