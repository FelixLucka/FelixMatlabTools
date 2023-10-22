function A = insertIntoArray(A, A_slices, dim, slice_indicies)
% INSERTINTOARRY is a work-around that inserts slices into an array 
%     
% DESCRIPTION: 
%   insertIntoArray is a work-around that inserts slices along a specified 
%   dimension of an array 
%
% USAGE:
%   insertIntoArray(A,A_slices,2,[3,4]) inserts two slices into array A
%
%  INPUTS:
%   A   - input array
%   A_slices - the slices that should inserted into A
%   dim - dimension of the slices
%   slice_indicies - indices of the slices 
%
%  OUTPUTS:
%   A  - output array containing the inserted slices
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 24.09.2023
%
% See also: sliceArray, stretchVec


switch ndims(A)
    case 2
        switch dim
            case 1
                A(slice_indicies, :) = A_slices;
            case 2
                A(:, slice_indicies) = A_slices;
            otherwise
                error('dim > ndims(A)')
        end
    case 3
        switch dim
            case 1
                A(slice_indicies, :, :) = A_slices;
            case 2
                A(:, slice_indicies, :) = A_slices;
            case 3
                A(:, :, slice_indicies) = A_slices;
            otherwise
                error('dim > ndims(A)')
        end
    case 4
        switch dim
            case 1
                A(slice_indicies, :, :, :) = A_slices;
            case 2
                A(:, slice_indicies, :, :) = A_slices;
            case 3
                A(:, :, slice_indicies, :) = A_slices;
            case 4
                A(:, :, :, slice_indicies) = A_slices;
            otherwise
                error('dim > ndims(A)')
        end
    case 5
        switch dim
            case 1
                A(slice_indicies, :, :, :, :) = A_slices;
            case 2
                A(:, slice_indicies, :, :, :) = A_slices;
            case 3
                A(:, :, slice_indicies, :, :) = A_slices;
            case 4
                A(:, :, :, slice_indicies, :) = A_slices;
            case 5
                A(:, :, :, :, slice_indicies) = A_slices;
            otherwise
                error('dim > ndims(A)')
        end
    case 6
        switch dim
            case 1
                A(slice_indicies, :, :, :, :, :) = A_slices;
            case 2
                A(:, slice_indicies, :, :, :, :) = A_slices;
            case 3
                A(:, :, slice_indicies, :, :, :) = A_slices;
            case 4
                A(:, :, :, slice_indicies, :, :) = A_slices;
            case 5
                A(:, :, :, :, slice_indicies, :) = A_slices;
            case 6
                A(:, :, :, :, :, slice_indicies) = A_slices;
            otherwise
                error('dim > ndims(A)')
        end
    otherwise
        notImpErr
end


end