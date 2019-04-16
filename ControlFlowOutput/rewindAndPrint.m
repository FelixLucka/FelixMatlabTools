function NcharNew =  rewindAndPrint(str, NcharOld)
%REWINDANDPRINT overwrites old outout in the command window by new one
%
% DESCRIPTION:
%   rewindAndPrint.m can be used to update the printed output by overwriting 
%   it instead of simply printing new output
%
% USAGE:
%   NcharNew =  rewindAndPrint('It is 9pm', 0)
%   NcharNew =  rewindAndPrint('It is 10pm',NcharNew)
%
% INPUT:
%   str        - string to display
%   'NcharOld' - number of places to delete before starting to write
%
% OUTPUTS:
%   NcharNew  - length of the printed string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.11.2018
%       last update     - 03.11.2018
%
% See also dispBlanc

backStr = '';
for j=1:NcharOld
    backStr = [backStr '\x08'];
end

if(~isempty(str))
    NcharNew = fprintf(backStr);
    NcharNew = NcharNew + fprintf(str);
    NcharNew = NcharNew - NcharOld;
    %fprintf('\n')
    %NcharNew = NcharNew +1;
else
    fprintf(backStr)
    NcharNew = 0;
end
drawnow();

end