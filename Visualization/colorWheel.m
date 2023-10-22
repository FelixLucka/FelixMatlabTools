function RGB = colorWheel(n_res)
% COLORWHEEL returns an RBG to display the conversion of direction into color
%
%  RGB = colorWheel(n_res)
%
%  INPUTS:
%   n_res    - number of pixels in one direction of the RGB that is returned
%
%  OUTPUTS:
%   rgb     - a n_res x n_res RGB containing the colors that are used to
%             display vectors with a corresponding direction and amplitude
%             (the square is supposed to represent [-1,1]^2
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 13.10.2023
%
% See also addColorFrame

% create ndgrid
[X, Y] = ndgrid(linspace(-1, 1, n_res),linspace(-1, 1, n_res));
RGB    = ones([size(X), 3]);

% compute magitude and angle of mesh vectors
mag   = sqrt(X.^2 + Y.^2);
angle = wrapTo2Pi(atan2(Y, X)) / (2*pi);

% clip all ouside of sphere 
mag(mag > 1) = 0;

% assign colours
colors = hsv2rgb([angle(:), mag(:), ones(size(mag(:)))]);

% combine to RGB
RGB(:, :, 1) = reshape(colors(:, 1), size(X));
RGB(:, :, 2) = reshape(colors(:, 2), size(X));
RGB(:, :, 3) = reshape(colors(:, 3), size(X));

end
