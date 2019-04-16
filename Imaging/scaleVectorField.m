function v = scaleVectorField(v, factors, dimVec)
%scaleVectorField scales the components of a multi-dimensional vector
%field with scalar factors
%
% USAGE:
%   v = scaleVectorField(ones(100,100,2), [2,3]) will result in v(:,:,1) =
%   2, v(:,:,2) = 3;
%
% INPUTS:
%   v - multi-dimensional vector field 
%   factors - factors to scale each vector component, must be of length of
%             the number of components
%
% OPTIONAL INPUTS
%   dimVec - dimension along which the vector components are indexed. By default, 
%            the last dimension is assumed to index the vector components
%
% OUTPUTS:
%   v - scaled factor field
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 11.01.2019
%       last update     - 11.01.2019
%
% See also scaleImage

% check for user defined input for dimVec, otherwise assign default
if(nargin < 3)
   dimVec =  nDims(v);
end


if(length(factors) ~= size(v, dimVec))
   error('length of the factors must coincide with the number of vector components')
end

onesVec         = ones(1, nDims(v));
onesVec(dimVec) = size(v, dimVec);
factors         = reshape(factors, onesVec);
v               = bsxfun(@times, v, factors);

end