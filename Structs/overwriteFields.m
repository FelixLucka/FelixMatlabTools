function struct1 = overwriteFields(struct1, struct2, addFields) 
% OVERWRITEFIELDS overwrite all matching fields of struct1 by those of struct2
%
% DESCRIPTION: 
%   functionTemplate.m can be used as to update the fields of one struct by 
%   the fields of another struct 
%
%   setting = overwriteFields(setting, newSettingProperties, true) 
%
%  INPUT:
%   struct1  - the struct whoes fields should be overwritten
%   struct2  - the struct which contains the updated fields
%
% OPTIONAL INPUTS:
%   addFields - a logical indicating whether fields that struct2 has, but
%               struct1 lacks should be attached to struct1;
%
%  OUTPUTS:
%   struct1  - the input field with updated fields
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.04.2018
%       last update     - 10.04.2018
%
% See also extractFields, listDifferentFields, mergeStructs, compareStructs

% check user defined value for addFields, otherwise assign default value
if(nargin < 3)
    addFields = false;
end

% order fields
struct1 = orderfields(struct1);
struct2 = orderfields(struct2);

% get field names
fn1 = fieldnames(struct1);
fn2 = fieldnames(struct2);

% overwrite
for i=1:length(fn2)
    if(isfield(struct1,fn2{i})  || addFields)
        if(isstruct(struct2.(fn2{i})))
            % recursively overwrite subfields
            if(isfield(struct1,fn2{i}))
                struct1.(fn2{i}) = overwriteFields(struct1.(fn2{i}),struct2.(fn2{i}),addFields);
            else
                struct1.(fn2{i}) = struct2.(fn2{i});
            end
        else
            struct1.(fn2{i}) = struct2.(fn2{i});
        end
    end
end

end