function [value, option_set, option_location, value_location] = getOptionValue(options_cell, option_name)
%GETOPTIONVALUE CAN BE USED TO EXTRACT OPTION VALUES IN OPTIONS GIVEN AS
%A CELL
%
% DETAILS: 
%   getOptionValue.m can be used to get the value of a particular option in
%   options given as a cell {'option1', 'value1', 'option2', 'value2',...}
%
% USAGE:
%   value = getOptionValue(options_cell, option_name) 
%
% INPUTS:
%   options_cell - cell of the form {'option1', 'value1', 'option2', 'value2',...}
%   option_name  - the name of the option of which the value is returned (needs to 
%       be in options_cell{1:2:end} to work)
%
% OUTPUTS:
%   value - value of the option queried (empty if options_cell does not contain option_name)
%   option_set - logical indicating whether queried option was specified  
%   option_location - index into options_cell of the option
%   value_location  - index into options_cell of the value
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 24.09.2023
%
% See also setOptionValue

[option_set, option_location] = ismember(option_name, options_cell(1:2:end));

if(option_set)
    option_location = 2 * option_location - 1;
    value_location  = option_location + 1;
    value           = options_cell{value_location};
else
    value           = [];
    option_location = [];
    value_location  = [];
end

end