function TFmat = pixelHit(N, X)
% PIXELHIT determines which of the NxN pixels subdividing [0,1]^2 are hit 
% by points in X
%
% USAGE:
%  TFmat = pixelHit(N, X)
%
%  INPUTS:
%   N - number of pixels in one direction 
%   X - m x 2 matrix containing the coordinates of m points in [0,1]^2 
%
%  OUTPUTS:
%   TFmat - a N x N true/false matrix indicating which pixels where hit.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also

TFmat = false(N, N);

% scale from [0, 1] to [0, N]
X = X * N;

% get the pixels that are hit
xInd = ceil(X(:,1));
yInd = ceil(X(:,2));

TFmat(sub2ind([N, N], xInd, yInd)) = true;

end