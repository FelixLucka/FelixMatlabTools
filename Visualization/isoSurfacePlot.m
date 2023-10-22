function [plot_h, axis_h, figure_h] = isoSurfacePlot(v, info, para)
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
%       last update     - 14.10.2023
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

sz_v   = size(v);
% normalize to 1
v     = v / max(abs(v(:)));
is_neg = any(v(:) < 0);

% read out geometric properties
[x, y, z] = ndgrid(1:sz_v(1), 1:sz_v(2), 1:sz_v(3)); 
x  = checkSetInput(info, 'x', 'numeric', x); 
y  = checkSetInput(info, 'y', 'numeric', y); 
z  = checkSetInput(info, 'z', 'numeric', z); 

dx = checkSetInput(info, 'dx', '>0', x(2,1,1)-x(1,1,1));
dy = checkSetInput(info, 'dy', '>0', y(1,2,1)-y(1,1,1));
dz = checkSetInput(info, 'dz', '>0', z(1,1,2)-z(1,1,1));

% read out iso-level values
if(is_neg)
    df_iso_values = [-2/3, -1/3, 0, 1/3, 2/3];
else
    df_iso_values = [0.9, 0.75, 0.5, 0.25, 0.1];
end
iso_values   = checkSetInput(para, 'isoValues', 'double', df_iso_values);

% restrict the number of the patches faces for a faster visulization?
n_faces_max = checkSetInput(para, 'nFacesMax', 'i,>0', Inf);

% read out color map
color_map    = assignColorMap(para);
res_color_map = size(color_map, 1);


for i=1:length(iso_values)
    % for each iso-level value, extract surface by isosurface and reduce
    % the patch size if necessary
    iso_surface{i} = isosurface(x, y, z, v, iso_values(i));
    if(n_faces_max < size(iso_surface{i}.faces,1))
        iso_surface{i} = reducepatch(iso_surface{i}, n_faces_max);
    end
end


% create new axis
[axis_h, df] = checkSetInput(para, 'axisHandle', 'mixed', 1);
if(df)
    [axis_h, figure_h] = createAxis(para);
end

% set saxis properties
set(axis_h, 'DataAspectRatio', [dx, dy, dz]);
xlim(axis_h, [min(x(:)), max(x(:))]);
ylim(axis_h, [min(y(:)), max(y(:))]);
zlim(axis_h, [min(z(:)), max(z(:))]);
xlabel('X'); 
ylabel('Y');
zlabel('Z');
colormap(color_map)
hold(axis_h,'on')


for i=1:length(iso_values)
    % plot all the surfaces
    scaled_iso = iso_values(i)/2 + 0.5;
    face_color = color_map(1+floor(scaled_iso*(res_color_map-1)),:);
    plot_h{i}  = patch(iso_surface{i}, 'FaceColor', face_color,...
        'LineStyle', 'none', 'FaceLighting', 'phong');
end

% add light and fix view point          
lightAndView(axis_h, para)
hold(axis_h,'off')

drawnow()

end