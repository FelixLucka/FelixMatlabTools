function str = removeDoubleCharacter(str,character)
% REMOVEDOUBLECHARACTER deletes all appearances of the same character in a
% row
%
%  DESCRIPTION:
%       checks strings for the appearance of the same character in a row
%       and removes them: str = 'a_____b' will become 'a_b' if given
%       to removeDoubleCharacter(str,'_')
%
%  USAGE:
%       str = removeDoubleCharacter(str,character)
%
%  INPUTS:
%       str       - input string
%       character - the character to replace
%
% OUTPUTS:
%       str - output string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.03.2018
%       last update     - 10.03.2018
%
% See also removeLeadTailCharacter, removeDoubleLeadTailCharacter

% make a template consisting of two appearances of the character in a row
template = [character character];

% iterate until nothing changes anymore
while(not(strcmp(str,strrep(str,template,character))))
    str = strrep(str,template,character);
end

end