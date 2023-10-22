function str = removeLeadTailCharacter(str, character)
%REMOVELEADTAILCHARACTER deletes all appearances of a character in at the
% begining or tail of a string
%
% DESCRIPTION:
%       deletes all appearances of a character in at the begining or tail 
%       of a string: str = '__a_b_' will become 'a_b' if given to 
%       removeLeadTailCharacter(str,'_')
%
% USAGE:
%       str = removeDoubleCharacter(str, character)
%
% INPUTS:
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
% See also removeDoubleCharacter, removeDoubleLeadTailCharacter


length_char = length(character);

% iterate until nothing changes anymore
while(length(str) >= length_char && strcmp(str(1:length_char), character))
    if(length(str) > length_char)
        str = str(length_char+1:end);
    else
        str = '';
    end
end

% iterate until nothing changes anymore
while(length(str) >= length_char && strcmp(str(end-length_char+1:end), character))
    if(length(str) > length_char)
        str = str(1:end-length_char);
    else
        str = '';
    end
end

end