function slices = sliceArray(A, dim, sliceIndicies, squeezeArray)
%SLICEARRAY is a work-around that extracts slices along a specified dimension of an array
%
% DESCRIPTION:
%       sliceArray slices numerical arrays along a specified dimension
%
% USAGE:
%       slices = sliceArray(A, dim, sliceIndicies, squeezeFL)
%       slices = sliceArray(A,dim,sliceIndicies,squeezeFL)
%       slices = sliceArray(A,dim,sliceIndicies,squeezeFL)
%
% INPUTS:
%       A             - input array
%       dim           - dimension of the slices
%       sliceIndicies - indices of the slices
%
% OPTIONAL INPUTS:
%       squeezeArray - boolean controlling whether the resulting array is
%                      squeezed
%
% OUTPUTS:
%       slices  - output array containing the desired slices
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 03.12.2019
%
% See also cutArray



switch ndims(A)
    case 2
        switch dim
            case 1
                slices = A(sliceIndicies,:);
            case 2
                slices = A(:,sliceIndicies);
            otherwise
                if(isequal(sliceIndicies, 1))
                    slices = A;
                else
                    error('dim > ndims(A)')
                end
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
                if(isequal(sliceIndicies, 1))
                    slices = A;
                else
                    error('dim > ndims(A)')
                end
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
                if(isequal(sliceIndicies, 1))
                    slices = A;
                else
                    error('dim > ndims(A)')
                end
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
                if(isequal(sliceIndicies, 1))
                    slices = A;
                else
                    error('dim > ndims(A)')
                end
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
                if(isequal(sliceIndicies, 1))
                    slices = A;
                else
                    error('dim > ndims(A)')
                end
        end
    otherwise
        notImpErr
end

if(nargin > 3 && squeezeArray)
    slices = squeeze(slices);
end

end