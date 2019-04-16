function TF = anyAll(x)
%ANYALL is a wrapper for any(x(:))
%
% DESCRIPTION: 
%   anyAll.m returns true if any entry of x is true
%
% USAGE:
%   TF = anyAll(x)
%
% INPUTS:
%   x - bla bla
%
% OUTPUTS:
%   TF - a logical indicating whether any entry of x was true
%        was assigned 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.10.2018
%       last update     - 08.10.2018
%
% See also maxAll, minAll, sumAll

TF = any(x(:));

end