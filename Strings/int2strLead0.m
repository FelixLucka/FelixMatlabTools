function str = int2strLead0(a,digits)
% INT2STRLEAD0 converts an integer to a string but attaches 0s in front to 
% obtain a predefined total number of digits
%
%  USAGE:
%   str = int2strLead0(123,6) would result in str = '000123'
%
%  INPUTS:
%   a        - integer
%   digits   - total number of digits
%
%  OUTPUTS:
%   str - the string 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also num2strEdelZero

str = int2str(a);
for i=1:(digits-length(str))
   str = ['0', str]; 
end

end