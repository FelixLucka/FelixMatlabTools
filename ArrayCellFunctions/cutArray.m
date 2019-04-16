function A = cutArray(A, cutSize, dir)
%CUTARRAY clips margins of an array
%
% DESCRIPTION:
%       cutArray is the reverse of myPadarray, it clips of columns and rows
%       at the boundary of arrays
%
% USAGE:
%       A_cut = cutArray(A, [3,4], 'both) will clip of the first and last 3
%       columns and first and last 4 rows of A, i.e., 
%       A_cut = A(4:end-3, 5:end-4)
%
% INPUTS:
%       A       - up to 4-dim array
%       cutSize - a vector specifying how many layers to cut away
%       dir     - direction in which to cut, can be 'both' for beginning and
%             end, 'pre' for only at the beginning and 'post' for only at the end
%
% OUTPUTS:
%       A   - input array clipped by cutSize
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 05.04.2018
%
% See also padArray


if(isvector(A))
    
    % A is a vector
    if(length(cutSize) > 1)
        cutSize = max(cutSize);
    end
    switch dir
        case 'both'
            A = A((cutSize+1):(end-cutSize));
        case 'pre'
            A = A((cutSize+1):end);
        case 'post'
            A = A(1:(end-cutSize));
        otherwise
            error('invalid choise for ''dir''')
    end
    
else
    
    % A is matrix or volume 
    switch ndims(A)
        case 2
            switch dir
                case 'both'
                    A = A((cutSize(1)+1):(end-cutSize(1)),(cutSize(2)+1):(end-cutSize(2)));
                case 'pre'
                    A = A((cutSize(1)+1):end,(cutSize(2)+1):end);
                case 'post'
                    A = A(1:(end-cutSize(1)),1:(end-cutSize(2)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        case 3
            switch dir
                case 'both'
                    A = A((cutSize(1)+1):(end-cutSize(1)),(cutSize(2)+1):(end-cutSize(2)),(cutSize(3)+1):(end-cutSize(3)));
                case 'pre'
                    A = A((cutSize(1)+1):end,(cutSize(2)+1):end,(cutSize(3)+1):end);
                case 'post'
                    A = A(1:(end-cutSize(1)),1:(end-cutSize(2)),1:(end-cutSize(3)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        case 4
            switch dir
                case 'both'
                    A = A((cutSize(1)+1):(end-cutSize(1)),(cutSize(2)+1):(end-cutSize(2)),...
                        (cutSize(3)+1):(end-cutSize(3)),(cutSize(4)+1):(end-cutSize(4)));
                case 'pre'
                    A = A((cutSize(1)+1):end,(cutSize(2)+1):end,(cutSize(3)+1):end,(cutSize(4)+1):end);
                case 'post'
                    A = A(1:(end-cutSize(1)),1:(end-cutSize(2)),1:(end-cutSize(3)),1:(end-cutSize(4)));
                otherwise
                    error('invalid choise for ''dir''')
            end
        otherwise
            notImpErr
    end
    
end

end