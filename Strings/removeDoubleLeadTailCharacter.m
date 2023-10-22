function str = removeDoubleLeadTailCharacter(str,character)
% REMOVEDOUBLELEADTAILCHARACTER removes all instances of the same character in a
% row and deletes it from begining and end
%
%  DESCRIPTION:
%       removes all instances of the same character in a
%       row and deletes it from begining and end:
%       str = '__a_c___b_' will become 'a_c_b' if given to 
%       removeDoubleLeadTailCharacter(str,'_')
%
%  USAGE:
%       str = removeDoubleLeadTailCharacter(str, character)
%
%  INPUTS:
%       str       - input string
%       character - the character to remove
%
% OUTPUTS:
%       str - output string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.03.2018
%       last update     - 16.05.2023
%
% See also removeDoubleCharacter, removeLeadTailCharacter

str = removeDoubleCharacter(str,   character);
str = removeLeadTailCharacter(str, character);

end