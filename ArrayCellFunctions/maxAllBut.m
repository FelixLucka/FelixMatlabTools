function A = maxAllBut(A, dims2Ignore)
%MAXALLBUT applies the max function along all dimensions of A except the
% specified one
%     
% DESCRIPTION: 
%   maxAllBut.m applies the max function along all dimensions of A except the
%       specified one, i.e., maxAllBut(A, 1) is the same as max(A) if A is
%       a multi-dimensional array
%
% USAGE:
%   A = maxAllBut(randn([2,3,4,5]), [1,3])
%
%  INPUTS:
%   A           - input array
%   dims2Ignore - input dimensions along which no max operation is performed
%
%  OUTPUTS:
%   A  - output array containing the maximal value along all but the
%        specified dimension. As such, it is a matrix of size dims2Spare   
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also maxDiff, maxAll

dimA = ndims(A);
for iDim = dimA:-1:1 
    if(not(ismember(iDim, dims2Ignore)))
        A = max(A, [], iDim);
    end
end

A = squeeze(A);

end