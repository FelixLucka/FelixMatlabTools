function A = sumAllBut(A, dims_2_spare, squeeze_dim)
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
%       last update     - 24.09.2023
%
% See also sumAll, sum

% check user defined value for squeezeDim, otherwise assign default value
if(nargin < 3)
	squeeze_dim = true;
end


dim_A = ndims(A);

if(ischar(dims_2_spare) && strcmp(dims_2_spare, 'last'))
    dims_2_spare = dim_A;
end

for i_dim = dim_A:-1:1 
    if(not(ismember(i_dim, dims_2_spare)))
        A = sum(A, i_dim);
    end
end

if(squeeze_dim)
    A = squeeze(A);
end

end