function newIm = decImageRes(im, fac, average)
%DECIMAGERES decreases the resolution of an image by summing or averaging pixels
%
% DESCRIPTION:
%   decImageRes.m can be used to decrease de the resolution of an
%   image by summing its pixels, i.e., no interpolation is performed.
%
% USAGE:
%   IncImageRes(randi(100,8,6), [4,2]) returns a 2x3 image
%
% INPUTS:
%   im      - 2D numerical array
%   fac     - todo
%   average - bool indicating if averaging should be performed
%
% OUTPUTS:
%   newIm - reduced image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.06.2020
%       last update     - 17.06.2020
%
% See also scaleImage

% check user defined value for average, otherwise assign default value
if(nargin < 3)
    average = true;
end

if(~ (isequal(mod(fac,1),[0,0])))
    error('res must be of format [i,j] with i and j being the integer factor by which the resolution should be increased')
end

newIm = im(1:fac(1):end, :);
for i=2:fac(1)
    newIm = newIm + im(i:fac(1):end, :);
end
if(average)
    newIm = newIm / fac(1);
end
im = newIm;

newIm = im(:,1:fac(2):end);
for j=2:fac(2)
    newIm = newIm + im(:, j:fac(2):end);
end
if(average)
    newIm = newIm / fac(2);
end

end