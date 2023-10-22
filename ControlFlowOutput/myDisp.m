function myDisp(str, output_fl, line_break)
%MYDSIP is a simple conveniance wrapper for disp and fprintf
%
% USAGE:
%   myDisp(str) or myDisp(str, true, true) is the same as disp(str)
%   myDisp(str, false) does not display output
%   myDisp(str, true, false) is the same as fprintf(str)
%
% INPUTS:
%   str - string to display
%
% OPTIONAL INPUTS:
%   output_fl - logical indicating whether output should be displayed
%   (default: true)
%   line_break - logical indicating whether the line should be broken after
%   the display (default: true)  
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 23.04.2023
%       last update     - 23.04.2023
%
% See also

% check user defined value for output_fl, otherwise assign default value
if(nargin < 2)
    output_fl = true;
end

% check user defined value for fprintf_fl, otherwise assign default value
if(nargin < 3)
    line_break = true;
end

if(output_fl)
    if(line_break)
        disp(str);
    else
        fprintf(str);
    end
end

end