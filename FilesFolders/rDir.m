function contents = rDir(path, file_pattern)
%RDIR is a recursive variant of the dir command that enters subdirectories
%
% DETAILS: 
%   rDir.m can be used to list all files that follow a certain pattern in
%   the whole directory tree below a given starting directory
%
% USAGE:
%   the command 
%   contents = rDir(pwd, '*.m') 
%   will list all m files in the current directory and all its
%   subdirectories
%
% INPUTS:
%   path - root directory 
%   file_pattern - see dir.m
%
% OUTPUTS:
%   contents - see dir.m
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.12.2021
%       last update     - 17.12.2021
%
% See also

fs       = filesep;
if(strcmp(path(end), fs))
    path = path(1:end-1);
end

contents    = dir([path fs file_pattern]);

dir_path = dir(path);
for i=1:length(dir_path)
    if(dir_path(i).isdir && ~strcmp(dir_path(i).name, '.') && ~strcmp(dir_path(i).name, '..'))
        contents_sub = rDir([path fs dir_path(i).name], file_pattern);
        contents     = [contents; contents_sub];
    end
end

end