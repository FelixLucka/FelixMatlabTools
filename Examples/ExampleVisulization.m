%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the high-level functions in
% Visualization/ 
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 05.02.2019
%  	last update     - 16.11.2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% visualizeImage is the main function to visualize 2D and 3D images
ccc

%%% 2D 

n  = 256;
im = phantom(n);

% basic call
para = [];
visualizeImage(im, [], para);

% set color map
para          = [];
para.colorMap = 'viridis';
visualizeImage(im, [], para);

% set values of the image within a mask to 0
para = [];
para.blankValue   = 0;
para.blankMask    = im == 1;
visualizeImage(im, [], para);

% set the color in a mask to a prescribed RGB code
para            = [];
para.RGBMask    = im == 0;
para.maskColor  = str2RGB('pink'); % str2RGB translates a few standard colors into RGB
visualizeImage(im, [], para);

% clip image
para             = [];
para.clipIndizes = [n/4, 3/4 * n; 1, n];
visualizeImage(im, [], para);

% print image
para          = [];
para.print    = true;
para.fileName = 'testPrint';
visualizeImage(im, [], para);


% dynamic imaging, see visualizeImage.m for all parameter settings
T = 10;
for t=1:T
    imSequence{t}       = makeSphere([n,n], [0,1;0,1], (0.2* t/T + 0.4) * [1,1] , 0.2, 4);
end

para             = [];
para.type        = 'movie';
para.fps         = 2;
para.loop        = 2;
para.addFrameId  = true;
para.fontSize    = 20;
para.print       = true;
para.animatedGif = true;
para.fileName    = 'testImageSequence_t$frame$'; % $frame$ will be replaced by the frame number
visualizeImage(imSequence, [], para);


para             = [];
para.type        = 'colorPlot';
para.fontSize    = 20;
para.print       = true;
para.fileName    = 'testImageSequenceColorPlot'; % $frame$ will be replaced by the frame number
visualizeImage(imSequence, [], para);


%%% 3D
im = zeros(n, n, n);
im = im + makeSphere([n,n,n], [0, 1; 0, 1; 0, 1], [0.4, 0.4, 0.5], 0.2, 1);
im = im + makeSphere([n,n,n], [0, 1; 0, 1; 0, 1], [0.6, 0.4, 0.5], 0.2, 1);
im = im + makeSphere([n,n,n], [0, 1; 0, 1; 0, 1], [0.5, 0.6, 0.5], 0.2, 1);

% maxIntensity plots the maximum intensity projections of a given
% 3D volume along each coordinate direction (which is not very useful for
% this data)
para             = [];
para.type        = 'maxIntensity';
visualizeImage(im, [], para);

para              = [];
para.type         = 'slicePlot';
para.dimSlice     = 1;
para.slices2show  = round(linspace(0.4,0.6,9) * n);
visualizeImage(im, [], para);

para              = [];
para.type         = 'flyThrough';
para.dimSlice     = 3;
visualizeImage(im, [], para);

 
% dynamic imaging, see visualizeImage.m for all parameter settings
T = 10;
for t=1:T
    imSequence{t}       = makeSphere([n,n,n], [0,1;0,1;0,1],...
                          (0.2* t/T + 0.4) * [1,1,1] , 0.2, 1);
end

para             = [];
para.type        = 'maxIntensity';
visualizeImage(imSequence, [], para);

para              = [];
para.type         = 'slicePlot';
para.dimSlice     = 1;
para.slices2show  = round(linspace(0.4,0.6,9) * n);
visualizeImage(imSequence, [], para);

%% visualizeMotion can be used to viualize (dynamic) vector fields. 
ccc

flow = load('wind');
v = cat(3, flow.v, flow.u);
v = scaleImage(v, [4,4,1] .* size(v), struct('interpolationMethod', 'spline')); 

para = [];
para.print      = true;
para.colorVisu  ='frame';
para.dimSlice   = 3;

visualizeMotion(v, [], para)

% pretend the z-slices are time indices to generate dynamic 2D motion field 
v = {};
for i=1:size(flow.v, 3)
   v{i} = cat(3, flow.v(:,:,i), flow.u(:,:,i));
   v{i} = scaleImage(v{i}, [4,4,1] .* size(v{i}), struct('interpolationMethod', 'spline')); 
end

para.colorVisu = 'wheel';
visualizeMotion(v, [], para)

%% RGB manipulation
ccc

n   = 256;
x   = linspace(-3,3,n);
im1 = exp( - x.^2 / 2);
im1 = im1' * im1;
im2 = phantom(n);

% overlay im1 in hot color scale on im2 in gray scale
para = [];
para.compositeMode = 'overlay';
para.thres         = 0.5;
para.fgPara.colorMap = 'hot';
para.bgPara.colorMap = 'gray';
RGB = rgbComposite(im1, im2, para);

figure(); 
subplot(1,3,1); imagesc(im1); colormap gray
subplot(1,3,2); imagesc(im2); colormap gray
subplot(1,3,3); image(RGB)

% mask certain areas of RGB
mask      = im2 == 0;
maskColor = str2RGB('green');
RGB = maskRGB(RGB, mask, maskColor);

% print RGB
para = [];
para.fileName = 'testOverlayRGB';
printRGB(RGB, para)

% mix two grayscale images into an RGB image

[im1, im2] = ndgrid(linspace(0,1,n), linspace(0,1,n));
para = [];
para.compositeMode = 'mixing';
para. mixingScheme = 'red2green';
RGB = rgbComposite(im1, im2, para);

figure(); 
subplot(1,3,1); imagesc(im1); colormap gray
subplot(1,3,2); imagesc(im2); colormap gray
subplot(1,3,3); image(RGB)

%% volume rendering
ccc

%conePlot is an adaptation of coneplot that can handle more general
%inputs
XYZ = randn(10,3);
UVW = rand(10,3);

para = [];
para.color    = str2RGB('yellow');  
para.addLight = true;
para.viewPoint = [1,1,1];

conePlot(XYZ, UVW, para);

% sphereplot draws 3D spheres of varing size
V = rand(10,1);
patchH = spherePlot(XYZ, V, para);

% isoSurfacePlot plots the iso-levels of a given image volume
n       = 100;
xGrid   = linspace(-1,1,n);
[X,Y,Z] = ndgrid(xGrid, xGrid, xGrid);
vol     = 1./sqrt(4 * X.^2 + Y.^2 + Z.^2 + 0.1);

para = [];
para.addLight = true;
para.viewPoint = [1,1,1];
isoSurfacePlot(vol, [], para);

%% covariance plot
ccc

X        = randn(333,33) .* repmat(1:33, 333, 1);
covMat   = cov(X);

para = [];
covariancePlot(covMat, para);
 
para.plotCorr = true;
covariancePlot(covMat, para);

%% contour plots
ccc

% extractContourLines extracts the countour lines from the contour matrix
% % retruned by contour.m
C = contour(peaks(200)); close all force
[LinesCell, Values] = extractContourLines(C);
cMap                = getColorMap('green',length(LinesCell));
figure();
for i=1:length(LinesCell)
    plot(LinesCell(i).x, LinesCell(i).y, 'Color', cMap(i,:), 'LineWidth', 1); 
    hold on
end
