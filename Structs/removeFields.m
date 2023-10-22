function struct = removeFields(struct, field_names)
% RMFIELDS extends the native rmfield by not throwing an error if the
% struct does not have a field with the corresponding name
%
% USAGE:
%   struct_new = removeFields(struct_old, {'fieldNameA','fieldNameB'})
%
% INPUT:
%   struct - a struct
%   field_names - a cell of fieldnames as chars
%
% OUTPUTS:
%   struct - the struct with the fields removed.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also extractFields, overwriteFields listDifferentFields, 
%          mergeStructs, compareStructs

if(iscell(field_names))
    for i=1:length(field_names)
        if(isfield(struct,field_names{i}))
            struct = rmfield(struct, field_names{i});
        end
    end
else
    if(isfield(struct,field_names))
        struct = rmfield(struct, field_names);
    end
end

end