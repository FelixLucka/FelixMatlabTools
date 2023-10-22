function lightAndView(axis_h, para)
%LIGHTANDVIEW add light to a figure and sets the view point
%
% USAGE:
%   lightAndView(axisH, para)
%
% INPUTS:
%   axisH - an instance of matlab.graphics.axis.Axes
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'addLight'  - logical indicating whether an light should be added
%                     to the scene
%       'viewPoint' - sets the view to the prescripted view point (a double
%                     vector of length 3)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 14.10.2023
%
% See also

add_light = checkSetInput(para, 'addLight', 'logical', true);
if(add_light)
    camlight right; lighting phong
end


[view_point, df] = checkSetInput(para, 'viewPoint', 'double', []);
if(~df)
    view(axis_h, view_point);
end

end