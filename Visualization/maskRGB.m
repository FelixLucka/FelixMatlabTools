function RGB = maskRGB(RGB, mask, maskColor)
% MASKRGB adds a mask to a given RGB
%
% USAGE:
%  maskedRGB = maskRGB(RGB, mask, [1,0,0])
%
%  INPUTS:
%   RGB        - RGB image in the format N x M x 3
%   mask       - a N x M matrix of logicals
%   maskColor  - 3x1 vector indicating the RGB colour code of the mask
%
%  OUTPUTS:
%   RGB - the masked RGB with a frame
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also addFrameRGB

sizeRGB = size(RGB);
RGB     = reshape(RGB, [], 3);

RGB(mask(:), 1) = maskColor(1);
RGB(mask(:), 2) = maskColor(2);
RGB(mask(:), 3) = maskColor(3);

RGB = reshape(RGB, sizeRGB);

end