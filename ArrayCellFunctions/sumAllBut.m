function A = sumAllBut(A, dims2Spare, squeezeDim)
%SUMALLBUT sums along all dimensions of an array except those indicated
%
% DESCRIPTION: 
%   sumAllBut.m can be used to reduce the dimensions of an array by summing
%   while leaving certain dimensions intact.
%
% USAGE:
%   A = sumAllBut(randn(3,4,5,6), [2,4])
%
% INPUTS:
%   A          - numerical array
%   dims2Spare - dimensions along which not to sum. sumAllBut(A, 1) is
%   equal to the normal sum(A)
%
% OPTIONAL INPUTS
%   squeezeDim - boolean determining whether summed dimensions should be
%   prunned from array (applies squeeze(A) at the end). Default: true
%
% OUTPUTS:
%   A - array reduced by summation
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 23.10.2018
%       last update     - 23.10.2018
%
% See also sumAll, sum

% check user defined value for squeezeDim, otherwise assign default value
if(nargin < 3)
	squeezeDim = true;
end


dimA = ndims(A);
for iDim = dimA:-1:1 
    if(not(ismember(iDim, dims2Spare)))
        A = sum(A, iDim);
    end
end

if(squeezeDim)
    A = squeeze(A);
end

end