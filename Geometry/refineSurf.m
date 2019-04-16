function [newNodes, newFacets, currEdgeLength] = refineSurf(nodes, faces, maxEdgeLength, algo)
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
%   [newNodes, newFacets, currEdgeLength] = refineSurf(nodes, facets, maxEdgeLength, 1)
%   [newNodes, newFacets, currEdgeLength] = refineSurf(nodes, facets, maxEdgeLength, 2)
%
% INPUTS:
%   nodes - nNodes x 3 array of node coordinates
%   faces - nFaces x 3 array of node indices defining the surface faces
%
% OPTIONAL INPUTS:
%   algo  - 1 or 2 (default: 1, see above)
%
% OUTPUTS:
%   newNodes       - nNodes x 3 array of new node coordinates
%   newFacets      - nFaces x 3 array of node indices defining the new
%                   surface faces
%   currEdgeLength - maximal edge length of new surface
%
% ABOUT:
%       author          - Felix Lucka
%       date            - ??.??.????
%       last update     - 01.11.2018
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
    oldFacets = faces;
    faces = [oldFacets(:,1:3);oldFacets(:,[1,3,4])];
    clear oldFacets
end

nNodes = size(nodes, 1);

% get all edges
edges12     = (nodes(faces(:,2),:)) - (nodes(faces(:,1),:));
edges23     = (nodes(faces(:,3),:)) - (nodes(faces(:,2),:));
edges31     = (nodes(faces(:,1),:)) - (nodes(faces(:,3),:));
normEdges12 = sqrt(sum(edges12.^2,2));
normEdges23 = sqrt(sum(edges23.^2,2));
normEdges31 = sqrt(sum(edges31.^2,2));
edgeLength  = [normEdges12,normEdges23,normEdges31];
[currEdgeLength,~] = max(max(edgeLength,[],2));

