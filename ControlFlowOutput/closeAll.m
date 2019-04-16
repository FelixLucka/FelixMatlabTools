function closeAll()
% closeAll is a wrapper for 'close all force' followed by 'drawnow', forcing the
% immediate  execution
%
% USAGE:
%   myCloseAll()
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also ccc, cc

close all force
drawnow

end