function deleteAllFilesInSubfolders(folder, pattern)
% DELETEALLFILESINSUBFOLDERS deletes all files in a given folder and its
% subfolders with a specific pattern
%
%  DESCRIPTION: 
%   deleteAllFilesInSubfolders.m deletes all files in a given folder and 
%   subfolders that satisfy a specific search pattern. It works with the
%   system command and as such, only works on unix plattforms
%
%  deleteAllFilesInSubfolders('~/data/', '*.png')
%
%  INPUTS:
%   folder      - path to the folder
%   pattern     - a search pattern to identify the files
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also

if(isunix)
    system(['find ' folder ' -type f -name ' pattern ' -delete'])
else
    error('deleteAllFilesInSubfolders.m only works on unix systems (linux + mac)')
end

end