function choice = chooseInput(command, type, possibleValues, defaultValue)
% CHOOSEINPUT promts the user to make a choice
%
%  DESCRIPTION:
%       
%
%  USAGE:
%       truth  = chooseInput('Is this funny?', 'logical', [], false)
%       time   = chooseInput('Choose the duration in second!', 'numerical', '>0', 'again')
%       a      = chooseInput('Choose a 3x1 vector with arbitrary entries!', 'numerical', 'double', randn(3,1))
%       i      = chooseInput('Choose an integer between 1 and 10!','numerical', 1:10, 'error')
%       season = chooseInput('What is your favorite season of the year?', 'string', ...
%                                           {'spring','sommer','fall','winter'}, 'again')
%
%  INPUTS:
%       command         - a command displayed to the user
%       type            - type of input expected: 'logical', 'numerical' or 'string' 
%       possibleValues  - a cell with possible values for input, ignored
%                         for type = 'logical'
%       default         - default string returned if enter is hit. Caution: If the
%                         default value would be a valid input is not
%                         checked for! Can also be 'error' or 'again'
%                         for 'error', an error is thrown if an invalid input is given
%                         for 'again', the question is repeated until a valid
%                         input is encountered
%
%  OUTPUTS:
%       choice          - the chosen boolean/numerical/string
%       
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 13.12.2017
%       last update     - 13.12.2017
%
% See also chooseFile, chooseSubDir, checkSetInput

% check value for type
type = checkSetInput(type, [], {'logical', 'numerical', 'string'}, 'error');



while(1)
    
    switch type
        case 'logical'
            df_str = defaultValue;
            if(~strcmp(defaultValue, 'error') && ~strcmp(defaultValue, 'again'))
                if(defaultValue)
                    df_str = 'y';
                else
                    df_str = 'n';
                end
            end
            choiceStr = input([command ' (input: ''y'' or ''n'', default: ' df_str ') : '], 's');
        case 'numerical'
            if(isnumeric(defaultValue))
                if(isscalar(defaultValue))
                    choiceStr = input([command ' (default: ' num2str(defaultValue) ') : '], 's');
                else
                    disp([command ' (default: '])
                    disp(num2str(defaultValue))
                    choiceStr = input(') : ', 's');
                end
            else
                choiceStr = input([command ' (default: ' num2str(defaultValue) ') : '], 's');
            end
        case 'string'
            choiceStr = input([command ' (default: ' defaultValue ') : '], 's');
    end
    
    if(isempty(choiceStr))
        
        if(ischar(defaultValue) && strcmp(defaultValue, 'error'))
            error('this value has to be set manually')
        elseif(ischar(defaultValue) && strcmp(defaultValue,'again'))
            % go back to start
        else
            choice = defaultValue;
            break
        end
        
    else
        
        switch type
            case 'logical'
                if(strcmp(choiceStr,'yes')||strcmp(choiceStr,'y'))
                    choice = true;
                    break
                elseif(strcmp(choiceStr,'no')||strcmp(choiceStr,'n'))
                    choice = false;
                    break
                end
                disp('invalid input')
            case 'numerical'
                choice = str2num(choiceStr);
                % check
                [choice, df, ~, msgID, msg] = checkSetInput(choice, [], possibleValues, [], 'default');
                if(df)
                    if(ischar(defaultValue) && strcmp(defaultValue, 'error'))
                        error(msgID, msg)
                    elseif(ischar(defaultValue) && strcmp(defaultValue,'again'))
                        disp(msg)
                    else
                        choice = defaultValue;
                        break
                    end
                else
                    break
                end
            case 'string'
                if(any(strcmp(choiceStr, possibleValues)))
                    choice = choiceStr;
                    break
                else
                    invalidStr = 'Invalid choice, allowed inputs:';
                    for i=1:length(possibleValues)
                        invalidStr = strcat(invalidStr, [' ''' char(possibleValues{i}) '''']);
                    end
                    disp(invalidStr)
                end
                
        end
        
    end
    
end


    


