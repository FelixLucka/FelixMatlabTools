function T = rotateAroundAxisTrafo(axis, theta, dim)
%ROTATEAROUNDAXIS CREATES MATRIX FOR ROATION AROUND ONE AXIS
%
% DETAILS:
%   rotateAroundAxisTrafo.m can be used to create an affine3d object 
%   that encapsulates a rotation around one of the three coordinate axis
%
% USAGE:
%   T = rotateAroundAxisTrafo('z', phi_offset, 3);   
%
% INPUTS:
%   axis - 'x'/'X', 'y'/'Y', 'z'/'Z'
%
% OPTIONAL INPUTS:
%   dim - dimension of the transformation: 2 or 3 (default)
%
% OUTPUTS:
%   T - 4x4 matrix representing forward affine transformation
%
% ABOUT:
%       author          - Felix Lucka
%       date            - ??.??.2022
%       last update     - 27.09.2023
%
% See also affine3d

% check user defined value for dim, otherwise assign default value
if(nargin < 3)
    if(ischar(axis))
        dim = 3;
    else
        dim = length(axis);
    end
end

if(ischar(axis))
    switch axis
        case {'x', 'X'}
            axis = zeros(1,3);
            axis(1) = 1;
        case {'y', 'Y'}
            axis = zeros(1,3);
            axis(2) = 1;
        case {'z', 'Z'}
            axis = zeros(1,3);
            axis(3) = 1;
    end
else
    if(dim == 2)
        axis(3) = 0;
    end
end

% set up 3D matrix first and reduce if in 2D
cos_theta = cos(theta);
sin_theta = sin(theta);

T1 = cos_theta + axis(1)^2 * (1 - cos_theta);
T2 = axis(1) * axis(2) * (1 - cos_theta) - axis(3) * sin_theta;
T3 = axis(1) * axis(3) * (1 - cos_theta) + axis(2) * sin_theta;
T4 = axis(2) * axis(1) * (1 - cos_theta) + axis(3) * sin_theta;
T5 = cos_theta + axis(2)^2 * (1-cos_theta);
T6 = axis(2) * axis(3) * (1 - cos_theta) - axis(1) * sin_theta;
T7 = axis(3) * axis(1) * (1 - cos_theta) - axis(2) * sin_theta;
T8 = axis(3) * axis(2) * (1 - cos_theta) + axis(1) * sin_theta;
T9 = cos_theta + axis(3)^2 * (1 - cos_theta);

switch dim
    case 2
        T = [T1 T2 0; T4 T5 0; 0  0  1];
    case 3
        T = [T1 T2 T3 0; T4 T5 T6 0; T7 T8 T9 0; 0  0  0  1];
end

end