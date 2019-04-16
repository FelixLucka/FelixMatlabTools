function cmdout = sizeOfDir(fullPath)
% SIZEOFDIR returns the size of a folder as by the linux command du -sh *
% (and actually uses this command)
%
%   sizeOfDir(~)
%
%  INPUT:
%   fullPath - full file name
%
%  OUTPUTS:
%   cmdout  - output of the system command used to call du
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also

if(isunix)
    [status, cmdout] = system(['du -sh ' fullPath]);
else
    error('sizeOfDir.m only works on unix systems (linux + mac)')
end

end
