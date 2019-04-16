function [axisH, figureH] = assignOrCreateAxisHandle(para)
% ASSIGNORCREATEAXISHANDLE assigns a axis handle or creates a new one
%
% USAGE:
% [axisH, figureH] = assignOrCreateAxisHandle(para)
%
%  INPUTS:
%   para - a struct containing optional parameters, see createAxis.m and
%          the function calling assignOrCreateAxisHandle.m
%   
%  OUTPUTS:
%   axisH   - handle to the axis
%   figureH - handle to the figure
%
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 05.11.2018
%
% See also assignOrCreateFigureHandle


% check which version of Matlab we're using
if(verLessThan('matlab', '8.5.0'))
    [axisH,   df1] = checkSetInput(para, 'axisHandle', 'double', 1);
    [figureH, df2] = checkSetInput(para, 'figureHandle', 'double', 1);
else
    [axisH,df1]   = checkSetInput(para, 'axisHandle', 'matlab.graphics.axis.Axes', 1);
    [figureH,df2] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);
end
if(df1 || df2)
    [axisH, figureH] = createAxis(para);
end

end