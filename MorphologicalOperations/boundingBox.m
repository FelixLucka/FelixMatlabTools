function [bb, indices] = boundingBox(x)
%BOUNDINGBOX returns the smallest rectangular volume covering an ROI
%
% USAGE:
%   [BB, indices] = boundingBox(image > 0.5)
%
% INPUTS:
%   x - logical array of arbitrary dimension
%
% OUTPUTS:
%   BB - logical array of the same size as x which is "true" in the
%        bounding box of x
%   indices - array of size nDims(x) x 2 with the starting and ending
%             indices of the bounding box
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.10.2019
%       last update     - 16.05.2023
%
% See also


bb      = true(size(x));
indices = zeros(nDims(x), 2);

for i_dim = 1:nDims(x)
    red_x    = x;
    for j_dim = 1:nDims(x)
        if(j_dim ~= i_dim)
            red_x = any(red_x, j_dim);
        end
    end
    indices(i_dim,1) = find(red_x(:), 1, 'first');
    indices(i_dim,2) = find(red_x(:), 1, 'last');
    bb = bsxfun(@and , bb, red_x);
end

end