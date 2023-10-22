function c_map = getColormap(color_str, res, invert, para)
% GETCOLORMAP extends Matlab's colormap.m by some more color maps, in 
% particular by bi-directional and two-dimensional ones 
%
% DESCRIPTION:
%   getColormap.m can be used to generate a colormap, i.e., a N x 3 array of
%   values inbetween 0 and 1, represeting RGB values of a continous colour
%   map. It adds a few colormaps to Matlab's inbuild ones, in particular 
%   bi-directional ones
%
% USAGE:
%  c_map = getColormap('blue2red', 1000)
%
%  INPUTS:
%   colorstr    - a string identifying the color map: 
%                   - all of Matlab's inbuild ones are supported. 
%                   - 'red', 'green', 'blue' give single colour scales
%                   - 'blue2red' and 'cool2hot' give bi-drectional ones
%                     by stacking two color maps on top of each other with
%                     one of them inverted 
%                   - 'inferno', 'magma', 'plasma', 'viridis' are the
%                     corresponding colormaps from python, taken from Ander Biguri:
%                     Ander Biguri (2021). Perceptually uniform colormaps 
%                     (https://www.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps), 
%                     MATLAB Central File Exchange. Retrieved January 2, 2021.
%                   - 'hv2dim', 'hs2dim', 'hsv2dim', 'red2dim', 'blue2dim',
%                     'blue2red2dim': 2 dimensional color maps where one dimesion is
%                      encoded in the hue channel                  
%
%  OPTIONAL INPUTS:
%   res    - the resolution of the color map (default: 1001)
%   invert - flip the colormap upside down
%   para   - a struct containing optional parameters
%               - hueMin min hue value for 2dim colour maps (df: 0)
%               - hueMax max hue value for 2dim colour maps (df: 2/3)
%   
%  OUTPUTS:
%   c_map        - an array of size [res, 3] representing RGB channels of the color map
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.10.2023
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

% check user defined value for para, otherwise assign default value
if(nargin < 4)
    para = [];
end

c_map = ones(res, 3);

switch color_str
    
    case {'autumn', 'spring', 'summer', 'winter', 'bone', 'jet', ...
            'hot', 'cool', 'copper', 'gray', 'hsv', 'parula', 'prism',...
            'lines', 'colorcube', 'flag', 'pink'}
        
        % Matlab's build in color maps
        figure1 = figure;
        eval(['c_map = colormap(' color_str '(' int2str(res) '));']);
        close(figure1);
        
    case 'red'
        
        % a red scale
        c_map(:, 2) = ((res-1):-1:0) / res;
        c_map(:, 3) = ((res-1):-1:0) / res;
        
    case 'green'
        
        % a green scale
        c_map(:, 1) = ((res-1):-1:0) / res;
        c_map(:, 3) = ((res-1):-1:0) / res;
        
    case 'blue'
        
        % a blue scale
        c_map(:, 1) = ((res-1):-1:0) / res;
        c_map(:, 2) = ((res-1):-1:0) / res;
        
    case 'rand'
        
        % a random colour map
        c_map = rand(res, 3);
        
    case 'blue2red'
        
        % a color map to display positive and negative values, ranges from
        % blue to red where white should be used for 0
        if(mod(res, 2) == 0)
           res = res + 1; 
           c_map = ones(res, 3);
        end
        
        c_map(:, 1) = min(1, 2*(0:1:(res-1)) / res);
        c_map(:, 2) = min(2*((res-1):-1:0) / res, 2*(0:1:(res-1)) / res);
        c_map(:, 3) = min(2*((res-1):-1:0) / res, 1);
        
    case 'cool2hot'
        
        % a color map to display positive and negative values, build by attaching the hot color scale
        % for positive vales to a cool color scale for negative values 
        % black should is used for 0
        figure1 = figure;
        eval(['cmap_hot = colormap(hot(' int2str(floor(res/2)) '));']);
        close(figure1);
        cmap_cold = flipud([cmap_hot(:, 3), cmapHot(:,2), cmapHot(:, 1)]);
        c_map     = [cmap_cold; 0, 0, 0; cmapHot];
        
    case 'kWave'
        
        % get the k-Wave color scale (kWave needs to be on the path!)
        c_map = getColorMap(res + mod(res, 2));
        
    case {'inferno', 'magma', 'plasma', 'viridis'}
        
        % load python color maps provided by Ander Biguri:
        % Ander Biguri (2021). Perceptually uniform colormaps (https://www.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps), MATLAB Central File Exchange. Retrieved January 2, 2021.
        eval(['c_map = ' color_str '(' int2str(res) ');']);
        
    case {'hv2dim', 'hs2dim', 'hsv2dim', 'red2dim', 'blue2dim', 'blue2red2dim'}
        
        % 2 dimensional colour maps
        hue_max = checkSetInput(para, 'hueMax', '>=0', 2/3);
        hue_min = checkSetInput(para, 'hueMin', '>=0', 0);
        
        [X,Y] = meshgrid(linspace(hue_min, hue_max, res), linspace(0,1,res));
        switch color_str
            case 'hv2dim'
                c_map  = cat(3, X, ones(size(X)), Y);
            case 'hs2dim'
                c_map  = cat(3, X, Y, ones(size(X)));
            case 'hsv2dim'
                c_map  = cat(3, X, Y, Y);
            case 'red2dim'
                c_map  = cat(3, ones(size(X)), Y', Y);
            case 'blue2dim'
                c_map  = cat(3, 2/3 * ones(size(X)), Y', Y);
            case 'blue2red2dim'
                cmap_red   = cat(3, ones(size(X)), Y', Y);
                cmap_blue  = cat(3, 2/3 * ones(size(X)), Y', Y);
                c_map      = cat(2, flip(cmap_blue, 2), cmap_red);
                c_map      = c_map(:,1:2:end,:);
        end
        c_map = hsv2rgb(c_map);
        
    otherwise
        error(['Unkown colorstr: ' color_str]);
end

if(invert)
    c_map = flipud(c_map);
end

end
