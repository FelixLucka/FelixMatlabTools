function checkNaNInf(x)
%CHECKNANINF throws an error if it encounters any NaNs or inf values
%
% DETAILS:
%   checkNaNInf.m throws an error if it encounters any NaNs or inf values
%
% USAGE:
%   checkNaNInf([])
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
%       last update     - 16.05.2023
%
% See also

if(any(isnan(x(:))))
    error('CheckVariables:NaNEncountered', 'encountered NaN value in variable')
end

if(any(isinf(x(:))))
    error('CheckVariables:InfEncountered', 'encountered Inf value in variable')
end


end