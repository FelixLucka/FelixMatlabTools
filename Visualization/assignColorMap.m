function [cMap, res] = assignColorMap(para)
% ASSIGNCOLORMAP assigns a color map from given parameters
%
% USAGE:
%  colorMap = assignColorMap(para)
%
%  INPUTS:
%   para - a struct containing optional parameters (as an input to another
%   function that needs a colormap)
%       'colorMap'  - A color map; default: parula
%   
%  OUTPUTS:
%   cmap        - an array of size [res,3] representing RGB channels of the color map
%   res         - the resolution of the color map
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also getColorMap


if(isfield(para, 'colorMap'))
    switch class(para.colorMap)
        case 'double'
            cMap = para.colorMap;
        case 'char'
            res  = checkSetInput(para, 'res', 'i,>0', 10001);
            cMap = getColorMap(para.colorMap, res);
        otherwise
            error('A color map must be provided as a Nx3 matrix or a string')
    end
else
    res  = 10001;
    cMap = getColorMap('parula', res);
end

res = size(cMap, 1);

end