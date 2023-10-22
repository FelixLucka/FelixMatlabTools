function [dir_str, dir_exist] = makeDir(dir_str, output)
% MAKEDIR is a wrapper for mkdir. 
%
%  DESCRIPTION: makeDir tries to make a directory at the given path,
% returns the path and a logical indicating whether the dir already existed 
%
%  USAGE:
%       [dir_path, dir_exist] = makeDir(['photos_' date])
%
%  INPUTS:
%       dir_str         - the path to the dir to create
%       output          - a logical indicating whether output should be
%                         displayed (default = true)
%
%  OUTPUTS:
%       dir_str        - the path to the dir to create (useful if the
%                       function is called with a construction like in the USAGE section
%       dir_exist      - a logical indicating whether the dir already
%                       existed
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 09.03.2018
%       last update     - 26.09.2023
%
% See also sizeOfDir

% check user defined value for output, otherwise assign default value
if(nargin < 2)
    output = true;
end

dir_exist = exist(dir_str, 'dir');

if(not(dir_exist))
    
    if(output)
        disp(['Making directory: ' dir_str])
    end
    
    [status,message,messageid] = mkdir(dir_str);
    
    if(not(status))
        warning(messageid,message)
    end
    
end

end