function [RGB, clim, scaling, cMap] = data2RGB(data, para)
% DATA2RGB converts data arrays into an RGB
%
% DESCRIPTION:
%   data2RGB.m is the main routine used to assing RGB values to 
%   data arrays that can be used by sub-sequent plotting routines
%
% USAGE:
%  [RGB, clim, scaling, cmap] = data2RGB(data, para)
%  RGB = data2RGB(data)
%
%  INPUTS:
%   data    - the data to convert
%
%  OPTIONAL INPUTS:
%   para    - a struct containing optional parameters
%       'vector'      - a logical indicating whether the input data is a
%                         vector field. For vector fields, the last
%                         dimension is assumed to index the different
%                         vector components and the RGB color encodes
%                         direction and amplitue
%       'colorMap'     - a color map, see getColorMap.m
%       'visuThres'    - a threshold for setting values to 0
%       'thresMode'    - a string to determine how the thresholding affects
%                         the color map
%       'thresColor'   - the color that is used to visualize the thresholded
%                        regions
%       'scalingPower' - a double used in a an additional power law scaling to
%                        enhance the conrast of low-contrast images
%       'mask'         - a logical array of the same size as data. The RGB
%                        values of all mask voxels will be overwritten by 
%                        para.maskColor
%       'maskColor'    - a RGB color that is assigned to the masked areas
%
%  OUTPUTS:
%   RGB     - A [size(data), 3] array corresponding to the red, green and
%             blue channel
%   clim    - the color limits of the image
%   scaling - a string specifying the name of the scaling
%   cmap    - the color mal used as a N x 3 array
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 05.11.2018
%
% See also determineClim, assignColorMap

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

isVector = checkSetInput(para, 'vector', 'logical', false);

% assign color map
cMap = assignColorMap(para);

if(iscell(data))
    
    RGB = cell(size(data));

    if(~isfield(para, 'clim'))
        % get scaling from all data
        [clim,scaling]  = determineClim(cell2mat(data), para);
        para.clim       = clim;
    end
    
    for i=1:length(data)
        
        % call data2RGB on single cell
        RGB{i} = data2RGB(data{i}, para);
        
    end
    
