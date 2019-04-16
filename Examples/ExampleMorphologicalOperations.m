%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is MorphologicalOperations/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 28.02.2019
%  	last update     - 28.02.2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% morphological operations

im = imread('circles.png');

% radialNeighbourhood returns a radial neighbourhood logical mask which can
% be used for morphological operations
NH = radialNeighbourhood(7, 2)

imClosed = imclose(im, NH);

%extractBoundary extracts a boundary mask of logical matrix or volume
imBoundaryMask = extractBoundary(im);

% convexClosure takes a binary image and fills it by closing the convex
% hull
imConvexClosure = convexClosure(im);


figure();
subplot(1,4,1); imagesc(im);
subplot(1,4,2); imagesc(imClosed);
subplot(1,4,3); imagesc(imBoundaryMask);
subplot(1,4,4); imagesc(imConvexClosure);


