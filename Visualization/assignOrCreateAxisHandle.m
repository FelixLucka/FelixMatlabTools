function [axis_h, figure_h] = assignOrCreateAxisHandle(para)
% ASSIGNORCREATEAXISHANDLE assigns a axis handle or creates a new one
%
% USAGE:
% [axis_h, figure_h] = assignOrCreateAxisHandle(para)
%
%  INPUTS:
%   para - a struct containing optional parameters, see createAxis.m and
%          the function calling assignOrCreateAxisHandle.m
%   
%  OUTPUTS:
%   axis_h   - handle to the axis
%   figure_h - handle to the figure
%
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.10.2023
%
% See also assignOrCreateFigureHandle


% check which version of Matlab we're using
if(verLessThan('matlab', '8.5.0'))
    [axis_h,   df1] = checkSetInput(para, 'axisHandle', 'double', 1);
    [figure_h, df2] = checkSetInput(para, 'figureHandle', 'double', 1);
else
    [axis_h,df1]   = checkSetInput(para, 'axisHandle', 'matlab.graphics.axis.Axes', 1);
    [figure_h,df2] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);
end
if(df1 || df2)
    [axis_h, figure_h] = createAxis(para);
end

end