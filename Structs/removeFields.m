function struct = removeFields(struct, fieldNames)
% MYRMFIELD extends the native rmfield by not throwing an error if the
% struct does not have a field with the corresponding name
%
% USAGE:
%   structNew = myRmfield(structOld, {'fieldNameA','fieldNameB'})
%
% INPUT:
%   struct - a struct
%   fieldnames - a cell of fieldnames as chars
%
% OUTPUTS:
%   struct - the struct with the fields removed.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also extractFields, overwriteFields listDifferentFields, 
%          mergeStructs, compareStructs

if(iscell(fieldNames))
    for i=1:length(fieldNames)
        if(isfield(struct,fieldNames{i}))
            struct = rmfield(struct, fieldNames{i});
        end
    end
else
    if(isfield(struct,fieldNames))
        struct = rmfield(struct, fieldNames);
    end
end

end