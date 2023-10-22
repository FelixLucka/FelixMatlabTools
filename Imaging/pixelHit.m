function tf_mat = pixelHit(N, X)
% PIXELHIT determines which of the NxN pixels subdividing [0,1]^2 are hit 
% by points in X
%
% USAGE:
%  tf_mat = pixelHit(N, X)
%
%  INPUTS:
%   N - number of pixels in one direction 
%   X - m x 2 matrix containing the coordinates of m points in [0,1]^2 
%
%  OUTPUTS:
%   tf_mat - a N x N true/false matrix indicating which pixels where hit.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also

tf_mat = false(N, N);

% scale from [0, 1] to [0, N]
X = X * N;

% get the pixels that are hit
x_ind = ceil(X(:,1));
y_ind = ceil(X(:,2));

tf_mat(sub2ind([N, N], x_ind, y_ind)) = true;

end