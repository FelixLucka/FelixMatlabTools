function equal_structs = compareStructs(struc1, name1, struc2, name2, ...
    leave_out_fields, tol_num, output)
% COMPARESTRUCT compares two structs to decide whether they are equal
%
% USAGE:
%  AreXandYequal = compareStructs(X,'struct X',...
%                                 Y,'struct Y',{'name','time'},10^-10,true)
%
% INPUTS:
%   struc1     - the first struct
%   name1      - the name that the first struct should be given when displaying
%                output
%   struc2     - the first struct
%   name2      - the name that the second struct should be given when displaying
%                output
%
% OPTIONAL INPUTS:
%   leave_out_fields - a cell containing field names that should not be
%                    included in the comparison
%   tol_num  - a numerical tolerance for comparing numerical values
%   output   - a logical determining whether output should be displayed
%
% OUTPUTS:
%   equalStructs - a logical indicating whether the structs are equal
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also mergeStructs, listDifferentFields

% check for user defined input leaveOutFields, otherwise assign default
if(nargin < 5)
   leave_out_fields = {}; 
end

% check for user defined input tolNum, otherwise assign default
if(nargin < 6)
   tol_num = 0; 
end

% check for user defined input output, otherwise assign default
if(nargin < 7)
   output = false; 
end

equal_structs = true;

% order fields
struc1 = orderfields(struc1);
struc2 = orderfields(struc2);

% get field names
fn1 = setdiff(fieldnames(struc1),leave_out_fields);
fn2 = setdiff(fieldnames(struc2),leave_out_fields);

% first check whether they have the same field nemaes 
if(~isequal(fn1,fn2))
    for i=1:length(fn1)
        is_in = false;
        for j=1:length(fn2)
            is_in = is_in | strcmp(fn1{i}, fn2{j});
        end
        if(~is_in && output)
            disp([name1 ' has the field ''' fn1{i} ''' which is not shared by ' name2])
        end
    end
    
    for i=1:length(fn2)
        is_in = false;
        for j=1:length(fn1)
            is_in = is_in | strcmp(fn2{i}, fn1{j});
        end
        if(~is_in && output)
            disp([name1 ' has the field ''' fn2{i} ''' which is not shared by ' name2])
        end
    end
    equal_structs = false;
else
    % loop through all the fields and compare them
    for i=1:length(fn1)
        curr_field1 = getfield(struc1, fn1{i});
        curr_field2 = getfield(struc2, fn1{i});
        if(~isequal(curr_field1,curr_field2))
            if(~isequal(class(curr_field1) , class(curr_field1)))
                if(output)
                    disp(['the fields ''' fn1{i} ''' of ' name1 ' and ' name2 have a different class'])
                end
                equal_structs = false;
            elseif(isstruct(curr_field1))
                equal_structs = compareStructs(curr_field1,[name1 '.' fn1{i}],curr_field2,[name2 '.' fn1{i}],leave_out_fields,tol_num,output);
            elseif(isnumeric(curr_field1))
                if(~isequal(size(curr_field1),size(curr_field2)))
                    if(output)
                        disp(['the arrays ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not of equal size'])
                    end
                    equal_structs = false;
                elseif( max(abs(curr_field1(:) - curr_field2(:))) > tol_num)
                    if(output)
                        disp(['the arrays ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not equal within the given numerical tolerance'])
                    end
                    equal_structs = false;
                end
            elseif(isa(curr_field1,'function_handle'))
                % don't compare function handles, it does not work properly
            else
                if(output)
                    disp(['the fields ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not equal'])
                end
                equal_structs = false;
            end
            
        end
    end
end

end