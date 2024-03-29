function rep_length = repetitionLenght(sequence)
%REPETIONLENGTH figures out if an input sequence is the repetiton of a 
% smaller sub-sequence and returns the length of this sequence
%
% USAGE:
%   repetitionLenght('ab')   returns 2
%   repetitionLenght('abab') returns 2
%   repetitionLenght('aba')  returns 3
%
% INPUT:
%   sequence   - a vector
%
% OUTPUTS:
%    repLength - the length of the sub-sequence that generates the input
%    sequence.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also

sequence = sequence(:);

for i=1:length(sequence)
   if(mod(length(sequence)/i,1) == 0)
        rep_initial_sequence = repmat(sequence(1:i),[length(sequence)/i,1]);
        if(isequal(rep_initial_sequence,sequence))
            rep_length = i;
            break
        end
   end
end

end