while(currEdgeLength >  maxEdgeLength)
    
    switch algo
        case 1
            [currEdgeLength,~] = max(max(edgeLength,[],2));
            [~,indFace]        = max(sum(edgeLength,2));
            
            currFace  = faces(indFace,:);
            currNodes = nodes(currFace,:);
            nn = 0.5 *[currNodes(1,:)+currNodes(2,:);...
                currNodes(2,:)+currNodes(3,:);...
                currNodes(3,:)+currNodes(1,:)];
            
            bool1 = any(faces == currFace(1),2);
            bool2 = any(faces == currFace(2),2);
            bool3 = any(faces == currFace(3),2);
            triOnE12Ind = setdiff(find(bool1 & bool2),indFace);
            triOnE23Ind = setdiff(find(bool2 & bool3),indFace);
            triOnE31Ind = setdiff(find(bool3 & bool1),indFace);
            
            triOnE12 = faces(triOnE12Ind,:);
            triOnE23 = faces(triOnE23Ind,:);
            triOnE31 = faces(triOnE31Ind,:);
            
            nodes = [nodes; nn];
            nnInd = (1:3) + nNodes;
            
            % delete old facets
            oldFaceInd = [indFace,triOnE12Ind,triOnE23Ind,triOnE31Ind];
            faces(oldFaceInd,:)      = [];
            edgeLength(oldFaceInd,:) = [];
            
            % build new facets
            newFacets = ...
                [nnInd;... %inner one
                currFace(1) nnInd(1) nnInd(3);... % substitude the former nodes by the midpoints
                currFace(2) nnInd(2) nnInd(1);... % substitude the former nodes by the midpoints
                currFace(3) nnInd(3) nnInd(2)];   % substitude the former nodes by the midpoints
            
            clone12 = [triOnE12;triOnE12]; % substitude the former nodes 1 and 2 by the midpoint 12
            clone12(1,(clone12(1,:) == currFace(1))) = nnInd(1);
            clone12(2,(clone12(2,:) == currFace(2))) = nnInd(1);
            
            clone23 = [triOnE23;triOnE23]; % substitude the former nodes 2 and 3 by the midpoint 23
            clone23(1,(clone23(1,:) == currFace(2))) = nnInd(2);
            clone23(2,(clone23(2,:) == currFace(3))) = nnInd(2);
            
            clone31 = [triOnE31;triOnE31]; % substitude the former nodes 3 and 1 by the midpoint 31
            clone31(1,(clone31(1,:) == currFace(3))) = nnInd(3);
            clone31(2,(clone31(2,:) == currFace(1))) = nnInd(3);
            
            newFacets = [newFacets;clone12;clone23;clone31];
            
            nE12 = (nodes(newFacets(:,2),:)) - (nodes(newFacets(:,1),:));
            nE23 = (nodes(newFacets(:,3),:)) - (nodes(newFacets(:,2),:));
            nE31 = (nodes(newFacets(:,1),:)) - (nodes(newFacets(:,3),:));
            nNormE12 = sqrt(sum(nE12.^2,2));
            nNormE23 = sqrt(sum(nE23.^2,2));
            nNormE31 = sqrt(sum(nE31.^2,2));
            nEdgeLength = [nNormE12,nNormE23,nNormE31];
            
            faces = [faces;newFacets];
            edgeLength = [edgeLength;nEdgeLength];
            nNodes = size(nodes,1);
            
            
        case 2
            clear edges12 edges23 edges31 normEdges12 normEdges23 normEdges31
            oldNodes = nodes;
            oldFaces = faces;
            
            nNodes     = size(oldNodes,1);
            nTri       = size(oldFaces,1);
            isInserted = spalloc(3*nNodes, 3*nNodes, 3*nTri);
            
            faces   = zeros(4 * nTri, 3);
            nodes   = [oldNodes; zeros(3*nTri,3)];
            currInd = nNodes;
            
            for i=1:nTri
                if(not(isInserted(oldFaces(i,1),oldFaces(i,2))))
                    currInd = currInd + 1;
                    nodes(currInd,:) = (oldNodes(oldFaces(i,1),:) + oldNodes(oldFaces(i,2),:))/2;
                    isInserted(oldFaces(i,1),oldFaces(i,2)) = currInd;
                    isInserted(oldFaces(i,2),oldFaces(i,1)) = currInd;
                    mid12 = currInd;
                else
                    mid12 = isInserted(oldFaces(i,1),oldFaces(i,2));
                end
                
                if(not(isInserted(oldFaces(i,2),oldFaces(i,3))))
                    currInd = currInd + 1;
                    nodes(currInd,:) = (oldNodes(oldFaces(i,2),:) + oldNodes(oldFaces(i,3),:))/2;
                    isInserted(oldFaces(i,2),oldFaces(i,3)) = currInd;
                    isInserted(oldFaces(i,3),oldFaces(i,2)) = currInd;
                    mid23 = currInd;
                else
                    mid23 = isInserted(oldFaces(i,2),oldFaces(i,3));
                end
                
                if(not(isInserted(oldFaces(i,3),oldFaces(i,1))))
                    currInd = currInd + 1;
                    nodes(currInd,:) = (oldNodes(oldFaces(i,3),:) + oldNodes(oldFaces(i,1),:))/2;
                    isInserted(oldFaces(i,3),oldFaces(i,1)) = currInd;
                    isInserted(oldFaces(i,1),oldFaces(i,3)) = currInd;
                    mid31 = currInd;
                else
                    mid31 = isInserted(oldFaces(i,3),oldFaces(i,1));
                end
                
                faces(4*(i-1)+1, :) = [oldFaces(i,1) mid12 mid31];
                faces(4*(i-1)+2, :) = [oldFaces(i,2) mid23 mid12];
                faces(4*(i-1)+3, :) = [oldFaces(i,3) mid31 mid23];
                faces(4*(i-1)+4, :) = [mid12 mid23 mid31];
            end
            
            clear o_facets o_nodes is_inserted
            nodes = nodes(1:currInd, :);
            
            edges12 = (nodes(faces(:,2),:)) - (nodes(faces(:,1),:));
            edges23 = (nodes(faces(:,3),:)) - (nodes(faces(:,2),:));
            edges31 = (nodes(faces(:,1),:)) - (nodes(faces(:,3),:));
            normEdges12 = sqrt(sum(edges12.^2,2));
            normEdges23 = sqrt(sum(edges23.^2,2));
            normEdges31 = sqrt(sum(edges31.^2,2));
            edgeLength  = [normEdges12,normEdges23,normEdges31];
            [currEdgeLength,~] = max(max(edgeLength,[],2));
        otherwise
            error('choose algo = 1 or 2')
    end
    
end

newNodes = nodes;
newFacets = faces;

end