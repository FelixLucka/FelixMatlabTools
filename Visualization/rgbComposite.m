function [im, ref_card] = rgbComposite(im1, im2, para)
% RGBCOMPOSITE mixes two gray scale images into an RGB
%
% DETAILS:
% rgbComposite.m takes two non-negative intensity images and generates an
% RGB from then where wither the two different image dimensions have been mapped to
% a color code or one is shown overlayed on the other
%
% USAGE:
%   [im, ref_card] = RGBcomposite(rand(100), rand(100), [])
%
% INPUTS:
%   im1 - first  non-negative intensity image
%   im2 - second non-negative intensity image
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
%   im      - the mixed RGB image
%   ref_card - an image that displays the mapping used
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 20.04.2023
%
% See also overlayRGBs

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% check for negative values
if(anyAll(im1 < 0) || anyAll(im2 < 0))
    error('Both input images must be non-negative')
end

% scale to [0 1]
im1 = im1 / maxAll(im1);
im2 = im2 / maxAll(im2);

% increase the image resolution by interpolation
res_inc_exp = checkSetInput(para,'resIncExp', 'double', 0);
im1         = interp2(im1, res_inc_exp);
im2         = interp2(im2, res_inc_exp);

% define the mixing scheme
composite_mode = checkSetInput(para, 'compositeMode', {'mixing', 'overlay'},...
    'mixing');

ref_card = [];

switch composite_mode
    
    case 'mixing'
        
        mixing_scheme = checkSetInput(para,'mixingScheme', ...
            {'red2green', 'rainbow', 'trafficlight'}, 'rainbow');
        
        [X, Y] = meshgrid(0:0.5:1, 0:0.5:1);
        switch mixing_scheme
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
        ref_card_res     = checkSetInput(para, 'refCardRes', 'i,>0', 500);
        [X_ref, Y_ref] = meshgrid(linspace(0, 1, ref_card_res));
        
        ref_card        = zeros(ref_card_res,ref_card_res,3);
        ref_card(:,:,1) = interp2(X, Y, R, X_ref, Y_ref);
        ref_card(:,:,2) = interp2(X, Y, G, X_ref, Y_ref);
        
        % generate mixed RGB image
        im        = zeros(size(im1,1),size(im1,2),3);
        im(:,:,1) = reshape(interp2(X,Y,R,im1(:),im2(:)),size(im1,1),size(im1,2));
        im(:,:,2) = reshape(interp2(X,Y,G,im1(:),im2(:)),size(im1,1),size(im1,2));
        im(:,:,3) = reshape(interp2(X,Y,B,im1(:),im2(:)),size(im1,1),size(im1,2));
        
    case 'overlay'
        
        thres   = checkSetInput(para, 'thres', 'double', 0.1);
        fg_para  = checkSetInput(para, 'fgPara', 'struct', struct('colorMap', 'parula'));
        bg_para  = checkSetInput(para, 'bgPara', 'struct', struct('colorMap', 'gray'));
        alpha_overlay = checkSetInput(para,'alphaOverlay', 'double', 0.5);
        
        RGB1    = data2RGB(im1, fg_para);
        RGB2    = data2RGB(im2, bg_para);
        
        % take FgIm_mask as alpha
        fg_alpha = alpha_overlay * (im1 > thres);
        
        smooth = checkSetInput(para,'smoothFGmask','logical',true);
        if(smooth)
            % TODO: replace by gaussianKernel.m
            fg_alpha = imfilter(fg_alpha, fspecial('gaussian',...
                                2^(res_inc_exp+1),2^(res_inc_exp)));
        end
        
        im = overlayRGBs(RGB1, RGB2, fg_alpha);
        
end

end