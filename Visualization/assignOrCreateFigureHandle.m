function figure_h = assignOrCreateFigureHandle(para)
% ASSIGNORCREATEFIGUREHANDLE assigns a figure handle or creates a new one
%
% USAGE:
%   figure_h = assignOrCreateFigureHandle(para)
%
%  INPUTS:
%   para - a struct containing optional parameters, see createFigure.m and
%          the function calling assignOrCreateFigureHandle.m
%   
%  OUTPUTS:
%   figure_h - handle to the figure
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.10.2023
%
% See also createFigure, createAxis, assignOrCreateAxisHandle


% check which version of Matlab is used
if(verLessThan('matlab', '8.5.0'))
    [figure_h, df_figure_h] = checkSetInput(para, 'figureHandle', 'double', 1);
else
    [figure_h, df_figure_h] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);
end

if(df_figure_h)
    figure_h = createFigure(para);
end

end