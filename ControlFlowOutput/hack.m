function hack
%HACK can be used to throw a warning in code sections where short-term hacks
% are used  
%
% DESCRIPTION:
%       hack can be used to throw a warning in code sections where short-term hacks
%       are used 
%
% USAGE:
%       hack
%
% INPUTS:
%
% OUTPUTS:
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 14.07.2019
%       last update     - 14.07.2019
%
% See also oldImpErr, stopScriptErr, notImpErr

disp('-----------------------------------------------------------')
warning('ControlFlow:Hack', 'Hack')
disp('-----------------------------------------------------------')

end