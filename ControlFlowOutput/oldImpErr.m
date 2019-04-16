function oldImpErr
% OLDIMPERR throws an error saying that the code passage is outdated
%
% DESCRIPTION:
%   oldImpErr.m can be used to flag code section that need to be updated and
%   prevents them from being executed
%
% USAGE:
%   oldImpErr
%
%  INPUTS:
%
%  OUTPUTS:
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 03.11.2018
%
% See also notImpErr, stopScriptErr

error('ControlFlow:OldImplementation', ...
    'This code passage relies on an outdated version of the code and cannot be used anymore.')

end