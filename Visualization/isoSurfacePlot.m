function [plotH, axisH, figureH] = isoSurfacePlot(v, info, para)
% ISOSURFACEPLOT plots the iso-level surfaces of a given image volume
%
%  USAGE:
%  [~,~,~,v] = flow;
%  para.isoValues = [-0.5, 0, 0.5];
%  [plotH,axisH,figureH] = isoSurfacePlot(v, [], para)
%
%  INPUTS:
%   x    - 3D array 
%   info  - a struct containing information about the image geometry
%   para - a struct containing optional parameters
%       'isoVales'  - a vector of iso-level values; default: [0.9,0.75,0.5,0.25,0.1]
%       'nFacesMax' - the maximal number of faces that the patches should
%                     have; default: Inf
%       'colorMap'  - A color map
%       'axisHandle'- A handle to existing axes in which the plot should be
%                     placed.
%
%  OUTPUTS:
%   plotH	 - hande to the different plots
%   axisH    - handle to the axis
%   figureH  - handle to the figure
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 21.02.2019
%
% See also visualizeImage, slicePlot, flyThroughVolume, surfPlot


% check user defined value for info, otherwise assign default value
if(nargin < 2)
    info = [];
end

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

szV   = size(v);
% normalize to 1
v     = v / max(abs(v(:)));
isNeg = any(v(:) < 0);

% read out geometric properties
[x, y, z] = ndgrid(1:szV(1), 1:szV(2), 1:szV(3)); 
x  = checkSetInput(info, 'x', 'numeric', x); 
y  = checkSetInput(info, 'y', 'numeric', y); 
z  = checkSetInput(info, 'z', 'numeric', z); 

dx = checkSetInput(info, 'dx', '>0', x(2,1,1)-x(1,1,1));
dy = checkSetInput(info, 'dy', '>0', y(1,2,1)-y(1,1,1));
dz = checkSetInput(info, 'dz', '>0', z(1,1,2)-z(1,1,1));

% read out iso-level values
if(isNeg)
    dfIsoValues = [-2/3, -1/3, 0, 1/3, 2/3];
else
    dfIsoValues = [0.9, 0.75, 0.5, 0.25, 0.1];
end
isoValues   = checkSetInput(para, 'isoValues', 'double', dfIsoValues);

% restrict the number of the patches faces for a faster visulization?
nFacesMax = checkSetInput(para, 'nFacesMax', 'i,>0', Inf);

% read out color map
colorMap    = assignColorMap(para);
resColorMap = size(colorMap, 1);


for i=1:length(isoValues)
    % for each iso-level value, extract surface by isosurface and reduce
    % the patch size if necessary
    isoSurface{i} = isosurface(x, y, z, v, isoValues(i));
    if(nFacesMax < size(isoSurface{i}.faces,1))
        isoSurface{i} = reducepatch(isoSurface{i}, nFacesMax);
    end
end


% create new axis
[axisH,dfFL] = checkSetInput(para, 'axisHandle', 'mixed', 1);
if(dfFL)
    [axisH, figureH] = createAxis(para);
end

% set saxis properties
set(axisH, 'DataAspectRatio', [dx, dy, dz]);
xlim(axisH, [min(x(:)), max(x(:))]);
ylim(axisH, [min(y(:)), max(y(:))]);
zlim(axisH, [min(z(:)), max(z(:))]);
xlabel('X'); 
ylabel('Y');
zlabel('Z');
colormap(colorMap)
hold(axisH,'on')


for i=1:length(isoValues)
    % plot all the surfaces
    scaledIso = isoValues(i)/2 + 0.5;
    FaceColor = colorMap(1+floor(scaledIso*(resColorMap-1)),:);
    plotH{i}  = patch(isoSurface{i}, 'FaceColor', FaceColor,...
        'LineStyle', 'none', 'FaceLighting', 'phong');
end

% add light and fix view point          
lightAndView(axisH, para)
hold(axisH,'off')

drawnow()

end