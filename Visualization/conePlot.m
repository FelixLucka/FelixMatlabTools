function [plotH, axisH, figureH] = conePlot(XYZ, UVW, para)
%CONEPLOT is an adaptation of coneplot that can handle more general
%inputs
%
% USAGE:
%   conePlot(randn(100,3), randn(100,3), [])
%
% INPUTS:
%   XYZ - n x 3 list of starting points of the cones
%   UVW - n x 3 list of vectors indicating direction and lenght of cones
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
% See also spherePlot, surfPlot

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

coneRes = checkSetInput(para, 'coneRes', 'i,>0', 20);
scaling = checkSetInput(para, 'scaling', '>0', 1);
color   = checkSetInput(para, 'color', 'double', [1 0 0]);

vecNorms    = sqrt(sum(UVW.^2, 2));
maxVecNorms = max(vecNorms);    

conewidth = .333;

[faces, verts] = conegeom(coneRes);
nCones         = size(UVW, 1);
flen           = size(faces, 1);
nVerts         = size(verts, 1);
faces          = repmat(faces, nCones, 1);
verts          = repmat(verts, nCones, 1);
offset         = floor((0:flen*nCones-1) / flen)';
faces          = faces + repmat(nVerts*offset, 1, 3);

for iCone = 1:nCones
    index             = (iCone-1)*nVerts+1:iCone*nVerts;
    lenCone           = scaling * 1/maxVecNorms * vecNorms(iCone);
    verts(index, 3)   = verts(index,3) * lenCone;
    verts(index, 1:2) = verts(index,1:2) * lenCone*conewidth;
    verts(index, :)   = coneorient(verts(index,:),    UVW(iCone,:));
    verts(index, :)   = bsxfun(@plus, verts(index,:), XYZ(iCone,:));
end

plotH = patch('Parent', axisH, 'faces', faces, 'vertices', verts, ...
              'LineStyle', 'none', 'FaceColor', color);

% add light and fix view point          
lightAndView(axisH, para)

%%% the following lines of code are unmodified from Matlab's own coneplot.m          


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f, v] = conegeom(coneRes)

cr = coneRes;
[xx, yy, zz]=cylinder([.5 0], cr);
f = zeros(cr*2-2,3);
v = zeros(cr*3,3);
v(1     :cr  ,:) = [xx(2,1:end-1)' yy(2,1:end-1)' zz(2,1:end-1)'];
v(cr+1  :cr*2,:) = [xx(1,1:end-1)' yy(1,1:end-1)' zz(1,1:end-1)'];
v(cr*2+1:cr*3,:) = v(cr+1:cr*2,:);

f(1:cr,1) = (cr+2:2*cr+1)';
f(1:cr,2) = f(1:cr,1)-1;
f(1:cr,3) = (1:cr)';
f(cr,1) = cr+1;
f(cr+1:end,1) = 2*cr+1;
f(cr+1:end,2) = (2*cr+2:3*cr-1)';
f(cr+1:end,3) = f(cr+1:end,2)+1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XYZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vout=coneorient(v, orientation)
cor = [-orientation(2) orientation(1) 0];
if sum(abs(cor(1:2)))==0
    if orientation(3)<0
        vout=rotategeom(v, [1 0 0], 180);
    else
        vout=v;
    end
else
    a = 180/pi*asin(orientation(3)/norm(orientation));
    vout=rotategeom(v, cor, 90-a);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vout=rotategeom(v,azel,alpha)
u = azel(:)/norm(azel);
alph = alpha*pi/180;
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = u(1);
y = u(2);
z = u(3);
rot = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
    x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
    x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera]';

x = v(:,1);
y = v(:,2);
z = v(:,3);

[m,n] = size(x);
newxyz = [x(:), y(:), z(:)];
newxyz = newxyz*rot;
newx = reshape(newxyz(:,1),m,n);
newy = reshape(newxyz(:,2),m,n);
newz = reshape(newxyz(:,3),m,n);

vout = [newx newy newz];

function str=id(str)
str = ['MATLAB:coneplot:' str];

