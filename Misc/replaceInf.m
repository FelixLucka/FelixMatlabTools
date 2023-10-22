function x = replaceInf(x, value)
%REPLACEINF is a simple function replacing every inf in an array with a given value
%
% USAGE:
%   x = replaceInf(x, 1)
%
% INPUTS:
%   x - numerical array
%
% OPTIONAL INPUTS:
%   value - numerical value by which to replace inf (default = 1)
%
% OUTPUTS:
%   x - input array with all infs overwritten by value
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.12.2021
%       last update     - 17.12.2021
%
% See also

% check user defined value for value, otherwise assign 1
if(nargin < 2)
    value = 1;
end

x(isinf(x)) = value;

end