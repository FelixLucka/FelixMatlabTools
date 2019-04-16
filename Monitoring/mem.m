function str = mem(varargin)
% MEM prints how much memory all variables given take up
%
%  USAGE:
%       mem(randn(1024,1024)) will return '8.00 MB'
%
%  INPUTS:
%       varargin        - a list of variables
%
%  OUTPUTS:
%       str             - the memory that these variables take as a human
%                         readable string
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also memCheck, convertBytes

info = whos('varargin');
str  = convertBytes(info.bytes);

end