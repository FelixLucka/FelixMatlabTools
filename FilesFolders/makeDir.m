function [dirStr, dirExist] = makeDir(dirStr, output)
% MAKEDIR is a wrapper for mkdir. 
%
%  DESCRIPTION: makeDir tries to make a directory at the given path,
% returns the path and a logical indicating whether the dir already existed 
%
%  USAGE:
%       [dirPath, dirExistFL] = makeDir(['photos_' date])
%
%  INPUTS:
%       dirStr          - the path to the dir to create
%       output          - a logical indicating whether output should be
%                         displayed (default = true)
%
%  OUTPUTS:
%       dirStr        - the path to the dir to create (useful if the
%                       function is called with a construction like in the USAGE section
%       dirExist      - a logical indicating whether the dir already
%                       existed
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 09.03.2018
%       last update     - 09.03.2018
%
% See also sizeOfDir

% check user defined value for output, otherwise assign default value
if(nargin < 2)
    output = true;
end

dirExist = exist(dirStr, 'dir');

if(not(dirExist))
    
    if(output)
        disp(['Making directory: ' dirStr])
    end
    
    [status,message,messageid] = mkdir(dirStr);
    
    if(not(status))
        warning(messageid,message)
    end
    
end

end