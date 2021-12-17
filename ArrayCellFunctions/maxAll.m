function [res, ind] = maxAll(x)
%MAXALL is a wrapper for max that can also return the sub-script indices
%for multidimensional arrays
%
% USAGE:
%   res         = maxAll(x)
%   [resm, ijk] = maxAll(x)
%
% INPUTS:
%   x - multi-dimensional array
%
% OUTPUTS:
%   res - maximal value found in x
%   ind - array of subscript indices of the maximal value
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 16.11.2021
%
% See also minAll, maxAllBut, sumAll, anyAll

if(nargout > 1)
    [res, ind] = max(x(:));
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
    res = max(x(:));
end

end