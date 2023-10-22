function n_char_new =  rewindAndPrint(str, n_char_old)
%REWINDANDPRINT overwrites old outout in the command window by new one
%
% DESCRIPTION:
%   rewindAndPrint.m can be used to update the printed output by overwriting 
%   it instead of simply printing new output
%
% USAGE:
%   n_char_new =  rewindAndPrint('It is 9pm', 0)
%   n_char_new =  rewindAndPrint('It is 10pm', n_char_new)
%
% INPUT:
%   str        - string to display
%   n_char_old - number of places to delete before starting to write
%
% OUTPUTS:
%   n_char_new - length of the printed string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.11.2018
%       last update     - 24.09.2023
%
% See also dispBlanc

back_str = '';
for j=1:n_char_old
    back_str = [back_str '\x08'];
end

if(~isempty(str))
    n_char_new = fprintf(back_str);
    n_char_new = n_char_new + fprintf(str);
    n_char_new = n_char_new - n_char_old;
    %fprintf('\n')
    %NcharNew = NcharNew +1;
else
    fprintf(back_str)
    n_char_new = 0;
end
drawnow();

end