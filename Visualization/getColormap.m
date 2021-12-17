function cmap = getColormap(colorStr, res, invert, para)
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
%  cmap = getColormap('blue2red', 1000)
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
%   res         - the resolution of the color map (default: 1001)
%   invert      - flip the colormap upside down
%   hueMax      - for 2dim colour maps 
%   hueMin      - for 2dim colour maps
%   
%  OUTPUTS:
%   cmap        - an array of size [res, 3] representing RGB channels of the color map
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 16.11.2021
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
        
    case {'inferno', 'magma', 'plasma', 'viridis'}
        
        % load python color maps provided by Ander Biguri:
        % Ander Biguri (2021). Perceptually uniform colormaps (https://www.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps), MATLAB Central File Exchange. Retrieved January 2, 2021.
        eval(['cmap = ' colorStr '(' int2str(res) ');']);
        
    case {'hv2dim', 'hs2dim', 'hsv2dim', 'red2dim', 'blue2dim', 'blue2red2dim'}
        
        % 2 dimensional colour maps
        hueMax = checkSetInput(para, 'hueMax', '>=0', 2/3);
        hueMin = checkSetInput(para, 'hueMin', '>=0', 0);
        
        [X,Y] = meshgrid(linspace(hueMin, hueMax, res), linspace(0,1,res));
        switch colorStr
            case 'hv2dim'
                cmap  = cat(3, X, ones(size(X)), Y);
            case 'hs2dim'
                cmap  = cat(3, X, Y, ones(size(X)));
            case 'hsv2dim'
                cmap  = cat(3, X, Y, Y);
            case 'red2dim'
                cmap  = cat(3, ones(size(X)), Y', Y);
            case 'blue2dim'
                cmap  = cat(3, 2/3 * ones(size(X)), Y', Y);
            case 'blue2red2dim'
                cmapRed   = cat(3, ones(size(X)), Y', Y);
                cmapBlue  = cat(3, 2/3 * ones(size(X)), Y', Y);
                cmap      = cat(2, flip(cmapBlue, 2), cmapRed);
                cmap      = cmap(:,1:2:end,:);
        end
        cmap = hsv2rgb(cmap);
        
    otherwise
        error(['Unkown colorstr: ' colorStr]);
end

if(invert)
    cmap = flipud(cmap);
end

end
