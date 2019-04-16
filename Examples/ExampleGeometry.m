%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Geometry/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 31.01.2019
%  	last update     - 31.01.2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% 

% construct a single sphere
[X,Y,Z]  = sphere(10); 
XYZ      = [X(:), Y(:), Z(:)];
faces    = convhull(X(:), Y(:), Z(:));


[newXYZ, newFaces, maxEdgeLength] = refineSurf(XYZ, faces, 0.2);

figure();
subplot(1, 2, 1); trisurf(faces, X(:), Y(:), Z(:))
subplot(1, 2, 2); trisurf(newFaces, newXYZ(:,1), newXYZ(:,2), newXYZ(:,3))

