function str = num2strEdelZero(a, precisionStr)
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
%       last update     - 05.11.2018
%
% See also int2strLead0

str = num2str(a,precisionStr);

if(isinf(a))
    return
end

plusMinusPos = strfind(str,'+');
if(isempty(plusMinusPos))
    plusMinusPos = strfind(str,'-');
    if(isempty(plusMinusPos) || plusMinusPos(end) == 1)
        error('invalid precision format')
    else
        plusMinusPos = plusMinusPos(end);
    end
end

if(strcmp(str(plusMinusPos+1),'0'))
   str = [str(1:plusMinusPos) str(plusMinusPos+2:end)];
end

end