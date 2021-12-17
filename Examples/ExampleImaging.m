%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Imaging/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 07.01.2019
%  	last update     - 16.11.2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% 

% imMin and imMax can be used to locate minimal and maximal values of a
% 2D image
im        = zeros(100);
im(55,66) =  1;
im(44,33) = -1;
[value, row, col] = imMax(im)
[value, row, col] = imMin(im)


%% changing size and resolution (see also ExampleArrayCellFunctions.m)

im = magic(3)

%pad2size pads an image such that is has a given size using padArray.m
pad2size(im, [6,8], -1)

% scaleImage scales an image by interpolation to any size
scalePara = [];
scalePara.interpolationMethod = 'linear';
scaleImage(im, [5,5], scalePara)
scalePara.interpolationMethod = 'nearest';
scaleImage(im, [6,6], scalePara)

% incImageRes increases the resolution of an image by cloning pixels (no
%interpolation) 
incImageRes(im, [2,3])

%% functions for dynamic imaging applications

% dynamic data of arbitrary shape (each cell contains data from one frame)
sizeDynData = {[2,2], [3,1], [1,2]};
data = {rand(sizeDynData{1}), rand(sizeDynData{2}), rand(sizeDynData{3})};
data{:}

% dynamicData2Vec reshapes dynamic data of varying length given as a cell array into a vector
X = dynamicData2Vec(data)

% vec2DynamicData reshapes dynamic data of different length given as a single vector into a cell array
data2 = vec2DynamicData(X, sizeDynData)
isequal(data, data2)

% dynamicData2Mat reshapes dynamic data given as a cell array into a matrix
% (nData x nFrames)
data = {rand(4,1), rand(2,2), rand(4,1)};
data{:}
X = dynamicData2Mat(data)

% mat2DynamicData bins dynamic data given as a matrix (nData x
% nTimes) into a cell array
cellData1 = mat2DynamicData(X, [2,2])         % each column is split into a cell and transformed into a 2x2 matrix
cellData2 = mat2DynamicData(X, [], [1,1;2,3]) % colum 1 and columns 2-3 are split into different cells

% dynamicData2SpaceTime simply concanates cell data along the last
% dimension if that is possible
X = dynamicData2SpaceTime(cellData1)

% num2DynamicData is a more general function, which let's you bin
% temporal data given as a numerical array of arbitrary dimension into a
% cell array
X = randn(3,3,2,4);
cellData = num2DynamicData(X, [1 1;2 3], [], 2)
cellData = num2DynamicData(X, [1 1;2 3], {[6,4], [6,4, 2]}, 2)

%% warping of images
close all

% generate image
im          = pad2size(phantom(80), [100, 100]);
% generate motion field that will shear the image
v           = -zeros(100,100,2);
v(1:50,:,2)   =  10;
v(51:100,:,2) =  -10;

% warp image using warpImage.m
imWarped1 = warpImage(im, v);

% assemble warping matrix of - v
W = warpingMatrix(-v);
% warp image using W
imWarped2 = reshape(W * im(:), size(im));

figure();
subplot(1, 3, 1); imagesc(im);
subplot(1, 3, 2); imagesc(imWarped1);
subplot(1, 3, 3); imagesc(imWarped2);

%% more general image interpolation
close all

n = 100;
m = 200;
x  = linspace(-1,1,n);
y  = linspace(-1,1,m);

nq = 133;
mq = 133;
xq = linspace(-1,1,nq);
yq = linspace(-1,1,mq);

% setup interpolation
weightsIndices = interpolationOperatorFixedGrids('setup', {x,y,xq,yq}, 'linear');


%% Misc

% pixelHit determines which of the NxN pixels subdividing [0,1]^2 are hit 
% by points in X
X     = rand(10, 2);
hits  = pixelHit(50, X);

figure();
subplot(1,2,1); scatter(X(:,2), X(:,1)), xlim([0,1]); ylim([0,1]);
subplot(1,2,2); imagesc(hits), axis xy

% meanFilter applies a summation or mean filter with rectangular window to the input 
im = magic(3)
x = meanFilter(im, 3, 0)
x = meanFilter(im, 3, 1)

% distanceReconstructions can be used to compute error measures between two
% images
im1 = phantom(100);
im2 = meanFilter(im1, 3, 1);
im3 = meanFilter(im1, 5, 1);

distPara = [];
distPara.errorMeasures = {'MSE', 'PSNR', 'SSIM'};
distPara.thresholds = 0;
[dist, thresholds] = distanceReconstructions(im1, im2, distPara);
dist{:}
[dist, thresholds] = distanceReconstructions(im1, im3, distPara);
dist{:}

% gradientNorm2D is a simple wrapper for computing the norm of the image
% gradient
im = phantom(100);
imGradNorm1 = gradientNorm2D(im, 1, 1);
[imX, imY]  = gradient(im);
imGradNorm2 = sqrt(imX.^2 + imY.^2);
isequal(imGradNorm1, imGradNorm2)

% scaleVectorField scales the components of a multi-dimensional vector
%field with scalar factors (last dimension is assumed to be the
%vector component index
v = ones(4,4,2)
v = scaleVectorField(v, [2,3]) 


% assemble the laplace matrix for a given image size in 2D or 3D
L = laplaceMatrix([100,100], '0');
spy(L)
L = laplaceMatrix([33,33, 33], 'NB')
spy(L)
