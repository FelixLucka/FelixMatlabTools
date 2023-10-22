%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Geometry/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 31.01.2019
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% 

% construct a single sphere
[X,Y,Z]  = sphere(10); 
XYZ      = [X(:), Y(:), Z(:)];
faces    = convhull(X(:), Y(:), Z(:));


[new_XYZ, new_faces, max_edge_length] = refineSurf(XYZ, faces, 0.2);

figure();
subplot(1, 2, 1); trisurf(faces, X(:), Y(:), Z(:))
subplot(1, 2, 2); trisurf(new_faces, new_XYZ(:,1), new_XYZ(:,2), new_XYZ(:,3))

