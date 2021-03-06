function framedRGB = addFrameRGB(RGB, framesize, frameColor)
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
%       last update     - 05.11.2018
%
% See also addColorFrame maskRGB

Nx = size(RGB,1) + 2*framesize;
Ny = size(RGB,2) + 2*framesize;

framedRGB = cat(3,frameColor(1)*ones(Nx,Ny,'like',frameColor),...
                  frameColor(2)*ones(Nx,Ny,'like',frameColor),...
                  frameColor(3)*ones(Nx,Ny,'like',frameColor));
framedRGB(framesize+1:end-framesize, framesize+1:end-framesize,:) = RGB;

end