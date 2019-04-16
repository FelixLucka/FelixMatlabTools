function s = mergeStructs(struct1, struct2)
%MERGESTRUCTS merges two structs that have no field names in common
%
% USAGE:
%   mergeStructs(struct('a', 1, 'b', 2), struct('c', 3, 'd', 4))
%   will produce struct('a', 1, 'b', 2, 'c', 3, 'd', 4)
%
% INPUTS:
%   struct1    - the first struct
%   struct2    - the first struct
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also overwriteFields, listDifferentFields, compareStructs

fn1 = fieldnames(struct1);
fn2 = fieldnames(struct2);

% a conflict occurs, when some fieldnames appear in both structs
if(length(fn1) + length(fn2) > length(unique([fn1;fn2])))
   error('some field names appear in both strucs that should be merged') 
end

% merge structs
s = struct1;
for i=1:length(fn2)
   s.(fn2{i}) = struct2.(fn2{i}); 
end

end