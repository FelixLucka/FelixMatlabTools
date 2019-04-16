function newIm = incImageRes(im, res)
%INCIMAGERES increases the resolution of an image by cloning pixels (no
%interpolation) 
%
% DESCRIPTION: 
%   IncImageRes.m can be used to artificially increase the resolution of an
%   image by cloning its pixels, i.e., no interpolation is performed.
%
% USAGE:
%   IncImageRes(randi(100,3,2), [2,1]) returns a 6x2 image, where 
%   im(1,1) == im(2,1) and so on. 
%
% INPUTS:
%   im - 2D numerical array
%   res - numer of new pixels into which each pixel is cloned, i.e., for 
%         res = [3,2], each pixel in im is replaced by a block of size 3x2
%         with the same value
%
% OUTPUTS:
%   newIm - upsampled image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also scaleImage

if(~ (isequal(mod(res,1),[0,0])))
    error('res must be of format [i,j] with i and j being the integer factor by which the resolution should be increased')
end

[m,n] = size(im);

im_incX = zeros(m*res(1),n, 'like', im);
for i=1:res(1)
    im_incX(i:res(1):end,:) = im;
end

newIm = zeros(m*res(1),n*res(2), 'like', im);
for j=1:res(2)
    newIm(:,j:res(2):end) = im_incX; 
end

end