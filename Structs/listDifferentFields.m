function listDifferentFields(struct1, name1, struct2, name2)
%LISTDIFFERENTFIELDS lists the field names that two structs don't share
%
% DESCRIPTION: 
%   functionTemplate.m can be used to display the fields that two structs
%   do not have in common
%
% USAGE:
%   listDifferentFields(struct('a', 1, 'b', 2), 'S1', struct('b', 1, 'c', 3), 'S2')
%   will display
%   "S1 has the field 'a' which is not shared by S2"
%   "S2 has the field 'c' which is not shared by S2"
%
% INPUTS:
%   struct1    - the first struct
%   name1      - the name that the first struct should be given when displaying
%                output
%   struct2    - the first struct
%   name2      - the name that the second struct should be given when displaying
%                output
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also compareStructs, enforceFields, mergeStructs

struct1 = orderfields(struct1);
struct2 = orderfields(struct2);
fn1 = fieldnames(struct1);
fn2 = fieldnames(struct2);
if(~isequal(fn1,fn2))
    for i=1:length(fn1)
        is_in = false;
        for j=1:length(fn2)
            is_in = is_in | strcmp(fn1{i}, fn2{j});
        end
        if(~is_in)
            disp([name1 ' has the field ''' fn1{i} ''' which is not shared by ' name2])
        end
    end
    
    for i=1:length(fn2)
        is_in = false;
        for j=1:length(fn1)
            is_in = is_in | strcmp(fn2{i}, fn1{j});
        end
        if(~is_in)
            disp([name2 ' has the field ''' fn2{i} ''' which is not shared by ' name1])
        end
    end
else
    for i=1:length(fn1)
        curr_field1 = getfield(struct1, fn1{i});
        curr_field2 = getfield(struct2, fn1{i});
        if(~isequal(curr_field1,curr_field2))
            if(~isequal(class(curr_field1) , class(curr_field1)))
                disp(['the fields ''' fn1{i} ''' of ' name1 ' and ' name2 have a different class'])
            elseif(isstruct(curr_field1))
                list_different_fields(curr_field1,[name1 '.' fn1{i}],curr_field2,[name2 '.' fn1{i}])
            else
                disp(['the fields ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not equal'])
            end
            
        end
    end
end



end