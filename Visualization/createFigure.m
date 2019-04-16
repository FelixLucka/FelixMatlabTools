function [figH, show] = createFigure(para)
% CREATEFIGURE creates a new figure object.
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%  axis_handle = createAxis(para)
%  axis_handle = createAxis()
%
%  INPUTS:
%   para        - a struct that subsums all optional parameters
%       'showFL'        -  a logical indicating whether the figure is visible
%       'dockedFL'      -  a logical indicating whether the figure is
%                          docked
%       'fullscreenFL'  -  a logical indicating whether the figure is full
%                          screen
%
%  OUTPUTS:
%   figH        - a handle to the figure created
%   showFL      - a logical indicating whether the figure is visible
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also createAxis, assignOrCreateFigureHandle


show          = checkSetInput(para, 'show', 'logical', true);
docked        = checkSetInput(para, 'docked', 'logical', false);
fullScreen    = checkSetInput(para, 'fullScreen', 'logical', false);

if(show)
    if(fullScreen)
        fullScreen = get(0, 'ScreenSize');
        figH = figure('Position', [0 -50 fullScreen(3) fullScreen(4)], 'PaperSize', [40 60]);
    else
        figH = figure();
    end
else
    if(fullScreen)
        figH = figure('Position', [0 -50 1680 1050], 'PaperSize', [40 60], 'Visible', 'off');
    else
        figH = figure('Visible', 'off');
    end
end

if(docked)
    set(figH, 'WindowStyle', 'docked')
end


end