function c = multipleCross(a,b)
%MUTIPLECROSS COMPUTES THE CROSS PRODUCT BETWEEN TWO ARRAYS OF 3D VECTORS
%
% DETAILS: 
%   multipleCross.m can be used to compute c(i,:) = a(i,:) x b(i,:) for all 
%   rows in a and b at the same time
%
% USAGE:
%   c = multipleCross(a,b)
%
% INPUTS:
%   a - n x 3 array
%   b - n x 3 array
%
% OUTPUTS:
%   c - n x 3 array of cross products 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 29.09.2023
%
% See also

c =  [a(:,2) .* b(:,3) - a(:,3) .* b(:,2),...
      a(:,3) .* b(:,1) - a(:,1) .* b(:,3),...
      a(:,1) .* b(:,2) - a(:,2) .* b(:,1)];

end