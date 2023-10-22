function vol = makeRotationalVolume(s_vec, direction, radius_fun, x, y, z)
%FUNCTIONTEMPLATE is a template for a function describtion
%
% DETAILS: 
%   functionTemplate.m can be used as a template 
%
% USAGE:
%   x = functionTemplate(y)
%
% INPUTS:
%   y - bla bla
%
% OPTIONAL INPUTS:
%   z    - bla bla
%   para - a struct containing further optional parameters:
%       'a' - parameter a
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 19.12.2018
%
% See also

% get r and a coordinates for all
% basically the distance of each point to the plane with normal direction
% that goes through s_vec: a = dot(s_vec- [x,y,z], direction)
a = (x - s_vec(1)) * direction(1) + (y - s_vec(2)) * direction(2) + (z - s_vec(3)) * direction(3);
% r is the norm of ([x,y,z] - a * direction) - s_vec 
r = sqrt(((x - a * direction(1)) - s_vec(1)).^2 + ((y - a * direction(2)) - s_vec(2)).^2 + ((z - a * direction(3)) - s_vec(3)).^2);
% evaluate radius function
vol = r < radius_fun(a);

end