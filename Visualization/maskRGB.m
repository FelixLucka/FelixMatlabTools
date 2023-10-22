function RGB = maskRGB(RGB, mask, mask_color)
% MASKRGB adds a mask to a given RGB
%
% USAGE:
%  maskedRGB = maskRGB(RGB, mask, [1,0,0])
%
%  INPUTS:
%   RGB        - RGB image in the format N x M x 3
%   mask       - a N x M matrix of logicals
%   mask_color - 3x1 vector indicating the RGB colour code of the mask
%
%  OUTPUTS:
%   RGB - the masked RGB with a frame
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 14.10.2023
%
% See also addFrameRGB

sz_rgb = size(RGB);
RGB    = reshape(RGB, [], 3);

RGB(mask(:), 1) = mask_color(1);
RGB(mask(:), 2) = mask_color(2);
RGB(mask(:), 3) = mask_color(3);

RGB = reshape(RGB, sz_rgb);

end