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
%       last update     - 10.03.2018
%
% See also removeDoubleCharacter, removeDoubleLeadTailCharacter


lengthChar = length(character);

% iterate until nothing changes anymore
while(length(str) >= lengthChar && strcmp(str(1:lengthChar), character))
    if(length(str) > lengthChar)
        str = str(lengthChar+1:end);
    else
        str = '';
    end
end

% iterate until nothing changes anymore
while(length(str) >= lengthChar && strcmp(str(end-lengthChar+1:end), character))
    if(length(str) > lengthChar)
        str = str(1:end-lengthChar);
    else
        str = '';
    end
end

end