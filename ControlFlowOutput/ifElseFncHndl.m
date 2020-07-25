function y = ifElseFncHndl(a, x, f, g)
%IFELSEFNC is wrapper for if(a) y = f(x); else y = g(x); to be used in defining
%anonymous functions
%
% USAGE:
%   F = @(x) ifElseFncHndl(adjFlag, x, Aadj(x), A(x)) 
% 
%
% INPUTS:
%   a - logical 
%   x - function argument
%   f - function handle to be executed if a is true
%   g - function handle to be executed if a is false
%
% OUTPUTS:
%   y - see above
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 23.04.2020
%       last update     - 23.04.2020
%
% See also

if(a)
    y = f(x);
else
    y = g(x);
end

end