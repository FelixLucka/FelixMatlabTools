function slices = sliceArray(A, dim, sliceIndicies, squeezeArray)
%SLICEARRAY is a work-around that extracts slices along a specified dimension of an array 
%
% DESCRIPTION:
%       sliceArray slices numerical arrays along a specified dimension
%
% USAGE:
%       slices = sliceArray(A, dim, sliceIndicies)
%       slices = sliceArray(A, dim, sliceIndicies, squeezeArray)
%
% INPUTS:
%       A             - input array
%       dim           - dimension of the slices
%       sliceIndicies - indices of the slices 
% 
% OPTIONAL INPUTS:
%       squeezeArray  - boolean controlling whether the resulting array is
%                       squeezed
%
% OUTPUTS:
%       slices  - output array containing the desired slices
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 30.10.2018
%       last update     - 30.10.2018
%
% See also insertIntoArray

% check user defined value for squeezeArray, otherwise assign default value
if(nargin < 4)
    squeezeArray = false;
end

% 
switch ndims(A)
    case 2
        switch dim
            case 1
                slices = A(sliceIndicies,:);
            case 2
                slices = A(:,sliceIndicies);
            otherwise
                error('dim > ndims(A)')
        end
    case 3
        switch dim
            case 1
                slices = A(sliceIndicies,:,:);
            case 2
                slices = A(:,sliceIndicies,:);
            case 3
                slices = A(:,:,sliceIndicies);
            otherwise
                error('dim > ndims(A)')
        end
    case 4
        switch dim
            case 1
                slices = A(sliceIndicies,:,:,:);
            case 2
                slices = A(:,sliceIndicies,:,:);
            case 3
                slices = A(:,:,sliceIndicies,:);
            case 4
                slices = A(:,:,:,sliceIndicies);
            otherwise
                error('dim > ndims(A)')
        end 
    case 5
        switch dim
            case 1
                slices = A(sliceIndicies,:,:,:,:);
            case 2
                slices = A(:,sliceIndicies,:,:,:);
            case 3
                slices = A(:,:,sliceIndicies,:,:);
            case 4
                slices = A(:,:,:,sliceIndicies,:);
            case 5
                slices = A(:,:,:,:,sliceIndicies);
            otherwise
                error('dim > ndims(A)')
        end 
    case 6
        switch dim
            case 1
                slices = A(sliceIndicies,:,:,:,:,:);
            case 2
                slices = A(:,sliceIndicies,:,:,:,:);
            case 3
                slices = A(:,:,sliceIndicies,:,:,:);
            case 4
                slices = A(:,:,:,sliceIndicies,:,:);
            case 5
                slices = A(:,:,:,:,sliceIndicies,:);
            case 6
                slices = A(:,:,:,:,:,sliceIndicies);
            otherwise
                error('dim > ndims(A)')
        end 
    otherwise
        notImpErr
end

if(squeezeArray)
   slices = squeeze(slices); 
end

end