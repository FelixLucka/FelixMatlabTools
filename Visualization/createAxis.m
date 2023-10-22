function [axis_h, fig_h] = createAxis(para)
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
%   axis_h - a handle to the axis object	
%   fig_h  - a handle to the figure the axis are in
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.10.2023
%
% See also createFigure, assignOrCreateAxisHandle

% read out the handle of the figure that the axis should be placed in
[fig_h, df] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);

if(df) % if no handle was given, create new figure
    fig_h = createFigure(para);
end

% create axis
axis_h = axes('Parent',fig_h, 'DataAspectRatio', [1 1 1]);

% set axis title
[axis_title, df] = checkSetInput(para, 'axisTitle', 'char', '1');
if(~df)
    set(axis_h,'title', axis_title);
end

end