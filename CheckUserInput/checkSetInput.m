function [paraValue, useDefault, para, msgID, msg] = checkSetInput(para, fieldName, ...
    possibleValues, defaultValue, errorHandling, rmField)
% CHECKSETINPUT checks and/or sets inputs for functions
%
%  DESCRIPTION:
%       Checks if a field value of a struct fulfills certain conditions.
%       Meant to be used to check inputs to a function that are summarized
%       in a struct. If no value is given, it assigns a default_value or
%       promts the user to choose a value.
%       It can also be used to directly check variables.
%
%  USAGE:
%       vector_length  = checkSetInput(para, 'length', '>0', 1)
%       overwrite      = checkSetInput(para,'overwrite','logical',false)
%       color          = checkSetInput(para,'color',{'red','green'},'red')
%       A              = checkSetInput(para,'importantParameterA',[1,2,3], [], 'error')
%       A              = checkSetInput(para,'importantParameterA',[1,2,3], 1, 'promt')
%       A              = checkSetInput(para,'importantParameterA',[1,2,3], 'again', 'promt')
%       A              = checkSetInput(para,'largeParameterA',[1,2,3], 1, [], true)
%
%  ALTERNATIVE USAGE:
%       A = checkSetInput(A, [], 'double', 1)
%
%  INPUTS:
%       para            - a struct
%       fieldName       - the name of a field in para, given as a string.
%                         If it is empty, para is assumed to be the
%                         variable whose values to check
%       possibleValues - determines which values are allowed. If it is a
%                         - cell-array of strings, then para.fieldname has
%                           to match one of them
%                         - numeric array, then para.fieldname has to be
%                           equal to one of them
%                         - one of the strings '>x', '<x', '>=x', '<=x', then
%                           para.fieldname has to fullfill this constraint
%                         - the string 'i', then para.fieldname has to be
%                           an integer
%                         - one of the strings 'i,>x', 'i,<x', 'i,>=x', 'i,<=x', then
%                           para.fieldname has to be an integer and has to
%                           fullfill the constraint
%                         - string containing a class name, then para.fieldname has to belong to that
%                           class
%                         - 'inputFile', then para.fieldname has to be an existing file
%                         - 'inputDir', then para.fieldname has to be an existing directory
%                         - 'mixed' can be anything
%       defaultValue   - default value returned if no field with the
%                        corresponding fieldname exist. Caution: If the
%                        default value would be a valid input is not
%                        checked for!
%       errorHandling  - if 'error' (default) : an error will be thrown if the field
%                        is assigned wrong
%                        'default': the default value is returned
%                        'promt' : the user is promted to enter the value
%                        if the field is not assigned
%
% OPTIONAL INPUTS:
%       rmField - a logical indicating whether the field should be removed
%                 from the para struct
%
%  OUTPUTS:
%       paraValue      - the checked parameter value
%       useDefault     - a logical indicating whether the default value
%                         was assigned
%       para           - the modified para struct (possibly with the field
%                         fieldname removed)
%       'errorID'
%       msg            - additional messages to be displayed by calling
%                        functions
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.02.2017
%       last update     - 07.01.2019
%
% See also chooseSubDir, chooseInput, chooseFile

% check if user defined field
isParaField = isfield(para, fieldName);

% check user defined value for info, otherwise assign default value
if(nargin < 6)
    rmField = false;
end

% check user defined value for errorPromt_Fl, otherwise assign default value
if(nargin < 5 || isempty(errorHandling))
    if(isParaField)
        errorHandling = 'error';
    else
        errorHandling = 'default';
    end
end

% if fieldName is empty, para is the variable itself, not a parameter
% struct
if(isempty(fieldName))
    
    % call checkSetInput recursively
    testPara.test      = para;
    [paraValue, useDefault, ~, msgID, msg] = checkSetInput(testPara, 'test',...
        possibleValues, defaultValue, 'error');
    return
    
end

msgID = '';
msg   = '';
assign = false;

