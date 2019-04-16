function X = pad2size(X, targetSize, v)
%PAD2SIZE pads an image such that is has a given size
%
% DESCRIPTION: 
%   pad2size.m can be used to pad images of different size to obtain the
%   given target size
%
% USAGE:
%   X = pad2size(randn(randi(100,1,1), [100, 100]) creates a random NxN
%   image, where N is a random number between 1 and 100 and then pads it by
%   0 to size 100x100
%
% INPUTS:
%   X - image of any size
%   targetSize - desired larger size of the image 
%   
% OPTIONAL INPUTS:
%   v value in the padded areas
%
% OUTPUTS:
%   X - padded image of size targetSize
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also padArray, cutArray

% check user defined value for v, otherwise assign default value
if(nargin < 3)
    v = 0;
end

sizeX = size(X);
if(any(sizeX > targetSize))
   notImpErr 
end

X = padArray(X, floor((targetSize - sizeX) / 2), v, 'pre');
X = padArray(X, ceil(( targetSize - sizeX) / 2), v, 'post');

end