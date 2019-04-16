function [Im, refCard] = rgbComposite(Im1, Im2, para)
% RGBCOMPOSITE mixes two gray scale images into an RGB
%
% DETAILS:
% rgbComposite.m takes two non-negative intensity images and generates an
% RGB from then where wither the two different image dimensions have been mapped to
% a color code or one is shown overlayed on the other
%
% USAGE:
%   [Im, RefCard] = RGBcomposite(rand(100), rand(100), [])
%
% INPUTS:
%   Im1 - first  non-negative intensity image
%   Im2 - second non-negative intensity image
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'resIncExp' - the resolution will be increased resIncExp times by 2
%       'compositeMode' - string defining how to compose Im1 and Im2
%                         'mixing'  - the 2D vector field build be of the pixel
%                         values in Im1 and Im2 is mapped onto a 2D colour
%                         chart.
%                         'overlay' - Im1 is thresolded and overlayed with a 
%                         certain alpha value and color scale on a colour coded 
%                         version of Im2
%
%       further parameters for compositeMode = 'mixing' 
%       'mixingScheme' - define a scheme to colour both inputs:
%                        'red2green','rainbow','trafficlight'
%                        use RefCard to view them
%       'refCardRes' - resolution of the refCard image
%       
%       further parameters for compositeMode = 'overlay' 
%       'thres' - relative threshold between 0 and 1 below which value of
%       Im1 just the RGB of Im2 should be shown
%       'fgPara'/'bgPara' strucs with parameters used in data2RGB to convert Im1/Im2
%       into an RGB, such as 'colorMap'
%       'alphaOverlay' - alpha value in [0, 1] which to use in the overlay: 
%       0 = no overlay, 1 = hard overlay which Im1 completely masks Im2 in all
%       areas that are not thresholded.
%       
%
% OUTPUTS:
%   Im      - the mixed RGB image
%   refCard - an image that displays the mapping used
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 06.12.2018
%
% See also overlayRGBs

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% check for negative values
if(anyAll(Im1 < 0) || anyAll(Im1 < 0))
    error('Both input images must be non-negative')
end

% scale to [0 1]
Im1 = Im1 / max(max(Im1));
Im2 = Im2 / max(max(Im2));

% increase the image resolution by interpolation
resIncExp = checkSetInput(para,'resIncExp', 'double', 0);
Im1       = interp2(Im1, resIncExp);
Im2       = interp2(Im2, resIncExp);

% define the mixing scheme
compositeMode = checkSetInput(para, 'compositeMode', {'mixing', 'overlay'},...
    'mixing');

refCard = [];

switch compositeMode
    
    case 'mixing'
        
        mixingScheme = checkSetInput(para,'mixingScheme', ...
            {'red2green', 'rainbow', 'trafficlight'}, 'rainbow');
        
        [X, Y] = meshgrid(0:0.5:1, 0:0.5:1);
        switch mixingScheme
            case 'red2green'
                R = X;
                G = Y;
                B = zeros(size(X));
            case 'rainbow'
                R = [0,1,1;0,0,1;0,0.5,1];
                G = [0,1,0;1,1,0.5;0,0.5,0];
                B = [0,0,0;1,0,0.5;1,1,1];
            case 'trafficlight'
                R = [0,0.5,1;0,1,0.5;0,0.5,1];
                G = [0,0,0;0.5,1,0.5;1,0.5,1];
                B = [0,0,0;0,0,0.5;0,0.5,1];
        end
        
        % generate reference image RefCard
        refCardRes     = checkSetInput(para, 'refCardRes', 'i,>0', 500);
        [X_ref, Y_ref] = meshgrid(linspace(0, 1, refCardRes));
        
        refCard        = zeros(refCardRes,refCardRes,3);
        refCard(:,:,1) = interp2(X, Y, R, X_ref, Y_ref);
        refCard(:,:,2) = interp2(X, Y, G, X_ref, Y_ref);
        refCardalphaOverlay(:,:,3) = interp2(X, Y, B, X_ref, Y_ref);
        
        % generate mixed RGB image
        Im        = zeros(size(Im1,1),size(Im1,2),3);
        Im(:,:,1) = reshape(interp2(X,Y,R,Im1(:),Im2(:)),size(Im1,1),size(Im1,2));
        Im(:,:,2) = reshape(interp2(X,Y,G,Im1(:),Im2(:)),size(Im1,1),size(Im1,2));
        Im(:,:,3) = reshape(interp2(X,Y,B,Im1(:),Im2(:)),size(Im1,1),size(Im1,2));
        
    case 'overlay'
        
        thres   = checkSetInput(para, 'thres', 'double', 0.1);
        fgPara  = checkSetInput(para, 'fgPara', 'struct', struct('colorMap', 'parula'));
        bgPara  = checkSetInput(para, 'bgPara', 'struct', struct('colorMap', 'gray'));
        alphaOverlay = checkSetInput(para,'alphaOverlay', 'double', 0.5);
        
        RGB1    = data2RGB(Im1, fgPara);
        RGB2    = data2RGB(Im2, bgPara);
        
        % take FgIm_mask as alpha
        fgAlpha = alphaOverlay * (Im1 > thres);
        
        smooth = checkSetInput(para,'smoothFGmask','logical',true);
        if(smooth)
            % TODO: replace by gaussianKernel.m
            fgAlpha = imfilter(fgAlpha, fspecial('gaussian',...
                                2^(resIncExp+1),2^(resIncExp)));
        end
        
        Im = overlayRGBs(RGB1, RGB2, fgAlpha);
        
end

end