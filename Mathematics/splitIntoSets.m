function split = splitIntoSets(vector, n_split)
%SPLITINTOSETS can be used to split a vector into even sub-sets
%
% DETAILS: 
%   splitIntoSets.m can be used to split a vector into as even as possible
%   sub-sets:
%
% USAGE:
%   splitIntoSets(1:4, 2) returns {[1,2],[3,4]} 
%   splitIntoSets(1:3, 2) returns {[1,2],[3]} 
%
% INPUTS:
%   vector  - the vector to split up
%   n_split - the number of sub-sets
%
% OUTPUTS:
%   split - cell with sub-sets
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 16.05.2023
%
% See also

n                 = length(vector);
bin_length        = floor(n/n_split) * ones(1, n_split);
mis               = n - sum(bin_length);
bin_length(1:mis) = bin_length(1:mis) + 1;
start_ind         = cumsum([1,bin_length]);
split             = cell(1, n_split);

for iSplit=1:n_split
    split{iSplit} = vector(start_ind(iSplit):(start_ind(iSplit+1)-1));
end

end