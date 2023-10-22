%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is MorphologicalOperations/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 28.02.2019
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% morphological operations

im = imread('circles.png');

% radialNeighbourhood returns a radial neighbourhood logical mask which can
% be used for morphological operations
NH = radialNeighbourhood(7, 2)

im_closed = imclose(im, NH);

%extractBoundary extracts a boundary mask of logical matrix or volume
im_boundary_mask = extractBoundary(im);

% convexClosure takes a binary image and fills it by closing the convex
% hull
im_convex_closure = convexClosure(im);


figure();
subplot(1,4,1); imagesc(im);
subplot(1,4,2); imagesc(im_closed);
subplot(1,4,3); imagesc(im_boundary_mask);
subplot(1,4,4); imagesc(im_convex_closure);


