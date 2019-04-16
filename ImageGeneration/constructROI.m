function [ROI, roiID] = constructROI(grid, para)
%CONSTRUCTROI constructs a region of interest
%
% DESCRIPTION: 
%   constructROI.m constructs a region of interest from simple geometric
%   shapes (currently, half-spaces and cylinders)
%
% USAGE:
%  [ROI,roiID] = constructROI(setting, para)
%
%  INPUT:
%   grid - a struct with the fields x, y, z describing the spatial
%          corrdinates of the grid points
%   para - a struct containing parameters
%       'type' defines the type of ROI constructed and the additional parameters needed: 
%           -'halfSpace':  a half space is defined by a*x + b*y + c*z >= d
%           - 'cylinder': a cylindrical volume defined by a base point in
%           space, a direction and a radius r
%
%  OUTPUTS:
%   ROI   - a logical mask of the same size as the setting
%   roiID - a char to identify the ROI
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also embedROI


type = checkSetInput(para,'type', {'halfSpace','cylinder'}, [], 'error');

switch type
    
    case 'halfSpace'
        % a half space is defined by a*x + b*y + c*z >= d,

        % needs the parameters 'abc' and 'd'
        abc = checkSetInput(para,'abc', 'numeric', 'error');
        d   = checkSetInput(para, 'd', 'numeric', 'error');
        
        ROI = abc(1) * grid.x + abc(2) * grid.y + abc(3) * grid.z >= d;
        roiID = ['HPa' num2str(abs(1),'%.2e') 'b' num2str(abs(2),'%.2e') ...
                'c' num2str(abs(3),'%.2e') 'd' num2str(d,'%.2e')];
    
    case 'cylinder'
        % a cylinder is defined by its base point, its directional
        % vector and its radius r
        
        % parameters 
        base      = checkSetInput(para, 'base', 'numeric', [0, 0, 0]);
        direction = checkSetInput(para, 'direction', 'numeric', [0 0 1]);
        radius    = checkSetInput(para, 'radius', '>0', 1);
        
        % normalize direction
        direction = direction/norm(direction);
        
        % center grid around base point
        X = grid.x - base(1);
        Y = grid.y - base(2);
        Z = grid.z - base(3);
        
        % compute projection of all grid points onto direction vector
        projection = X * direction(1) + Y * direction(2) + Z * direction(3);
        % subtract projection to obtain radial vector component
        radialPartX = X - projection * direction(1);
        radialPartY = Y - projection * direction(2);
        radialPartZ = Z - projection * direction(3);
        % compute radial vector length
        radialDist = radialPartX.^2 + radialPartY.^2 + radialPartZ.^2;
        
        % create ROI 
        ROI = radialDist < radius^2;
        roiID = 'Cy';
end
    

end