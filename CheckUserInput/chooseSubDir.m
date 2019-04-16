function [choice, pathDir, flag] = chooseSubDir(parentDir)
%CHOOSESUBDIR can be used to promt the user to choose a sub directory of a
%given directory
%
% USAGE:
%   [choice, pathDir, bool] = chooseSubDir(pwd) promts the user to choose
%   one of the folders in the current directory, the choice can include 
%   '.' and '..'
%
% INPUTS:
%   parentDir - the directory in which to choose a sub directory
%
% OUTPUTS:
%   choice  - the name of the sub directory
%   pathDir - the full path of the chosen directory
%   flag    - a flag taking the value 0 if '.' is chosen, -1 if '..' is
%             chosen and '1' if a regular folder is chosen
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also chooseFile, chooseInput, checkSetInput

% list all sub directories
listing = dir(parentDir);

allowedFolders = {'.','..'};
dates = [];
isDirInd = 2;
for i=1:length(listing)
    if(listing(i).isdir && not(strcmp(listing(i).name(1),'.')))
        isDirInd = isDirInd + 1;
        allowedFolders{isDirInd} = listing(i).name;
        dates(isDirInd-2) = datenum(listing(i).date);
    end
end

if(length(allowedFolders) > 2)
    
    % choose on of the sub directories 
    disp('Choose one of the following sub directories (''.'' for staying here, ''..'' for returning to parent dir) ')
    disp(allowedFolders)
    
    [~,dfInd] = max(dates);
    dfInd     = dfInd + 2;
    choice    = chooseInput('Your choice : ', 'string', allowedFolders, allowedFolders{dfInd});

    switch choice
        case '.'
            flag       = 0;
            pathDir    = parentDir;
            filesepPos = strfind(parentDir, filesep);
            choice     = parentDir(max(filesepPos)+1:end);
        case '..'
            flag       = -1;
            filesepPos = strfind(parentDir, filesep);
            pathDir    = parentDir(1:max(filesepPos)-1);
            choice     = parentDir(filesepPos(end-1)+1:filesepPos(end)-1);
        otherwise
            flag       = 1;
            pathDir    = [parentDir '/' choice];
    end
    
else
    
    % stay here or move to parent folder
    stayOrGo = chooseInput('Stay here (y) or return to parent folder (n) ', ...
        'logical', [], true);
    if(stayOrGo)
        flag        = 0;
        pathDir     = parentDir;
        filesepPos  = strfind(parentDir, filesep);
        choice      = parentDir(max(filesepPos)+1:end);
    else
        flag        = -1;
        filesepPos  = strfind(parentDir, filesep);
        pathDir     = parentDir(1:max(filesepPos)-1);
        choice      = parentDir(filesepPos(end-1)+1:filesepPos(end)-1);
    end
    
end

end