else
    
    % convert data to double
    data     = double(data);
    
    % use [clim,scaling]  = determineClim(data,para) to determine clims and scaling
    % for the basic colouring of the image
    [clim, scaling]  = determineClim(data, para);
    
    
    % use thresholding?
    [visuThres, dfVisuThres] = checkSetInput(para, 'visuThres', 'double', 0);
    maxScale             = max(abs(clim));
    
    if(~isVector)
        
        %%% scalar data
        
        if(dfVisuThres)
            thresholding = false;
        else
            if(any(data < 0))
                switch para.cmap
                    case {'blue2red','cool2hot'}
                        
                    otherwise
                        error('thresholding of data with mixed signs is only possible for colourmaps blue2red and cool2hot.');
                end
            end
            thresholding = true;
            % relative or absolute thresholding?
            thresRel = checkSetInput(para, 'thresRel', 'logical', true);
            if(thresRel)
                visuThres = visuThres * maxScale;
            end
            thresMode  = checkSetInput(para,'thresMode', {'shrink', 'cut'}, 'error');
            thresColor = checkSetInput(para,'thresColor', {'zero', 'white', 'black'}, 'zero');
            thresMask  = abs(data(:)) < visuThres;
        end
        
        % scale data to [0 1];
        data = (data - clim(1)) / (clim(2) - clim(1));
        data(data < 0) = 0;
        data(data > 1) = 1;
        
        if(thresholding)
            % apply thresholding (if can be applied before)
            
            switch thresMode
                case 'shrink'
                    Ctr = ([-visuThres, 0, visuThres] - clim(1)) / (clim(2) - clim(1));
                    Ctr(Ctr < 0) = 0;
                    Ctr(Ctr > 1) = 1;
                    shrinkFun = @(x) (x <= Ctr(1)) .* (x * (Ctr(2)/Ctr(1)))...
                        + (x > Ctr(1) & x < Ctr(3)) * Ctr(2)...
                        + (x >= Ctr(3)) .* ((1-Ctr(2))/(1-Ctr(3)) * (x - Ctr(3)) + Ctr(2));
                    data = shrinkFun(data);
                    data(data < 0) = 0;
                    data(data > 1) = 1;
                case 'cut'
                    % normal scaling, thresholding is performed afterwards
                otherwise
                    NotImpErr
            end
        end
        
        % apply power scaling if needed to enhance contrast
        scalingPower = checkSetInput(para, 'scalingPower', 'double', 1);
        data  = data.^scalingPower;
        
        % build single color channels
        resCmap  = size(cMap, 1);
        cmapInd  = 1 + floor(data(:) * (resCmap-1));
        sizeData = size(data);
        clear data
        R = cMap(cmapInd, 1);
        G = cMap(cmapInd, 2);
        B = cMap(cmapInd, 3);
        clear cmapInd
        R = reshape(R, sizeData);
        G = reshape(G, sizeData);
        B = reshape(B, sizeData);
        
    else
        
        %%% data is a 2D vector field   
        
        if(ndims(data) ~= 3)
            notImpErr
        end
        
        angle = wrapTo2Pi(atan2(data(:, :, 2), data(:, :, 1))) / (2*pi);
        data  = sqrt(sum(data.^2, 3)); 
        
        if(dfVisuThres)
            thresholding = false;
        else
            thresholding = true;
            % relative or absolute thresholding?
            thresRel = checkSetInput(para, 'thresRel', 'logical', true);
            if(thresRel)
                visuThres = visuThres * maxScale;
            end
            thresMode  = checkSetInput(para, 'thresMode', {'shrink', 'cut'}, 'error');
            thresColor = checkSetInput(para, 'thresColor', {'zero', 'white', 'black'}, 'zero');
            thresMask  = abs(data(:)) < visuThres;
        end
        
        
        % scale data to [0 1];
        data = (data - clim(1)) / (clim(2) - clim(1));
        data(data < 0) = 0;
        data(data > 1) = 1;
        
        if(thresholding)
            % apply thresholding (if can be applied before)
            switch thresMode
                case 'shrink'
                    Ctr = ([-visuThres, 0, visuThres] - clim(1)) / (clim(2) - clim(1));
                    Ctr(Ctr < 0) = 0;
                    Ctr(Ctr > 1) = 1;
                    shrinkFun = @(x) (x <= Ctr(1)) .* (x * (Ctr(2)/Ctr(1)))...
                        + (x > Ctr(1) & x < Ctr(3)) * Ctr(2)...
                        + (x >= Ctr(3)) .* ((1-Ctr(2))/(1-Ctr(3)) * (x - Ctr(3)) + Ctr(2));
                    data = shrinkFun(data);
                    data(data < 0) = 0;
                    data(data > 1) = 1;
                case 'cut'
                    % normal scaling, thresholding is performed afterwards
                otherwise
                    NotImpErr
            end
        end
        
        % apply power scaling if needed to enhance contrast
        scalingPower = checkSetInput(para, 'scalingPower', 'double', 1);
        data  = data.^scalingPower;
        
        % build single color channels        
        colors = hsv2rgb([angle(:), data(:), ones(size(data(:)))]);
        sizeData = size(data);
        clear angle data 
        
        R = reshape(colors(:, 1), sizeData);
        G = reshape(colors(:, 2), sizeData);
        B = reshape(colors(:, 3), sizeData);
        
    end
    
    if(thresholding)
        % assign the thresholding color to the thresholded areas
        switch thresColor
            case 'zero'
                tcolor = cMap(1 + floor( -clim(1) / (clim(2) - clim(1)) * (res - 1)), :);
            case 'white'
                tcolor = [1 1 1];
            case 'black'
                tcolor = [0 0 0];
                
        end
        R(thresMask) = tcolor(1);
        G(thresMask) = tcolor(2);
        B(thresMask) = tcolor(3);
    end
    
    
    % if mask should be used, assign the mask color to the corresponding
    % regions
    [mask, dontMask] = checkSetInput(para, 'mask', 'logical', false);
    if(~dontMask)
        maskColor  = checkSetInput(para, 'maskColor', 'double', [1 1 1]);
        R(mask(:)) = maskColor(1);
        G(mask(:)) = maskColor(2);
        B(mask(:)) = maskColor(3);
    end
    
    % concatenate the single color channels to an RGB
    RGB = cat(nDims(R)+1, R, G, B);
    
end

end
