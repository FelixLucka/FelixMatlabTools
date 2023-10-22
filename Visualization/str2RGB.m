function RGB = str2RGB(str)
% STR2RGB retruns the RGB code for a given color name
%
%  USAGE:
%   rgb = str2RGB('red')
%
%  INPUTS:
%   str    - color name
%
%  OUTPUTS:
%   RGB    - vector of length 3 with values between 0 and 1 representing
%            an RGB code
%
%  ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 14.10.2023
%
% See also getColorMap

switch lower(str)
    case 'red'
        RGB = [1,0,0];
    case 'blue'
        RGB = [0 0 1];
    case 'green'
        RGB = [0,1,0];
    case {'cyan', 'aqua', 'turquoise'}
        RGB = [0,1,1];
    case {'pink', 'magenta'}
        RGB = [1,0,1];
    case 'yellow'
        RGB = [1,1,0];
    case 'white'
        RGB = [1 1 1];
    case 'black'
        RGB = [0 0 0];
    otherwise
        error('unknown color string')
end


end