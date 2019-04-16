function [axisH, figH] = createAxis(para)
% CREATEAXIS creates an axis object.
%
% USAGE
%  axis_handle = createAxis(para)
%  axis_handle = createAxis()
%
%  OPTIONAL INPUTS:
%   para        - a struct that subsums all optional parameters
%       'figureHandle' - a handle to an existing figure
%       'axisTitle'    - title of the axis
%
%  OUTPUTS:
%   axisH - a handle to the axis object	
%   figH  - a handle to the figure the axis are in
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also createFigure, assignOrCreateAxisHandle

% read out the handle of the figure that the axis should be placed in
[figH, df] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);

if(df) % if no handle was given, create new figure
    figH = createFigure(para);
end

% create axis
axisH = axes('Parent',figH, 'DataAspectRatio', [1 1 1]);

% set axis title
[axisTitle, df] = checkSetInput(para, 'axisTitle', 'char', '1');
if(~df)
    set(axisH,'title', axisTitle);
end

end