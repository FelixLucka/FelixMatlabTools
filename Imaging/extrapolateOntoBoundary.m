function im_ex = extrapolateOntoBoundary(im, mask, times)
%EXTRACTSURFOFLOGVOL 
%
% DESCRIPTION:
%       gaussian weighted extrapolation from 6/27 neigbourhood
%
% USAGE:
%       
%
% INPUTS:
%       
%
% OPTIONAL INPUTS:
%       
%
% OUTPUTS:
%       
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 18th Dec 2019
%       last update     - 18th Dec 2019
%
%
% See also


% check user defined value for z, otherwise assign default value
if(nargin < 3)
    times = 1;
end

% get size of volume and create output mask
dim                 = nDims(im);
kernel              = gaussianKernel(dim, 1, 1);
%mask_org            = mask;
im_ex               = im;

for i=1:times
    im_ex               = convn(im, kernel, 'same');
    weight              = convn(mask, kernel, 'same');
    im_ex               = im_ex ./ weight;
    im_ex(isnan(im_ex) | isinf(im_ex)) = 0;
    im_ex(mask)         = im(mask);
    mask                = weight > 0;
    im                  = im_ex;
end

end
