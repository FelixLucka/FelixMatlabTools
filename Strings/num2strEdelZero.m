function str = num2strEdelZero(a, precision_str)
%NUM2STREDELZERO removes the 0's from the output of num2str(a, precisionStr)
% after the exponential sign: '1.00e-01' --> '1.00e-1'
% 
%  USAGE:
%   out = num2strEdelZero(0.01,'%.2e') produces '1.00e-2' instead of '1.00e-02'
%
%  INPUTS:
%   a            - input numerical value
%   precisionStr - see num2str.m
%
%  OUTPUTS:
%   str - output of num2str with the 0's in the exponential removed.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also int2strLead0

str = num2str(a,precision_str);

if(isinf(a))
    return
end

plus_minus_pos = strfind(str,'+');
if(isempty(plus_minus_pos))
    plus_minus_pos = strfind(str,'-');
    if(isempty(plus_minus_pos) || plus_minus_pos(end) == 1)
        error('invalid precision format')
    else
        plus_minus_pos = plus_minus_pos(end);
    end
end

if(strcmp(str(plus_minus_pos+1),'0'))
   str = [str(1:plus_minus_pos) str(plus_minus_pos+2:end)];
end

end