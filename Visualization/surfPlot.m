function [p_surf, axis_h, fig_h] = surfPlot(surf_patch, para)
%SURFPLOT generates a surface plot
%
% USAGE:
%   surfPlot(surf_patch, para)
%
% INPUTS:
%   surf_patch - a struct containing the fields 'faces' and 'vertices', see
%               patch.m
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       see assignOrCreateAxisHandle.m for parameters to assign or create
%       axis
%       'faceAlpha' -  see patch.m
%       'faceLighting'- see patch.m
%       'faceColor'   - see patch.m
%       'edgesLinstyle' see patch.m
%       'plotType'  - determining the type of plot
%                     'geometry' - the patch is displayed with one color
%                     'data' - the faces of the patch are colored to
%                     display data on the vertices.
%
% OUTPUTS:
%   p_surf - Patch object
%   axis_h - handle to axis
%   fig_h  - handle to figure
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 14.10.2023
%
% See also


% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

[axis_h, fig_h] = assignOrCreateAxisHandle(para);

face_alpha    = checkSetInput(para, 'faceAlpha', 'double', 1);
face_lighting = checkSetInput(para, 'faceLighting', {'gouraud', 'flat'}, 'gouraud');

plot_type = checkSetInput(para, 'plotType', {'geometry', 'data'}, 'geometry');

switch plot_type
    
    case 'geometry'
        
        face_color     = checkSetInput(para,'faceColor', 'double', [1 0 0]);
        edges_linstyle = checkSetInput(para,'edgesLinstyle', {'-','none'}, '-');
        p_surf = patch('Faces', surf_patch.faces, 'Vertices', surf_patch.vertices,...
            'Parent', axis_h, 'FaceAlpha', face_alpha, 'LineStyle', ...
            edges_linstyle, 'FaceColor', face_color, 'FaceLighting', face_lighting);
        
    case 'data'

        data  = checkSetInput(para, 'data', 'double', 'error');
        cdata = data2RGB(data, para);
        p_surf = patch('Faces',surf_patch.faces, 'Vertices', surf_patch.vertices,...
            'Parent', axis_h, 'LineStyle', 'none', 'FaceColor', 'interp',...
            'FaceVertexCData', cdata, 'FaceLighting', face_lighting);
        
end

drawnow()

end
