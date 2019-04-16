function [plotH, axisH, figureH] = spherePlot(XYZ, V, para)
%SPHEREPLOT draws 3D spheres of varing size
%
% USAGE:
%   spherePlot(randn(100,3), rand(100,1), [])
%
% INPUTS:
%   XYZ - n x 3 list of center points of the spheres
%   V   - n x 1 list of non-negative values used to scale the spheres
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
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
%       date            - 03.12.2018
%       last update     - 03.12.2018
%
% See also conePlot, surfPlot

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end


% create new axis
[axisH,dfFL] = checkSetInput(para, 'axisHandle', 'mixed', 1);
if(dfFL)
    [axisH, figureH] = createAxis(para);
end
hold(axisH, 'on')

sphereRes = check_and_assign_struc(para, 'sphereRes', 'i,>0', 20);
scaling   = check_and_assign_struc(para, 'scaling', '>0', 1);
color     = check_and_assign_struc(para, 'color', 'double', [1 0 0]);

% construct a single sphere
[SX,SY,SZ]  = sphere(sphereRes); 
SX          = SX(:);
SY          = SY(:);
SZ          = SZ(:);
nVerts      = size(SX, 1);
sphereFaces = convhull(SX, SY, SZ);
nFaces      = size(sphereFaces, 1);

nSphere = size(XYZ, 1);
faces   = zeros(nFaces*nSphere, 3);
verts   = zeros(nSphere*nVerts, 3);
vMax    = max(abs(V));

for iSphere=1:nSphere
    
    % scale sphere
    tSX = V(iSphere)/vMax * scaling*SX;
    tSY = V(iSphere)/vMax * scaling*SY;
    tSZ = V(iSphere)/vMax * scaling*SZ;
    % shift sphere 
    tSX = tSX + XYZ(iSphere,1);
    tSY = tSY + XYZ(iSphere,2);
    tSZ = tSZ + XYZ(iSphere,3);
    
    % construct Faces
    ind            = (iSphere-1)*nVerts+1:(iSphere*nVerts);
    verts(ind,1:3) = [tSX,tSY,tSZ];
    ind = (iSphere-1)*nFaces+1:(iSphere*nFaces);
    faces(ind,1:3) = sphereFaces + (iSphere-1)*nVerts;
    
end

plotH = patch('Parent', axisH, 'faces', faces, 'vertices', verts, 'LineStyle', 'none', ...
    'FaceColor',color);

% add light and fix view point          
lightAndView(axisH, para)

end

