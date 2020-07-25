function checkNaNInf(x)
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
%       date            - 04.12.2019
%       last update     - 04.12.2019
%
% See also

if(any(isnan(x(:))))
    error('CheckVariables:NaNEncountered', 'encountered NaN value in variable')
end

if(any(isinf(x(:))))
    error('CheckVariables:InfEncountered', 'encountered Inf value in variable')
end


end