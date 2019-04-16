function figureH = assignOrCreateFigureHandle(para)
% ASSIGNORCREATEFIGUREHANDLE assigns a figure handle or creates a new one
%
% USAGE:
%   figureH = assignOrCreateFigureHandle(para)
%
%  INPUTS:
%   para - a struct containing optional parameters, see createFigure.m and
%          the function calling assignOrCreateFigureHandle.m
%   
%  OUTPUTS:
%   figureH           - handle to the figure
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 05.11.2018
%
% See also createFigure, createAxis, assignOrCreateAxisHandle


% check which version of Matlab is used
if(verLessThan('matlab', '8.5.0'))
    [figureH, dfFigureH] = checkSetInput(para, 'figureHandle', 'double', 1);
else
    [figureH, dfFigureH] = checkSetInput(para, 'figureHandle', 'matlab.ui.Figure', 1);
end

if(dfFigureH)
    figureH = createFigure(para);
end

end