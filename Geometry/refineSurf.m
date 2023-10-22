function [nodes_new, facets_new, curr_edge_length] = refineSurf(nodes, faces, max_edge_length, algo)
%REFINESURF refines a given surface triangulation
%
% DESCRIPTION:
%   refineSurf.m refines a given triangulated surface until all
%   edges are smaller than a given maximal length by one of two algorithms:
%   algo = 1: making iteratively the midpoints of the edges of the face with the largest
%   edgelengthsum the new nodes
%   algo = 2: By globally refining the whole mesh at once using the
%   algorithm by Bank et al., 1983
%
% USAGE:
%   [nodes_new, facets_new, curr_edge_length] = refineSurf(nodes, facets, max_edge_length, 1)
%   [nodes_new, facets_new, curr_edge_length] = refineSurf(nodes, facets, max_edge_length, 2)
%
% INPUTS:
%   nodes - nNodes x 3 array of node coordinates
%   faces - nFaces x 3 array of node indices defining the surface faces
%
% OPTIONAL INPUTS:
%   algo  - 1 or 2 (default: 1, see above)
%
% OUTPUTS:
%   nodes_new       - nNodes x 3 array of new node coordinates
%   facets_new      - nFaces x 3 array of node indices defining the new
%                   surface faces
%   curr_edge_length - maximal edge length of new surface
%
% ABOUT:
%       author          - Felix Lucka
%       date            - ??.??.????
%       last update     - 27.09.2023
%
% See also

% check user defined value for algo, otherwise assign default value
if(nargin < 4)
    algo = 1;
end


if(size(faces,2) > 4)
    notImpErr
elseif(size(faces,2) == 4)
    % Assume that the quadrilaterals are ordered in the right fashion
    facets_old = faces;
    faces = [facets_old(:,1:3);facets_old(:,[1,3,4])];
    clear facets_old
end

n_nodes = size(nodes, 1);

% get all edges
edges12     = (nodes(faces(:,2),:)) - (nodes(faces(:,1),:));
edges23     = (nodes(faces(:,3),:)) - (nodes(faces(:,2),:));
edges31     = (nodes(faces(:,1),:)) - (nodes(faces(:,3),:));
norm_edges12 = sqrt(sum(edges12.^2,2));
norm_edges23 = sqrt(sum(edges23.^2,2));
norm_edges31 = sqrt(sum(edges31.^2,2));
edge_length  = [norm_edges12,norm_edges23,norm_edges31];
[curr_edge_length,~] = max(max(edge_length,[],2));