if(isParaField)
    
    %%% main loop, check all possible input classes
    switch class(possibleValues)
        
        case 'cell'
            
            % choose one of many possible inputs
            if(not(iscellstr(possibleValues)))
                
                msg   = 'Invalid specification of possible values: It is a cell, but not cell array of strings';
                % check if input matches any possible values
            elseif(any(strcmp(para.(fieldName), possibleValues)))
                % assign chosen value
                assign = true;
            else
                % throw error
                possibleValuesStr = '''';
                for i=1:(length(possibleValues)-1)
                    possibleValuesStr = [possibleValuesStr, possibleValues{i}, ''', '''];
                end
                possibleValuesStr = [possibleValuesStr, possibleValues{end} ''''];
                msg   = ['Invalid value for para.' fieldName ...
                    ', choose one of the following: ' possibleValuesStr];
            end
            
        case 'double'
            
            % input must be one of the doubles specified
            if(any(possibleValues == para.(fieldName)))
                assign = true;
            else
                msg   = ['Invalid value for para.' fieldName ...
                    ', choose one of the following: ' num2str(possibleValues)];
            end
            
        case 'char'
            
            % input must match the possible strings
            if(strcmp(possibleValues,'inputFile'))
                
                % para.fieldname should be a file name
                if(exist(para.(fieldName), 'file'))
                    assign = true;
                else
                    msg = ['para.' fieldName ' is not an existing file name'];
                end
                
            elseif(strcmp(possibleValues,'inputDir'))
                
                % para.fieldname should be a directory name
                if(exist(para.(fieldName), 'dir'))
                    assign = true;
                else
                    msg = ['para.' fieldName ' is not an existing directory name'];
                end
                
            elseif(strcmp(possibleValues,'mixed'))
                
                % check nothing, just assign
                assign = true;
                
            elseif(strcmp(possibleValues,'i'))
                
                % para.fieldnameshould be an integer
                if(mod(para.(fieldName), 1) == 0)
                    assign = true;
                else
                    msg = ['Invalid value for para.' fieldName ', should be an integer!'];
                end
                
            elseif(strcmp(possibleValues,'numeric'))
                
                % para.fieldnameshould be any numeric type
                if(isnumeric(para.(fieldName)))
                    assign = true;
                else
                    msg = ['Invalid value for para.' fieldName ', should be a numeric!'];
                end
                
            else
                
                % para.fieldnameshould has to fulfill an inequality
                greatSmall      = strcmp(possibleValues(1), {'>', '<'});
                greatSmallEqual = strcmp(possibleValues(1:2), {'>=', '<='});
                if(length(possibleValues) > 3)
                    intGreatSmall      = strcmp(possibleValues(1:3), {'i,>', 'i,<'});
                    intGreatSmallEqual = strcmp(possibleValues(1:4), {'i,>=', 'i,<='});
                end
                
                if(any([greatSmall greatSmallEqual])) % upperbound/lowerbound constraint
                    
                    %para.fieldname has to be a numeric
                    if(not(isnumeric(para.(fieldName))))
                        msg = ['possibleValues contains a contraint string, but para.' fieldName ' is not a numeric'];
                    end
                    
                    if(any(greatSmallEqual)) % >= or <=
                        bound = str2num(possibleValues(3:end));
                        eval(['conFulfilled =  para.' fieldName possibleValues(1:2) ' bound;']);
                    else % > or <
                        bound = str2num(possibleValues(2:end));
                        eval(['conFulfilled =  para.' fieldName possibleValues(1) ' bound;']);
                    end
                    
                    if(conFulfilled)
                        assign = true;
                    else
                        msg = ['Invalid value for para.' fieldName ', it has to fulfill ' possibleValues];
                    end
                    
                elseif(any([intGreatSmall intGreatSmallEqual]))
                    
                    % upperbound/lowerbound constraint
                    
                    %para.fieldname has to be a numeric
                    if(not(isnumeric(para.(fieldName))))
                        msg = ['para.' fieldName ' is not a numeric'];
                    elseif((anyAll(mod(para.(fieldName), 1))) && not(isinf(para.(fieldName))))
                        msg = ['para.' fieldName ' is not an integer'];
                    end
                    
                    if(any(intGreatSmallEqual)) % i,>= or i,<=
                        bound = str2num(possibleValues(5:end));
                        eval(['conFulfilled =  para.' fieldName possibleValues(3:4) ' bound;']);
                    else % i,> ori,<
                        bound = str2num(possibleValues(4:end));
                        eval(['conFulfilled =  para.' fieldName possibleValues(3) ' bound;']);
                    end
                    
                    if(conFulfilled)
                        assign = true;
                    else
                        msg = ['Invalid value for para.' fieldName ', it has to fulfill ' possibleValues];
                    end
                else
                    
                    % class constraint
                    eval(['correctClass =  isa(para.' fieldName ',''' possibleValues ''');']);
                    if(correctClass)
                        assign = true;
                    else
                        msg = ['Invalid class for para.' fieldName ', it should be of class ' ...
                            possibleValues ' but is of class ' class(para.(fieldName))];
                    end
                    
                end
                
            end
            
        otherwise
            
            msg = 'Invalid specification of possible values';
            
    end
    msgID = 'AssignError';
    
    
    if(assign)
        
        % assign value
        paraValue = para.(fieldName);
        useDefault = false;
        
    else
        
        msgID = 'FMT:AssignError';
        switch errorHandling
            case {'error', 'promt'}
                error(msgID, msg)
            case 'default'
                % assign value anyways
                paraValue = para.(fieldName);
                useDefault = true;
        end
    end
    
    
else % if(isfield(para, fieldName))
    
    
    switch errorHandling
        case 'error'
            
            % throw error
            msgID = 'FMT:AssignError';
            msg   = ['parametervalue ' fieldName ' has to be set!'];
            error(msgID, msg)
            
        case 'promt'
            
            % promt user to give input
            command = ['Set value for parameter ''' fieldName];
            if(isnumeric(possibleValues))
                paraValue = chooseInput(command, 'numerical', possibleValues, defaultValue);
            else
                switch class(possibleValues)
                    case 'char'
                        switch possibleValues
                            case 'logical'
                                paraValue = chooseInput(command, 'logical', [], defaultValue);
                            otherwise
                                paraValue = chooseInput(command, 'numerical', possibleValues, defaultValue);
                        end
                    otherwise
                        paraValue = chooseInput(command, 'string', possibleValues, defaultValue);
                end
            end
        otherwise
            
            % default initialization
            paraValue = defaultValue;
            
    end
    
    useDefault = true;
    
end % if(isfield(para, fieldName))


if(rmField)
    
    % remove field to save memory
    para = removeFields(para, fieldName);
    
end

end