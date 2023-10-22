function x = pad2size(x, target_size, v)
%PAD2SIZE pads an image such that is has a given size
%
% DESCRIPTION: 
%   pad2size.m can be used to pad images of different size to obtain the
%   given target size
%
% USAGE:
%   x = pad2size(randn(randi(100,1,1), [100, 100]) creates a random NxN
%   image, where N is a random number between 1 and 100 and then pads it by
%   0 to size 100x100
%
% INPUTS:
%   x - image of any size
%   target_size - desired larger size of the image 
%   
% OPTIONAL INPUTS:
%   v value in the padded areas
%
% OUTPUTS:
%   x - padded image of size targetSize
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also padArray, cutArray

% check user defined value for v, otherwise assign default value
if(nargin < 3)
    v = 0;
end

size_x = size(x);
if(any(size_x > target_size))
   notImpErr 
end

x = padArray(x, floor((target_size - size_x) / 2), v, 'pre');
x = padArray(x, ceil(( target_size - size_x) / 2), v, 'post');

end