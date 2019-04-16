function equalStructs = compareStructs(struc1, name1, struc2, name2, ...
    leaveOutFields, tolNum, output)
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
%   leaveOutFields - a cell containing field names that should not be
%                    included in the comparison
%   tolNum     - a numerical tolerance for comparing numerical values
%   outputFL   - a logical determining whether output should be displayed
%
% OUTPUTS:
%   equalStructs - a logical indicating whether the structs are equal
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also mergeStructs, listDifferentFields

% check for user defined input leaveOutFields, otherwise assign default
if(nargin < 5)
   leaveOutFields = {}; 
end

% check for user defined input tolNum, otherwise assign default
if(nargin < 6)
   tolNum = 0; 
end

% check for user defined input output, otherwise assign default
if(nargin < 7)
   output = false; 
end

equalStructs = true;

% order fields
struc1 = orderfields(struc1);
struc2 = orderfields(struc2);

% get field names
fn1 = setdiff(fieldnames(struc1),leaveOutFields);
fn2 = setdiff(fieldnames(struc2),leaveOutFields);

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
    equalStructs = false;
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
                equalStructs = false;
            elseif(isstruct(curr_field1))
                equalStructs = compareStructs(curr_field1,[name1 '.' fn1{i}],curr_field2,[name2 '.' fn1{i}],leaveOutFields,tolNum,output);
            elseif(isnumeric(curr_field1))
                if(~isequal(size(curr_field1),size(curr_field2)))
                    if(output)
                        disp(['the arrays ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not of equal size'])
                    end
                    equalStructs = false;
                elseif( max(abs(curr_field1(:) - curr_field2(:))) > tolNum)
                    if(output)
                        disp(['the arrays ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not equal within the given numerical tolerance'])
                    end
                    equalStructs = false;
                end
            elseif(isa(curr_field1,'function_handle'))
                % don't compare function handles, it does not work properly
            else
                if(output)
                    disp(['the fields ''' fn1{i} ''' of ' name1 ' and ' name2 ' are not equal'])
                end
                equalStructs = false;
            end
            
        end
    end
end

end