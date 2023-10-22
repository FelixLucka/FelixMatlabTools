function struct_new = extractFields(struct, field_names)
% EXTRACTFIELDS extracts a subset of fields from a struct
%
%   structNew = extractFields(struct,{'a','b'})
%
%  INPUT:
%   struct - a struct
%   field_names - a cell of fieldnames as chars
%
%  OUTPUTS:
%   structNew - the struct with only the fields specified in fieldnames
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also removeFields, overwriteFields, enforceFields

struct_new = emptyStruct;

for i=1:length(field_names)
    if(isfield(struct,field_names{i}))
        struct_new.(field_names{i}) = struct.(field_names{i});
    end
end


end