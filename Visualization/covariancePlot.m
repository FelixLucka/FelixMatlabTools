function RGB = covariancePlot(covMat, para)
%COVARIANCEPLOT plots a covariance matrix (or its correlation matrix)
%
% USAGE:
%   RGB = covariancePlot(covMat, para)
%
% INPUTS:
%   covMat - n x n covariance matrix
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'plotType' - 'cov' or 'corr' determining 
%
% OUTPUTS:
%   RGB - n x n x 3 RGB image of the plot
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also cov2corr

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

% check if correlation matrix instead of covariance matrix shall be plotted
plotCorr = checkSetInput(para,'plotCorr', 'logical', false);
if(plotCorr)
    covMat = cov2corr(covMat);
end

[axisH, ~] = assignOrCreateAxisHandle(para);

% convert to RGB
para.colormap = checkSetInput(para, 'colorMap', 'mixed', 'blue2red');
[RGB, clim]   = data2RGB(covMat, para);

image(RGB,'Parent', axisH);

% set plot box and data aspect ratios
PlotBoxAspectRatio = checkSetInput(para,'PlotBoxAspectRatio', 'double', [1 1 1]);
DataAspectRatio    = checkSetInput(para,'DataAspectRatio', 'double', PlotBoxAspectRatio);
set(axisH, 'DataAspectRatio', DataAspectRatio, ...
           'PlotBoxAspectRatio', PlotBoxAspectRatio, 'CLim', clim);
box(axisH, 'on'); hold(axisH, 'all');

% print image
print   = checkSetInput(para,'print','logical',false);
if(print)
    para.fileName = checkSetInput(para,'fileName','char', 'CovImage.png');
    printRGB(RGB,para)
end

end

