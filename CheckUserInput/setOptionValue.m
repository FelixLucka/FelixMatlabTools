function [options_cell, was_added] = setOptionValue(options_cell, option_name, value)
%SETOPTIONSVALUE SETS OR ADDS AN OPTION IN AN OPTIONS CELL
%
% DETAILS: 
%   setOptionValue.m can be used to set the value of a particular option in
%   options given as a cell {'option1', 'value1', 'option2', 'value2',...}
%   If the option is not present yet, it will be added. 
%
% USAGE:
%   options_cell = setOptionValue(options_cell, option_name, value)
%
% INPUTS:
%   options_cell - cell of the form {'option1', 'value1', 'option2', 'value2',...}
%   option_name  - the name of the option of which the value should be set (needs to 
%       be in options_cell{1:2:end} to set it, otherwise it will be added
%       as a new option to the end of the options cell
%
% OUTPUTS:
%   options_cell - options_cell with the value set or added
%   was_added - logical indicating whether the option was set (was_added = false) 
%   or added (was_added = true)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 24.09.2023
%
% See also getOptionValue

[option_set, option_location] = ismember(option_name, options_cell(1:2:end));

if(option_set)
    option_location              = 2 * option_location - 1;
    value_location               = option_location + 1;
    options_cell{value_location} = value;
    was_added = false;
else
    options_cell{end+1} = option_name;
    options_cell{end+1} = value;
    was_added           = true;
end

end