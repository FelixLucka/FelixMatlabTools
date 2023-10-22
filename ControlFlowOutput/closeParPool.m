function closeParPool(pp, output)
% CLOSEPARPOOL closes a parallel pool safely
%
% DESCRIPTION: 
%       closeParPool.m is a wrapper to close a par pool with or without
%       output
%
% USAGE:
%       closeParPool(pp, true)
%
%  INPUTS:
%   pp       - handle to the pool
%   output   - logical indicating whether output should be displayed.
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.01.2018
%       last update     - 03.01.2018
%
% See also openParPool

if(nargin < 1)
    pp = gcp('nocreate');
end

if(nargin < 2)
    output = false;
end



if(~isempty(pp))
    if(output)
        delete(pp)
    else
        evalc('delete(pp)');
    end
end

end