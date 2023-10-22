function RGB = covariancePlot(cov_mat, para)
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
%   rgb - n x n x 3 RGB image of the plot
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 14.10.2023
%
% See also cov2corr

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

% check if correlation matrix instead of covariance matrix shall be plotted
plot_corr = checkSetInput(para,'plotCorr', 'logical', false);
if(plot_corr)
    cov_mat = cov2corr(cov_mat);
end

[axis_h, ~] = assignOrCreateAxisHandle(para);

% convert to RGB
para.colormap = checkSetInput(para, 'colorMap', 'mixed', 'blue2red');
[RGB, clim]   = data2RGB(cov_mat, para);

image(RGB,'Parent', axis_h);

% set plot box and data aspect ratios
box_aspect_ratio  = checkSetInput(para,'PlotBoxAspectRatio', 'double', [1 1 1]);
data_aspect_ratio = checkSetInput(para,'DataAspectRatio', 'double', box_aspect_ratio);
set(axis_h, 'DataAspectRatio', data_aspect_ratio, ...
           'PlotBoxAspectRatio', box_aspect_ratio, 'CLim', clim);
box(axis_h, 'on'); hold(axis_h, 'all');

% print image
print   = checkSetInput(para,'print','logical',false);
if(print)
    para.fileName = checkSetInput(para,'fileName','char', 'CovImage.png');
    printRGB(RGB,para)
end

end