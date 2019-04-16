function A = insertIntoArray(A, Aslices, dim, sliceIndicies)
% INSERTINTOARRY is a work-around that inserts slices into an array 
%     
% DESCRIPTION: 
%   insertIntoArray is a work-around that inserts slices along a specified 
%   dimension of an array 
%
% USAGE:
%   insertIntoArray(A,Aslices,2,[3,4]) inserts two slices into array A
%
%  INPUTS:
%   A   - input array
%   Aslices - the slices that should inserted into A
%   dim - dimension of the slices
%   sliceIndicies - indices of the slices 
%
%  OUTPUTS:
%   A  - output array containing the inserted slices
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also: sliceArray, stretchVec


switch ndims(A)
    case 2
        switch dim
            case 1
                A(sliceIndicies, :) = Aslices;
            case 2
                A(:, sliceIndicies) = Aslices;
            otherwise
                error('dim > ndims(A)')
        end
    case 3
        switch dim
            case 1
                A(sliceIndicies, :, :) = Aslices;
            case 2
                A(:, sliceIndicies, :) = Aslices;
            case 3
                A(:, :, sliceIndicies) = Aslices;
            otherwise
                error('dim > ndims(A)')
        end
    case 4
        switch dim
            case 1
                A(sliceIndicies, :, :, :) = Aslices;
            case 2
                A(:, sliceIndicies, :, :) = Aslices;
            case 3
                A(:, :, sliceIndicies, :) = Aslices;
            case 4
                A(:, :, :, sliceIndicies) = Aslices;
            otherwise
                error('dim > ndims(A)')
        end
    case 5
        switch dim
            case 1
                A(sliceIndicies, :, :, :, :) = Aslices;
            case 2
                A(:, sliceIndicies, :, :, :) = Aslices;
            case 3
                A(:, :, sliceIndicies, :, :) = Aslices;
            case 4
                A(:, :, :, sliceIndicies, :) = Aslices;
            case 5
                A(:, :, :, :, sliceIndicies) = Aslices;
            otherwise
                error('dim > ndims(A)')
        end
    case 6
        switch dim
            case 1
                A(sliceIndicies, :, :, :, :, :) = Aslices;
            case 2
                A(:, sliceIndicies, :, :, :, :) = Aslices;
            case 3
                A(:, :, sliceIndicies, :, :, :) = Aslices;
            case 4
                A(:, :, :, sliceIndicies, :, :) = Aslices;
            case 5
                A(:, :, :, :, sliceIndicies, :) = Aslices;
            case 6
                A(:, :, :, :, :, sliceIndicies) = Aslices;
            otherwise
                error('dim > ndims(A)')
        end
    otherwise
        notImpErr
end


end