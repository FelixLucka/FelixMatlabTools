function ll(name)
%LL is wrapper for ls -l -a 
%
% DESCRIPTION: 
%   ll.m is wrapper for ls -l -a
%
% USAGE:
%   ll(path)
%
% OPTIONAL INPUTS:
%   name - name of the directory (if empty, the current directory will be
%          inqueried
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also ls

if nargin < 1
    eval('ls -l -a')
else
    eval(['ls -l -a ' name])
end

end