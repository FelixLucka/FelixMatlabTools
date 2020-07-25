function str = int2strFixLength(a, b)
% INT2STRLEAD0 converts an integer to a string but attaches blanks in front to 
% obtain the same length as a reference integer
%
%  USAGE:
%   str = int2strFixLength(6, 1000) would result in str = '   6'
%
%  INPUTS:
%   a    - integer
%   b    - integer larger or equal to a that defines length of str
%
%  OUTPUTS:
%   str - the string 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 24.04.2020
%       last update     - 24.04.2020
%
% See also num2strEdelZero

str = int2str(a);
for i=1:(length(int2str(b))-length(str))
   str = [' ', str]; 
end

end