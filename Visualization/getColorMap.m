function cmap = getColorMap(colorStr, res, invert)
% GETCOLORMAP extends Matlab's colormap.m by some more color maps, in 
% particular by bi-drectional ones 
%
% DESCRIPTION:
%   getColorMap.m can be used to generate a colormap, i.e., a N x 3 array of
%   values inbetween 0 and 1, represeting RGB values of a continous colour
%   map. It adds a few colormaps to Matlab's inbuild ones, in particular 
%   bi-directional ones
%
% USAGE:
%  cmap = getColorMap('blue2red', 1000)
%
%  INPUTS:
%   colorstr    - a string identifying the color map: 
%                   - all of Matlab's inbuild ones are supported. 
%                   - 'red', 'green', 'blue' give single colour scales
%                   - 'blue2red' and 'cool2hot' give bi-drectional ones
%                     by stacking two color maps on top of each other with
%                     one of them inverted 
%
%  OPTIONAL INPUTS:
%   res         - the resolution of the color map (default: 1001)
%   invert      - flip the colormap upside down
%   
%  OUTPUTS:
%   cmap        - an array of size [res, 3] representing RGB channels of the color map
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 05.11.2018
%
% See also assignColorMap, str2RGB

% check user defined value for res, otherwise assign default value
if(nargin < 2)
    res = 10001;
end

% check user defined value for invert, otherwise assign default value
if(nargin < 3)
    invert = false;
end

cmap = ones(res, 3);

switch colorStr
    
    case {'autumn', 'spring', 'summer', 'winter', 'bone', 'jet', ...
            'hot', 'cool', 'copper', 'gray', 'hsv', 'parula', 'prism',...
            'lines', 'colorcube', 'flag', 'pink'}
        
        % Matlab's build in color maps
        figure1 = figure;
        eval(['cmap = colormap(' colorStr '(' int2str(res) '));']);
        close(figure1);
        
    case 'red'
        
        % a red scale
        cmap(:, 2) = ((res-1):-1:0) / res;
        cmap(:, 3) = ((res-1):-1:0) / res;
        
    case 'green'
        
        % a green scale
        cmap(:, 1) = ((res-1):-1:0) / res;
        cmap(:, 3) = ((res-1):-1:0) / res;
        
    case 'blue'
        
        % a blue scale
        cmap(:, 1) = ((res-1):-1:0) / res;
        cmap(:, 2) = ((res-1):-1:0) / res;
        
    case 'rand'
        
        % a random colour map
        cmap = rand(res, 3);
        
    case 'blue2red'
        
        % a color map to display positive and negative values, ranges from
        % blue to red where white should be used for 0
        if(mod(res, 2) == 0)
           res = res + 1; 
           cmap = ones(res, 3);
        end
        
        cmap(:, 1) = min(1, 2*(0:1:(res-1)) / res);
        cmap(:, 2) = min(2*((res-1):-1:0) / res, 2*(0:1:(res-1)) / res);
        cmap(:, 3) = min(2*((res-1):-1:0) / res, 1);
        
    case 'cool2hot'
        
        % a color map to display positive and negative values, build by attaching the hot color scale
        % for positive vales to a cool color scale for negative values 
        % black should is used for 0
        figure1 = figure;
        eval(['cmapHot = colormap(hot(' int2str(floor(res/2)) '));']);
        close(figure1);
        cmapCold = flipud([cmapHot(:, 3), cmapHot(:,2), cmapHot(:, 1)]);
        cmap     = [cmapCold; 0, 0, 0; cmapHot];
        
    case 'kWave'
        
        % get the k-Wave color scale (kWave needs to be on the path!)
        cmap = getColorMap(res + mod(res, 2));
        
    otherwise
        error(['Unkown colorstr: ' colorStr]);
end

if(invert)
    cmap = flipud(cmap);
end

end
