function struct1 = overwriteFields(struct1, struct2, add_fields) 
% OVERWRITEFIELDS overwrite all matching fields of struct1 by those of struct2
%
% DESCRIPTION: 
%   overwriteFields.m can be used as to update the fields of one struct by 
%   the fields of another struct 
%
%   setting = overwriteFields(setting, new_setting_properties, true) 
%
%  INPUT:
%   struct1  - the struct whoes fields should be overwritten
%   struct2  - the struct which contains the updated fields
%
% OPTIONAL INPUTS:
%   add_fields - a logical indicating whether fields that struct2 has, but
%               struct1 lacks should be attached to struct1;
%
%  OUTPUTS:
%   struct1  - the input field with updated fields
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.04.2018
%       last update     - 16.05.2023
%
% See also extractFields, listDifferentFields, mergeStructs, compareStructs

% check user defined value for addFields, otherwise assign default value
if(nargin < 3)
    add_fields = false;
end

% order fields
struct1 = orderfields(struct1);
struct2 = orderfields(struct2);

% get field names
fn2 = fieldnames(struct2);

% overwrite
for i=1:length(fn2)
    if(isfield(struct1,fn2{i})  || add_fields)
        if(isstruct(struct2.(fn2{i})))
            % recursively overwrite subfields
            if(isfield(struct1,fn2{i}))
                struct1.(fn2{i}) = overwriteFields(struct1.(fn2{i}),struct2.(fn2{i}),add_fields);
            else
                struct1.(fn2{i}) = struct2.(fn2{i});
            end
        else
            struct1.(fn2{i}) = struct2.(fn2{i});
        end
    end
end

end