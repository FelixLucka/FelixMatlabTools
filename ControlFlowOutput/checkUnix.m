function checkUnix(functionName)
%CHECKUNIX can be used to throw an error if the operating system is not
%unix-based
%
% USAGE:
%  checkUnix('testFunction')
%
% INPUTS:
%  functionName - function name calling this function (will be used to
%  in the error message)
%
% OUTPUTS:
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also isunix

if(~isunix)
    error('ControlFlow:NotImplementedYet' ,...
        [functionName '.m only works on unix systems (linux + mac)'])
end

end