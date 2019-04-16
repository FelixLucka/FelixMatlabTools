function cc()
%CC is a wrapper for clearing the screen and closing all windows
%
% DESCRIPTION: 
%   cc.m can be used instead of "close all force; drawnow(); clc"
%
% USAGE:
%   cc()
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.10.2018
%       last update     - 08.10.2018
%
% See also ccc, closeAll

close all force
drawnow()
clc

end