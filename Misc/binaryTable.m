function T = binaryTable(n)
%BINARYTABLE contains all binary numbers 0:(2^n-1) as row vectors
%
%
% USAGE:
%   binaryTable(n) returns [0,0; 0 1; 1 0; 1 1];
%
% INPUTS:
%   n - exponent of 2^n
%
% OUTPUTS:
%   T - matrix of size 2^n x n containing all numbers from 0 to 2^n-1 as 
%       binary code as row vectors
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 19.12.2018
%
% See also decimal2Binary

T      = false(2^n, n);
for i = 2:2^n
    T(i,:) = decimal2Binary(i-1, n);
end

end