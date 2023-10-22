function [fig_h, show] = createFigure(para)
% CREATEFIGURE creates a new figure object.
%
% USAGE:
%  axis_handle = createAxis(para)
%  axis_handle = createAxis()
%
%  INPUTS:
%   para        - a struct that subsums all optional parameters
%       'show'        -  a logical indicating whether the figure is visible
%       'docked'      -  a logical indicating whether the figure is
%                          docked
%       'fullscreen'  -  a logical indicating whether the figure is full
%                          screen
%
%  OUTPUTS:
%   fig_h      - a handle to the figure created
%   show      - a logical indicating whether the figure is visible
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 20.04.2023
%
% See also createAxis, assignOrCreateFigureHandle


show          = checkSetInput(para, 'show', 'logical', true);
docked        = checkSetInput(para, 'docked', 'logical', false);
full_screen   = checkSetInput(para, 'fullScreen', 'logical', false);

if(show)
    if(full_screen)
        full_screen = get(0, 'ScreenSize');
        fig_h = figure('Position', [0 -50 full_screen(3) full_screen(4)], 'PaperSize', [40 60]);
    else
        fig_h = figure();
    end
else
    if(full_screen)
        fig_h = figure('Position', [0 -50 1680 1050], 'PaperSize', [40 60], 'Visible', 'off');
    else
        fig_h = figure('Visible', 'off');
    end
end

if(docked)
    set(fig_h, 'WindowStyle', 'docked')
end


end