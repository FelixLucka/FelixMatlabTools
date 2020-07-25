function x = linSpace(a, b, n, mode)
%FUNCTIONTEMPLATE is a template for a function describtion
%
% DETAILS:
%   functionTemplate.m can be used as a template
%
% USAGE:
%   x = functionTemplate(y)
%
% INPUTS:
%   y - bla bla
%
% OPTIONAL INPUTS:
%   z    - bla bla
%   para - a struct containing further optional parameters:
%       'a' - parameter a
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2019
%       last update     - 19.12.2019
%
% See also

% check user defined value for z, otherwise assign default value
if(nargin < 4)
    mode = 'incAB';
end

switch mode
    case 'incAB'
        x = linspace(a, b, n);
    case 'excA'
        x = linspace(a, b, n+1);
        x = x(2:end);
    case 'excB'
        x = linspace(a, b, n+1);
        x = x(1:end-1);
    case 'excAB'
        x = linspace(a, b, n+2);
        x = x(2:end-1);
end

end