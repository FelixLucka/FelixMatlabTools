function stopScriptErr
%STOPSCRIPTERR just throws an error and is used to manually stop scripts
%
% USAGE:
%       stopScriptErr
%
% INPUTS:
%
% OUTPUTS:
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.11.2018
%       last update     - 03.11.2018
%
% See also notImpErr, oldImpErr 

error('ControlFlow:StopScript', 'script stopped here')

end