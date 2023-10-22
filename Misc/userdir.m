function user_dir = userDir()
%USERDIR returns the path to the user's home directory
%
% DETAILS: 
%   userDir.m can be used to get the path to the user's home directory 
%
% USAGE:
%   path = userDir
%
% OUTPUTS:
%   path to the 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 16.05.2023
%
% See also

user_dir = char(java.lang.System.getProperty('user.home'));

end