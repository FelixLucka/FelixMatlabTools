function [RGB, clim, scaling, cmap] = data2RGB(data, para)
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
%       'dataType'      - 'scalar', 'vector' or '2dim' indicating which type
%                         the data has: 'scalar is a scalar field,
%                         'vector' is a vector field, the last
%                         dimension is assumed to index the different
%                         vector components and the RGB color encodes
%                         direction and amplitue
%                        '2dim' is a special type where a HSV colour
%                         scheme is to conver the data to an RGB image,
%                         the first input determines the value (brightness),
%                         the second input is determines the colour (hue)
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
%   last update     - 13.10.2023
%
% See also determineClim, assignColorMap

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

dataType = checkSetInput(para, 'dataType', {'scalar', 'vector', '2dim'}, 'scalar');

if(iscell(data))
    
    RGB = cell(size(data));
    
    if(~isfield(para, 'clim'))
        % get scaling from all data
        [clim,scaling]  = determineClim(cell2vec(data), para);
        para.clim       = clim;
    end
    
    for i=1:length(data)
        
        % call data2RGB on single cell
        [RGB{i}, clim, scaling, cmap] = data2RGB(data{i}, para);
        
    end
    
else
    
    % convert data to double
    data     = double(data);
    
    % use [clim,scaling]  = determineClim(data,para) to determine clims and scaling
    % for the basic colouring of the image
    [clim, scaling]  = determineClim(data, para);
    
    % use thresholding?
    [visu_thres, df_visu_thres] = checkSetInput(para, 'visuThres', 'double', 0);
    max_scale                   = max(abs(clim));
    
    switch dataType
        
        case 'scalar'
            
            %%% scalar data
            
            % assign color map
            cmap = assignColorMap(para);

            if(df_visu_thres)
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
                thres_rel = checkSetInput(para, 'thresRel', 'logical', true);
                if(thres_rel)
                    visu_thres = visu_thres * max_scale;
                end
                thres_mode  = checkSetInput(para,'thresMode', {'shrink', 'cut'}, 'error');
                thres_color = checkSetInput(para,'thresColor', {'zero', 'white', 'black'}, 'zero');
                thres_mask  = abs(data(:)) < visu_thres;
            end
            
            % scale data to [0 1];
            data = (data - clim(1)) / (clim(2) - clim(1));
            data(data < 0) = 0;
            data(data > 1) = 1;
            
            if(thresholding)
                % apply thresholding (if can be applied before)
                
                switch thres_mode
                    case 'shrink'
                        Ctr = ([-visu_thres, 0, visu_thres] - clim(1)) / (clim(2) - clim(1));
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
            scaling_power = checkSetInput(para, 'scalingPower', 'double', 1);
            data  = data.^scaling_power;
            
            % build single color channels
            res_cmap  = size(cmap, 1);
            cmap_ind  = 1 + floor(data(:) * (res_cmap-1));
            sz_data = size(data);
            clear data
            r = cmap(cmap_ind, 1);
            g = cmap(cmap_ind, 2);
            b = cmap(cmap_ind, 3);
            clear cmap_ind
            r = reshape(r, sz_data);
            g = reshape(g, sz_data);
            b = reshape(b, sz_data);
            
            % set thresholding color to 0 or lowest color in colormap
            if(clim(1) <= 0 && clim(2) >= 0)
                tcolor = cmap(1 + floor( -clim(1) / (clim(2) - clim(1)) * (res_cmap - 1)), :);
            else
                tcolor = cmap(1, :);
            end
            
        case 'vector'
            
            %%% data is a 2D vector field
            
            if(ndims(data) ~= 3)
                notImpErr
            end
            
            angle = wrapTo2Pi(atan2(data(:, :, 2), data(:, :, 1))) / (2*pi);
            data  = sqrt(sum(data.^2, 3));
            
            if(df_visu_thres)
                thresholding = false;
            else
                thresholding = true;
                % relative or absolute thresholding?
                thres_rel = checkSetInput(para, 'thresRel', 'logical', true);
                if(thres_rel)
                    visu_thres = visu_thres * max_scale;
                end
                thres_mode  = checkSetInput(para, 'thresMode', {'shrink', 'cut'}, 'error');
                thres_color = checkSetInput(para, 'thresColor', {'zero', 'white', 'black'}, 'zero');
                thres_mask  = abs(data(:)) < visu_thres;
            end
            
            
            % scale data to [0 1];
            data = (data - clim(1)) / (clim(2) - clim(1));
            data(data < 0) = 0;
            data(data > 1) = 1;
            
            if(thresholding)
                % apply thresholding (if can be applied before)
                switch thres_mode
                    case 'shrink'
                        Ctr = ([-visu_thres, 0, visu_thres] - clim(1)) / (clim(2) - clim(1));
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
            scaling_power = checkSetInput(para, 'scalingPower', 'double', 1);
            data  = data.^scaling_power;
            
            % build single color channels
            colors = hsv2rgb([angle(:), data(:), ones(size(data(:)))]);
            sz_data = size(data);
            clear angle data
            
            r = reshape(colors(:, 1), sz_data);
            g = reshape(colors(:, 2), sz_data);
            b = reshape(colors(:, 3), sz_data);
            
            % set thresholding color to 0 in colormap
            tcolor = [0,0,0];
            cmap   = [];
            
        case '2dim'
            
            % implement later (see 'scalar' and 'vector' case)
            thresholding = false;
            
            %%% 2 dimensional data
            data1 = sliceArray(data, nDims(data), 1);
            data2 = sliceArray(data, nDims(data), 2);
            clear data
            
            % assign 2dim color map
            para.colorMap = checkSetInput(para, 'colorMap', {'hs2dim', 'hv2dim', ...
                'hsv2dim', 'red2dim', 'blue2dim', 'blue2red2dim'}, 'hv2dim');
            para.res      = checkSetInput(para, 'res', 'i,>0', 1001);
            cmap          = assignColorMap(para);
            res_cmap       = size(cmap);
            cmap_r         = cmap(:,:,1);
            cmap_g         = cmap(:,:,2);
            cmap_b         = cmap(:,:,3);

            % scale data to [0 1];
            data1 = (data1 - clim(1,1)) / (clim(1,2) - clim(1,1));
            data1(data1 < 0) = 0;
            data1(data1 > 1) = 1;

            data2 = (data2 - clim(2,1)) / (clim(2,2) - clim(2,1));
            data2(data2 < 0) = 0;
            data2(data2 > 1) = 1;
            
            % apply power scaling to data1 if needed to enhance contrast
            scaling_power = checkSetInput(para, 'scalingPower', 'double', 1);
            data1  = data1.^scaling_power;
            
            % build single color channels
            cmap_ind1 = 1 + floor(data1(:) * (res_cmap(1)-1));
            cmap_ind2 = 1 + floor(data2(:) * (res_cmap(2)-1));
            sz_data = size(data1);

            r = cmap_r(sub2ind(size(cmap_r),  cmap_ind1(:), cmap_ind2(:)));
            g = cmap_g(sub2ind(size(cmap_r),  cmap_ind1(:), cmap_ind2(:)));
            b = cmap_b(sub2ind(size(cmap_r),  cmap_ind1(:), cmap_ind2(:)));
            clear cmap_ind
            r = reshape(r, sz_data);
            g = reshape(g, sz_data);
            b = reshape(b, sz_data);
            
            % set thresholding color to 0 in colormap
            tcolor = cmap(1,1,:);
            
    end
    
    if(thresholding)
        % assign the thresholding color to the thresholded areas
        switch thres_color
            case 'zero'
                % set above
            case 'white'
                tcolor = [1 1 1];
            case 'black'
                tcolor = [0 0 0];
                
        end
        r(thres_mask) = tcolor(1);
        g(thres_mask) = tcolor(2);
        b(thres_mask) = tcolor(3);
    end
    
    
    % if mask should be used, assign the mask color to the corresponding
    % regions
    [mask, dont_mask] = checkSetInput(para, 'mask', 'logical', false);
    if(~dont_mask)
        mask_color  = checkSetInput(para, 'maskColor', 'double', [1 1 1]);
        reduce_mask_fac = checkSetInput(para, 'reduceMaskFactor', '>0', 1);
        if(reduce_mask_fac < 1)
            mask = reduceMask(mask, reduce_mask_fac);
        end
        r(mask(:)) = mask_color(1);
        g(mask(:)) = mask_color(2);
        b(mask(:)) = mask_color(3);
    end
    
    % concatenate the single color channels to an RGB
    RGB = cat(nDims(r)+1, r, g, b);
    
end

end
