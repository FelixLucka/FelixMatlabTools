function A = cutArray(A, cut_size, dir)
%CUTARRAY clips margins of an array
%
% DESCRIPTION:
%       cutArray is the reverse of padArray, it clips of columns and rows
%       at the boundary of arrays
%
% USAGE:
%       A_cut = cutArray(A, [3,4], 'both) will clip of the first and last 3
%       columns and first and last 4 rows of A, i.e., 
%       A_cut = A(4:end-3, 5:end-4)
%
% INPUTS:
%       A       - up to 4-dim array
%       cut_size - a vector specifying how many layers to cut away
%       dir     - direction in which to cut, can be 'both' for beginning and
%             end, 'pre' for only at the beginning and 'post' for only at the end
%
% OUTPUTS:
%       A   - input array clipped by cutSize
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 24.09.2023
%
% See also padArray


if(isvector(A))
    
    % A is a vector
    if(length(cut_size) > 1)
        cut_size = max(cut_size);
    end
    switch dir
        case 'both'
            A = A((cut_size+1):(end-cut_size));
        case 'pre'
            A = A((cut_size+1):end);
        case 'post'
            A = A(1:(end-cut_size));
        otherwise
            error('invalid choise for ''dir''')
    end
    
else
    
    % A is matrix or volume 
    switch ndims(A)
        case 2
            switch dir
                case 'both'
                    A = A((cut_size(1)+1):(end-cut_size(1)),(cut_size(2)+1):(end-cut_size(2)));
                case 'pre'
                    A = A((cut_size(1)+1):end,(cut_size(2)+1):end);
                case 'post'
                    A = A(1:(end-cut_size(1)),1:(end-cut_size(2)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        case 3
            switch dir
                case 'both'
                    A = A((cut_size(1)+1):(end-cut_size(1)),(cut_size(2)+1):(end-cut_size(2)),(cut_size(3)+1):(end-cut_size(3)));
                case 'pre'
                    A = A((cut_size(1)+1):end,(cut_size(2)+1):end,(cut_size(3)+1):end);
                case 'post'
                    A = A(1:(end-cut_size(1)),1:(end-cut_size(2)),1:(end-cut_size(3)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        case 4
            switch dir
                case 'both'
                    A = A((cut_size(1)+1):(end-cut_size(1)),(cut_size(2)+1):(end-cut_size(2)),...
                        (cut_size(3)+1):(end-cut_size(3)),(cut_size(4)+1):(end-cut_size(4)));
                case 'pre'
                    A = A((cut_size(1)+1):end,(cut_size(2)+1):end,(cut_size(3)+1):end,(cut_size(4)+1):end);
                case 'post'
                    A = A(1:(end-cut_size(1)),1:(end-cut_size(2)),1:(end-cut_size(3)),1:(end-cut_size(4)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        otherwise
            notImpErr
    end
    
end

end