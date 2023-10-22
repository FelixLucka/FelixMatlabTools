function [plot_h, axis_h, fig_h] = spherePlot(xyz, v, para)
%SPHEREPLOT draws 3D spheres of varing size
%
% USAGE:
%   spherePlot(randn(100,3), rand(100,1), [])
%
% INPUTS:
%   xyz - n x 3 list of center points of the spheres
%   v   - n x 1 list of non-negative values used to scale the spheres
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'axisHandle'- A handle to existing axes in which the plot should be
%                     placed.
%       'sphereRes' - an integer determining the resolution of the
%       triangulation patch used to reder the sphere (default: 20)
%       'scaling'   - relative scaling (default: 1)
%       'color'     - RGB value determining the color of the spheres
%
%  OUTPUTS:
%   plot_h - hande to the different plots
%   axis_h - handle to the axis
%   fig_h  - handle to the figure
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 14.10.2023
%
% See also conePlot, surfPlot

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% create new axis
[axis_h,df] = checkSetInput(para, 'axisHandle', 'mixed', 1);
if(df)
    [axis_h, fig_h] = createAxis(para);
end
hold(axis_h, 'on')

sphere_res = checkSetInput(para, 'sphereRes', 'i,>0', 20);
scaling   = checkSetInput(para, 'scaling', '>0', 1);
color     = checkSetInput(para, 'color', 'double', [1 0 0]);

% construct a single sphere
[sx,sy,sz]   = sphere(sphere_res); 
sx           = sx(:);
sy           = sy(:);
sz           = sz(:);
n_verts      = size(sx, 1);
sphere_faces = convhull(sx, sy, sz);
n_faces      = size(sphere_faces, 1);

n_sphere = size(xyz, 1);
faces    = zeros(n_faces*n_sphere, 3);
verts    = zeros(n_sphere*n_verts, 3);
v_max    = max(abs(v));

for i_sphere=1:n_sphere
    
    % scale sphere
    t_sx = v(i_sphere)/v_max * scaling*sx;
    t_sy = v(i_sphere)/v_max * scaling*sy;
    t_sz = v(i_sphere)/v_max * scaling*sz;
    % shift sphere 
    t_sx = t_sx + xyz(i_sphere,1);
    t_sy = t_sy + xyz(i_sphere,2);
    t_sz = t_sz + xyz(i_sphere,3);
    
    % construct Faces
    ind            = (i_sphere-1)*n_verts+1:(i_sphere*n_verts);
    verts(ind,1:3) = [t_sx,t_sy,t_sz];
    ind = (i_sphere-1)*n_faces+1:(i_sphere*n_faces);
    faces(ind,1:3) = sphere_faces + (i_sphere-1)*n_verts;
    
end

plot_h = patch('Parent', axis_h, 'faces', faces, 'vertices', verts, ...
    'LineStyle', 'none', 'FaceColor',color);

% add light and fix view point          
lightAndView(axis_h, para)

end

