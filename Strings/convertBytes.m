function memoryStr = convertBytes(bytes)
%CONVERTBYTES converts bytes into a format that is readable by humans
%
% DESCRIPTION:
%       convertBytes takes a memory size in bytes and converts it into a
%       string that is readable by humans
%
% USAGE:
%       memoryStr = convertBytes(1024^3) returns '1024.00 MB'
%
% INPUTS:
%       t               - bytes
%
% OUTPUTS:
%       memoryStr       - a string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 15.03.2017
%       last update     - 03.09.2017
%
% See also convertSec

% string with unit prefix
unit_str = {'PB','TB','GB', 'MB', 'KB', 'B'};

power = 5;
memoryStr = '< 1 B';
while(power > -1)
    if(bytes >= 1024^power)
        memoryStr = num2str(bytes/1024^power,'%1.2f');
        memoryStr = deblank([memoryStr ' ' unit_str{6-power}]);
        break
    else
        power = power-1;
    end
end


end