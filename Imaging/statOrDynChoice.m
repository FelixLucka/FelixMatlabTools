function A = statOrDynChoice(object, cellIndex)
% STATORDYNCHOICE directly returns the input unless the input is a cell array, in
% which case it returns a the content of a specific cell 
%
%  INPUTS:
%   object    - input
%   cellIndex - index of the cell that should be returned in the case that
%               object is a cell array.
%
%  OUTPUTS:
%   A  - desired object
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also

if(iscell(object))
    A = object{cellIndex}; 
else
    A = object;
end

end