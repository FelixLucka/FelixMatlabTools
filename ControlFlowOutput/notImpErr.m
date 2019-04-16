function notImpErr
%NOTIMPERR can be used to throw an error in code sections where extensions 
% are already structally designed but are not implemented yet
%
% DESCRIPTION:
%       notImpErr can be used to throw an error in code sections where extensions 
%       are already structally designed but are not implemented yet
%
% USAGE:
%       notImpErr
%
% INPUTS:
%
% OUTPUTS:
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.09.2017
%       last update     - 03.09.2017
%
% See also oldImpErr, stopScriptErr

error('ControlFlow:NotImplementedYet', 'Not implemented yet')

end