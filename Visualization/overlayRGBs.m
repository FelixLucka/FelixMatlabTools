function RGB12 = overlayRGBs(RGB1, RGB2, alpha1)
%OVERLAYRGBS computes a convex combination of two RGBs
%
% USAGE:
%   i12 = overlayRGBs(i1, i2, 0.3) produces 0.3 * i1 + 0.7 * i2;
%
% INPUTS:
%   RGB1   - n x m x 3 numerical array interpreted as first RGB image
%   RGB1   - n x m x 3 numerical array interpreted as second RGB image
%   alpha1 - alpha value between 0 and 1 interpreted as alpha value of the
%            first image, can be an n x m logical mask or a single logical 
%
% OUTPUTS:
%   RGB12 - n x m x 3 numerical array representing an overlay of the two 
%           input images
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also rgbComposite

if(0 <= minAll(alpha1) && maxAll(alpha1) <= 1)
    RGB12 =  bsxfun(@times, alpha1 ,RGB1) + bsxfun(@times, (1-alpha1), RGB2);
else
    error('alpha has to be between 0 and 1');
end

% clip numerical inaccuracies
RGB12 = max(0, min(RGB12, 1));

end