while(curr_edge_length >  max_edge_length)
    
    switch algo

        case 1

            [curr_edge_length,~] = max(max(edge_length,[],2));
            [~,ind_face]        = max(sum(edge_length,2));
            
            curr_face  = faces(ind_face,:);
            curr_nodes = nodes(curr_face,:);
            nn = 0.5 *[curr_nodes(1,:)+curr_nodes(2,:);...
                curr_nodes(2,:)+curr_nodes(3,:);...
                curr_nodes(3,:)+curr_nodes(1,:)];
            
            bool1 = any(faces == curr_face(1),2);
            bool2 = any(faces == curr_face(2),2);
            bool3 = any(faces == curr_face(3),2);
            tri_on_e12_ind = setdiff(find(bool1 & bool2),ind_face);
            tri_on_e23_ind = setdiff(find(bool2 & bool3),ind_face);
            tri_on_e31_ind = setdiff(find(bool3 & bool1),ind_face);
            
            tri_on_e12 = faces(tri_on_e12_ind,:);
            tri_on_e23 = faces(tri_on_e23_ind,:);
            tri_on_e31 = faces(tri_on_e31_ind,:);
            
            nodes  = [nodes; nn];
            nn_ind = (1:3) + n_nodes;
            
            % delete old facets
            faceI_ind_old = [ind_face,tri_on_e12_ind,tri_on_e23_ind,tri_on_e31_ind];
            faces(faceI_ind_old,:)      = [];
            edge_length(faceI_ind_old,:) = [];
            
            % build new facets
            facets_new = ...
                [nn_ind;... %inner one
                curr_face(1) nn_ind(1) nn_ind(3);... % substitude the former nodes by the midpoints
                curr_face(2) nn_ind(2) nn_ind(1);... % substitude the former nodes by the midpoints
                curr_face(3) nn_ind(3) nn_ind(2)];   % substitude the former nodes by the midpoints
            
            clone12 = [tri_on_e12;tri_on_e12]; % substitude the former nodes 1 and 2 by the midpoint 12
            clone12(1,(clone12(1,:) == curr_face(1))) = nn_ind(1);
            clone12(2,(clone12(2,:) == curr_face(2))) = nn_ind(1);
            
            clone23 = [tri_on_e23;tri_on_e23]; % substitude the former nodes 2 and 3 by the midpoint 23
            clone23(1,(clone23(1,:) == curr_face(2))) = nn_ind(2);
            clone23(2,(clone23(2,:) == curr_face(3))) = nn_ind(2);
            
            clone31 = [tri_on_e31;tri_on_e31]; % substitude the former nodes 3 and 1 by the midpoint 31
            clone31(1,(clone31(1,:) == curr_face(3))) = nn_ind(3);
            clone31(2,(clone31(2,:) == curr_face(1))) = nn_ind(3);
            
            facets_new = [facets_new;clone12;clone23;clone31];
            
            n_e12 = (nodes(facets_new(:,2),:)) - (nodes(facets_new(:,1),:));
            n_e23 = (nodes(facets_new(:,3),:)) - (nodes(facets_new(:,2),:));
            n_e31 = (nodes(facets_new(:,1),:)) - (nodes(facets_new(:,3),:));
            n_norm_e12 = sqrt(sum(n_e12.^2,2));
            n_norm_e23 = sqrt(sum(n_e23.^2,2));
            n_norm_e31 = sqrt(sum(n_e31.^2,2));
            n_edge_length = [n_norm_e12,n_norm_e23,n_norm_e31];
            
            faces = [faces;facets_new];
            edge_length = [edge_length;n_edge_length];
            n_nodes = size(nodes,1);
            
        case 2

            clear edges12 edges23 edges31 norm_edges12 norm_edges23 norm_edges31
            nodes_old = nodes;
            faces_old = faces;
            
            n_nodes     = size(nodes_old,1);
            n_tri       = size(faces_old,1);
            is_inserted = spalloc(3*n_nodes, 3*n_nodes, 3*n_tri);
            
            faces    = zeros(4 * n_tri, 3);
            nodes    = [nodes_old; zeros(3*n_tri,3)];
            curr_ind = n_nodes;
            
            for i=1:n_tri
                if(not(is_inserted(faces_old(i,1),faces_old(i,2))))
                    curr_ind = curr_ind + 1;
                    nodes(curr_ind,:) = (nodes_old(faces_old(i,1),:) + nodes_old(faces_old(i,2),:))/2;
                    is_inserted(faces_old(i,1),faces_old(i,2)) = curr_ind;
                    is_inserted(faces_old(i,2),faces_old(i,1)) = curr_ind;
                    mid12 = curr_ind;
                else
                    mid12 = is_inserted(faces_old(i,1),faces_old(i,2));
                end
                
                if(not(is_inserted(faces_old(i,2),faces_old(i,3))))
                    curr_ind = curr_ind + 1;
                    nodes(curr_ind,:) = (nodes_old(faces_old(i,2),:) + nodes_old(faces_old(i,3),:))/2;
                    is_inserted(faces_old(i,2),faces_old(i,3)) = curr_ind;
                    is_inserted(faces_old(i,3),faces_old(i,2)) = curr_ind;
                    mid23 = curr_ind;
                else
                    mid23 = is_inserted(faces_old(i,2),faces_old(i,3));
                end
                
                if(not(is_inserted(faces_old(i,3),faces_old(i,1))))
                    curr_ind = curr_ind + 1;
                    nodes(curr_ind,:) = (nodes_old(faces_old(i,3),:) + nodes_old(faces_old(i,1),:))/2;
                    is_inserted(faces_old(i,3),faces_old(i,1)) = curr_ind;
                    is_inserted(faces_old(i,1),faces_old(i,3)) = curr_ind;
                    mid31 = curr_ind;
                else
                    mid31 = is_inserted(faces_old(i,3),faces_old(i,1));
                end
                
                faces(4*(i-1)+1, :) = [faces_old(i,1) mid12 mid31];
                faces(4*(i-1)+2, :) = [faces_old(i,2) mid23 mid12];
                faces(4*(i-1)+3, :) = [faces_old(i,3) mid31 mid23];
                faces(4*(i-1)+4, :) = [mid12 mid23 mid31];
            end
            
            clear o_facets o_nodes is_inserted
            nodes = nodes(1:curr_ind, :);
            
            edges12 = (nodes(faces(:,2),:)) - (nodes(faces(:,1),:));
            edges23 = (nodes(faces(:,3),:)) - (nodes(faces(:,2),:));
            edges31 = (nodes(faces(:,1),:)) - (nodes(faces(:,3),:));
            norm_edges12 = sqrt(sum(edges12.^2,2));
            norm_edges23 = sqrt(sum(edges23.^2,2));
            norm_edges31 = sqrt(sum(edges31.^2,2));
            edge_length  = [norm_edges12,norm_edges23,norm_edges31];
            [curr_edge_length,~] = max(max(edge_length,[],2));
            
        otherwise
            error('choose algo = 1 or 2')
    end
    
end

nodes_new = nodes;
facets_new = faces;

end