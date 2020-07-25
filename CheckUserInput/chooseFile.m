function choice = chooseFile(parentFolder, pattern)
%CHOOSEFILE promts the user to choose a file in a directory according to a pattern 
%
% USAGE:
%   choice = chooseFile(pwd, 'scan*.tif') to promt the user to choose a tif
%   file in the current directory with the filename pattern scan*.tif
%
% INPUTS:
%   parentFolder - folder in which to search
%   pattern      - filename pattern including wildcards 
%
% OUTPUTS:
%   choice - the choosen filename 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also chooseSubDir, chooseInput, checkSetInput

listing = dir([parentFolder filesep pattern]);
allowedFiles = cell(length(listing), 1);
dates        = zeros(length(listing), 1);

for i=1:length(listing)
    allowedFiles{i} = listing(i).name;
    dates(i)        = datenum(listing(i).date);
end

if(~isempty(allowedFiles))
    disp('Choose one of the following files (type ''none'' for none of them):')
    disp(allowedFiles)
    % the file created last is shown as default choice
    [~, dfInd] = max(dates);
    allowedFiles{end+1} = 'none';
    choice = chooseInput('Your choice : ', 'string', allowedFiles, ...
    allowedFiles{dfInd});
else
    warning(['No files with matching ' pattern ...
        ' in the corrensponding folder! The function will return ''none''.'])
    choice = 'none';
end

end