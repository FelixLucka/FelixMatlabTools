function RGB = addColorFrame(RGB, frameThickness)
% ADDCOLORFRAME adds a frame to the RGB indicating the color coding of
% vectors in [-1,1]^2
%
%  USAGE:
%     RGB = addColorFrame(RGB, 10) add a frame which is 10 pixels wide
%
%  INPUTS:
%   RGB    - RGB to add the frame to
%   frameThickness - thickness of the frame in pixels
%
%  OUTPUTS:
%   RGB     - the original RGB with a frame containing the colors that are used to
%             display vectors with a corresponding direction and amplitude
%             (the input area is supposed to represent [-1,1]^2)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also addFrameRGB

% extract single color chanels
for i=1:3
    colorChannel{i} = RGB(:, :, i);
end
clear RGB

% add a black frame of at least one pixel size
nBackPix = max(1, ceil(frameThickness/5));
for i=1:3
    colorChannel{i} = padarray(colorChannel{i}, [nBackPix, nBackPix]);
end

% prepare direction-encoded image in which the original RGB will be embedded
Nx = size(colorChannel{i}, 1) + 2 * frameThickness;
Ny = size(colorChannel{i}, 2) + 2 * frameThickness;

[X, Y] = ndgrid(linspace(-1, 1, Nx), linspace(-1, 1, Ny));

angle = wrapTo2Pi(atan2(Y, X)) / (2*pi);

colors = hsv2rgb([angle(:), ones(Nx*Ny, 2)]);

RGB(:, :, 1) = reshape(colors(:, 1), size(X));
RGB(:, :, 2) = reshape(colors(:, 2), size(X));
RGB(:, :, 3) = reshape(colors(:, 3), size(X));

% re-embed original RGB into direction-encoded larger RGB
for i=1:3
   RGB(frameThickness+1:end-frameThickness, ....
       frameThickness+1:end-frameThickness , i) = colorChannel{i};
end

end
