function [pSurf, axisH, figureH] = surfPlot(surfPatch, para)
%SURFPLOT generates a surface plot
%
% USAGE:
%   surfPlot(surfPatch, para)
%
% INPUTS:
%   surfPatch - a struct containing the fields 'faces' and 'vertices', see
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
%   pSurf   - Patch object
%   axisH   - handle to axis
%   figureH - handle to figure
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 03.12.2018
%
% See also


% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

[axisH, figureH] = assignOrCreateAxisHandle(para);

faceAlpha    = checkSetInput(para, 'faceAlpha', 'double', 1);
faceLighting = checkSetInput(para, 'faceLighting', {'gouraud', 'flat'}, 'gouraud');

plotType = checkSetInput(para, 'plotType', {'geometry', 'data'}, 'geometry');

switch plotType
    
    case 'geometry'
        
        faceColor     = checkSetInput(para,'faceColor', 'double', [1 0 0]);
        edgesLinstyle = checkSetInput(para,'edgesLinstyle', {'-','none'}, '-');
        pSurf = patch('Faces', surfPatch.faces, 'Vertices', surfPatch.vertices,...
            'Parent', axisH, 'FaceAlpha', faceAlpha, 'LineStyle', ...
            edgesLinstyle, 'FaceColor', faceColor, 'FaceLighting', faceLighting);
        
    case 'data'

        data  = checkSetInput(para, 'data', 'double', 'error');
        cdata = data2RGB(data, para);
        pSurf = patch('Faces',surfPatch.faces, 'Vertices', surfPatch.vertices,...
            'Parent', axisH, 'LineStyle', 'none', 'FaceColor', 'interp',...
            'FaceVertexCData', cdata, 'FaceLighting', faceLighting);
        
end

drawnow()

end
