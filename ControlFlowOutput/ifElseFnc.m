function x = ifElseFnc(a, b, c)
%IFELSEFNC is wrapper for if(a) x = b; else x = c; to be used in defining
%anonymous functions
%
% USAGE:
%   F = @(x) ifElseFnc(x >= 0, x.^2, x.^3) 
% 
%
% INPUTS:
%   a - logical 
%   b - return value in case a is true
%   c - return value in case a is false
%
% OUTPUTS:
%   x - see above
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 23.04.2020
%       last update     - 23.04.2020
%
% See also

if(a)
    x = b;
else
    x = c;
end

end