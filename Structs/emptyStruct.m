function emst = emptyStruct
% EMPTYSTRUCT produces a variable of type struct with no fields or data
%
%  emst = emptyStruct
%
%  OUTPUTS:
%   emst - a variable of type struct with no fields or data
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also removeFields, overwriteFields, mergeStructs, extractFields

a.b  = 1;
emst = rmfield(a, 'b');

end