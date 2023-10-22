function im_ex = extrapolateOntoBoundary(im, mask, rep)
%EXTRAPOLATEONTOBOUNDARY EXTRAPOLATES THE CONTENTS OF A ROI ONTO ITS
%BOUNDARY 
%
% DESCRIPTION:
%       extrapolation of the values inside of an regin of interest onto its
%       boundary via gaussian weighted extrapolation from 6/27 neigbourhood
%
% USAGE:   
%       mask = makeSphere([160,160],[-1,1;-1,1],[0,0],0.5)> 0;
%       im = double(checkerboard(20) > 0.5) .* mask;
%       imagesc(extrapolateOntoBoundary(im, mask, 10))
%
% INPUTS:
%       im - image to extrapolate (everything outside mask will be set to 0)
%       mask - region of interest from which values will be interpolated
%       onto the boundary of the mask
%
% OPTIONAL INPUTS:
%       rep - number of times this operation will be repeated
%
% OUTPUTS:
%       im_ex - image with values from mask extraploated onto the boundary
%       of the mask rep times
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 18.12.2019
%       last update     - 29.09.2023
%
%
% See also


% check user defined value for z, otherwise assign default value
if(nargin < 3)
    rep = 1;
end

% get size of volume and create output mask
dim                 = nDims(im);
kernel              = gaussianKernel(dim, 1, 1);
%mask_org            = mask;
im                  = im .* mask;
im_ex               = im;
 
for i=1:rep
    im_ex               = convn(im, kernel, 'same');
    weight              = convn(mask, kernel, 'same');
    im_ex               = im_ex ./ weight;
    im_ex(isnan(im_ex) | isinf(im_ex)) = 0;
    im_ex(mask)         = im(mask);
    mask                = weight > 0;
    im                  = im_ex;
end

end
