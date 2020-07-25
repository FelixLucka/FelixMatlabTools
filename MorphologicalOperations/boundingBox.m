function [BB, indices] = boundingBox(x)
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
%       last update     - 03.10.2019
%
% See also


BB      = true(size(x));
indices = zeros(nDims(x), 2);

for iDim = 1:nDims(x)
    red_x    = x;
    for jDime = 1:nDims(x)
        if(jDime ~= iDim)
            red_x = any(red_x, jDime);
        end
    end
    indices(iDim,1) = find(red_x(:), 1, 'first');
    indices(iDim,2) = find(red_x(:), 1, 'last');
    BB = bsxfun(@and , BB, red_x);
end

end