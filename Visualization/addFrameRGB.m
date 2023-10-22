function framed_RGB = addFrameRGB(RGB, frame_sz, frame_color)
% FRAMEDRGB adds a frame to an image given as a RGB
%
%  USAGE:
%  framedRGB = addFrameRGB(RGB, 3, [1,0,0])
%
%  INPUTS:
%   RGB        - RGB image in the format N x M x 3
%   framesize  - size of the frame in prixels
%   frameColor - 3x1 vector indicating the RGB colour code of the frame
%
%  OUTPUTS:
%   framedRGB - the RGB with a frame
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 13.10.2023
%
% See also addColorFrame maskRGB

n_x = size(RGB,1) + 2 * frame_sz;
n_y = size(RGB,2) + 2 * frame_sz;

framed_RGB = cat(3,frame_color(1)*ones(n_x,n_y,'like',frame_color),...
                  frame_color(2)*ones(n_x,n_y,'like',frame_color),...
                  frame_color(3)*ones(n_x,n_y,'like',frame_color));
framed_RGB(frame_sz+1:end-frame_sz, frame_sz+1:end-frame_sz,:) = RGB;

end