function [X, ind] = insertionSort(X)
%INSERTIONSORT is a simple insertion sort implementation
%
% USAGE:
%   [X,ind] = InsertionSort(X) returns the sorted vector X and the indizes
%   of the input vector into the sorted one
%
% INPUTS:
%   X - vector to be sorted
%
% OUTPUTS:
%   X - sorted vector
%   ind - indizes of the unsorted entries into the sorted vector
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also sort

if(~isvector(X))
    error('X must be a vector')
end

ind = 1:length(X);

for i=2:length(X)
   j = i-1; 
   tmp = X(i);
   while(j>=1 && X(j) > tmp)
       X(j+1) = X(j);
       ind(j+1) = ind(j);
       j = j - 1;
   end
   X(j+1) = tmp;
   ind(j+1) = i;
end


end