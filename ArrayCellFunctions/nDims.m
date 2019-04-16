function ndim = nDims(X, ignoreSingleton)
%nDims is a replacement for ndims which does not return 1 in case of
% column vectors
%
% DESCRIPTION: 
%   nDims.m yields the number of dimensions of multi-dimensional arrays
%
% USAGE:
%   ndim = nDims(X)
%
% INPUTS:
%   X - numerical array
%
% OPTIONAL INPUTS:
%   ignoreSingleton - logical indicating whether singleton dimensions
%   should be neglected
%
% OUTPUTS:
%   ndim - number of dimensions of X, 1 for vectors, 2 for matrices, 3 for
%   volumes...
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 07.07.2018
%       last update     - 07.07.2018
%
% See also ndims

% check user defined value for ignoreSingleton, otherwise assign default value
if(nargin < 2)
    ignoreSingleton = true;
end

if(ignoreSingleton)
    % squeeze X and get the size of that
    sizeX = size(squeeze(X));
else
    sizeX = size(X);
end
ndim = length(sizeX);

% 1D column vectors will reuturn a length of 1
if (ndim == 2) && (size(squeeze(X), 2) == 1)
    ndim = 1;
end


end