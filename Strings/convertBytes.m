function memory_str = convertBytes(bytes)
%CONVERTBYTES converts bytes into a format that is readable by humans
%
% DESCRIPTION:
%       convertBytes takes a memory size in bytes and converts it into a
%       string that is readable by humans
%
% USAGE:
%       memory_str = convertBytes(1024^3) returns '1024.00 MB'
%
% INPUTS:
%       t               - bytes
%
% OUTPUTS:
%       memory_str       - a string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 15.03.2017
%       last update     - 16.05.2023
%
% See also convertSec

% string with unit prefix
unit_str = {'PB','TB','GB', 'MB', 'KB', 'B'};

power = 5;
memory_str = '< 1 B';
while(power > -1)
    if(bytes >= 1024^power)
        memory_str = num2str(bytes/1024^power,'%1.2f');
        memory_str = deblank([memory_str ' ' unit_str{6-power}]);
        break
    else
        power = power-1;
    end
end


end