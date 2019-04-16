function sz = Size(X)
%MYSIZE returns size(X) except for 1D column vectors, where is just returns
%the number of rows
%
% DESCRIPTION: 
%   mySize.m is a modification of size(X)
%
% USAGE:
%   sz = mySize(X)
%
% INPUTS:
%   X - numerical array
%
% OUTPUTS:
%   sz - size of X as array of intergers
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 07.07.2018
%       last update     - 05.11.2018
%
% See also size

sz   = size(X);
% 1D column vectors will reuturn a length of 1
if (length(sz) == 2) && (size(X, 2) == 1)
    sz = sz(1);
end

end