function RGB = addColorFrame(RGB, frame_thickness)
% ADDCOLORFRAME adds a frame to the RGB indicating the color coding of
% vectors in [-1,1]^2
%
%  USAGE:
%     RGB = addColorFrame(RGB, 10) add a frame which is 10 pixels wide
%
%  INPUTS:
%   RGB    - RGB to add the frame to
%   frame_thickness - thickness of the frame in pixels
%
%  OUTPUTS:
%   RGB     - the original RGB with a frame containing the colors that are used to
%             display vectors with a corresponding direction and amplitude
%             (the input area is supposed to represent [-1,1]^2)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 13.10.2023
%
% See also addFrameRGB

% extract single color chanels
for i=1:3
    color_channel{i} = RGB(:, :, i);
end
clear RGB

% add a black frame of at least one pixel size
n_back_pix = max(1, ceil(frame_thickness/5));
for i=1:3
    color_channel{i} = padarray(color_channel{i}, [n_back_pix, n_back_pix]);
end

% prepare direction-encoded image in which the original RGB will be embedded
n_x = size(color_channel{i}, 1) + 2 * frame_thickness;
n_y = size(color_channel{i}, 2) + 2 * frame_thickness;

[X, Y] = ndgrid(linspace(-1, 1, n_x), linspace(-1, 1, n_y));

angle = wrapTo2Pi(atan2(Y, X)) / (2*pi);

colors = hsv2rgb([angle(:), ones(n_x*n_y, 2)]);

RGB(:, :, 1) = reshape(colors(:, 1), size(X));
RGB(:, :, 2) = reshape(colors(:, 2), size(X));
RGB(:, :, 3) = reshape(colors(:, 3), size(X));

% re-embed original RGB into direction-encoded larger RGB
for i=1:3
   RGB(frame_thickness+1:end-frame_thickness, ....
       frame_thickness+1:end-frame_thickness , i) = color_channel{i};
end

end
