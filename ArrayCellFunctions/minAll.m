function [res, ind] = minAll(x)
%MINALL is a wrapper for min that can also return the sub-script indices
%for multidimensional arrays
%
% USAGE:
%   res         = minAll(x)
%   [resm, ijk] = minAll(x)
%
% INPUTS:
%   x - multi-dimensional array
%
% OUTPUTS:
%   res - minimal value found in x
%   ind - array of subscript indices of the minimal value
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 16.11.2021
%
% See also maxAll, maxAllBut, sumAll, anyAll

if(nargout > 1)
    [res, ind] = min(x(:));
    switch nDims(x)
        case 1
            
        case 2
            [i,j]   = ind2sub(size(x), ind);
            ind     = [i,j];
        case 3
            [i,j,k] = ind2sub(size(x), ind);
            ind     = [i,j,k];
        case 4
            [i,j,k, l] = ind2sub(size(x), ind);
            ind     = [i,j,k, l];
        otherwise
            notImpErr
    end
else
    res = min(x(:));
end

end