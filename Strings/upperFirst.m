function str = upperFirst(str)
%UPPERFIRST is a wrapper for [upper(str(1)) str(2:end)]
%
% DESCRIPTION: 
%   upperFirst.m can be used to only capitalize the first char of a 
%   string
%
% USAGE:
%   upperFirst('hello') returns 'Hello'
%   upperFirst('HeLLO') returns 'HeLLO'
%
% INPUTS:
%   str - input string
%
% OUTPUTS:
%   str - output string with first letter capitalized
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also upper, lower

if(isempty(str))
    str = '';
else
    str = [upper(str(1)) str(2:end)];
end

end