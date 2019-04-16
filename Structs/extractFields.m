function structNew = extractFields(struct, fieldnames)
% EXTRACTFIELDS extracts a subset of fields from a struct
%
%   structNew = extractFields(struct,{'a','b'})
%
%  INPUT:
%   struct - a struct
%   fieldnames - a cell of fieldnames as chars
%
%  OUTPUTS:
%   structNew - the struct with only the fields specified in fieldnames
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also removeFields, overwriteFields, enforceFields

structNew = emptyStruct;

for i=1:length(fieldnames)
    if(isfield(struct,fieldnames{i}))
        structNew.(fieldnames{i}) = struct.(fieldnames{i});
    end
end


end