function RGB = maxIntProHelp(sub_h, im, dim, title_str, para)
% MAXINTPROHELP is an auxiliary function to be called by other plotting funtions
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%  RGB = maxIntProHelp(sub_h, p, dim, title_str, para)
%
%  INPUTS:
%   sub_h       - a handle to the sub-axies in which the plot should be placed
%   p           - image
%   dim         - the dimension over which the maximum should be computed
%   title_str   - a string displayed as the title of the subplot
%   para - a struct containing optional parameters which are mostly redirected
%   to data2RGB except for
%       'threshold' - threshold below which intensities will be set to 0 
%       'integrate' - logical indicating whether integration instead of max
%       will be used to determine projection
%       'depth_color' - logical indicating whether a two-dimensional color map
%       should be used that maps intensity to hue and depth to colour
%       'mask' - a 3D logical array of voxels, each of which is "true" will
%              get the following color
%       'maskColor' - RGB color to give to the masked pixels
%       
%
%  OUTPUTS:
%   RGB         - an RGB image (which can be printed by another
%   application)
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 14.10.2023
%
% See also visualizeImage, maxIntensityProjection

% setting a relative threshold activates the local MIP option
threshold      = checkSetInput(para, 'threshold',  '>0', 1);
integrate      = checkSetInput(para, 'integrate',  'logical', false);
depth_color    = checkSetInput(para, 'depthColor', 'logical', false);
z_up           = checkSetInput(para, 'zUp', 'logical', false);

if(depth_color)
     [depth, df] = checkSetInput(para, 'depth', 'numeric', 0);
     if(df)
         [X,Y,Z]     = ndgrid(uint16(1:size(im,1)), uint16(1:size(im,2)), uint16(1:size(im,3)));
         switch dim
             case 1
                 depth = X; 
             case 2
                 depth = Y;
             case 3
                 depth = Z;
         end
     end
     if(integrate)
         notImpErr
     end
end

im                 = double(im);

if(threshold < 1)
    threshold  = threshold  * max(abs(im), [], dim);
    im         = im .* (abs(im) >= threshold);
    if(integrate)
        image_data                          = cumsum(im, dim);
        image_data(image_data > 0 & im == 0) = NaN;
        width                              = double(image_data ~= 0);
        width(isnan(image_data))            = NaN;
        width                              = cumsum(width, dim, 'includenan');
        width                              = max(width, [], dim); 
        image_data                          = cummax(image_data, dim, 'includenan');
        image_data                          = max(image_data, [], dim);
        image_data                          = image_data ./ width;
    else
        image_data  = cummax(im, dim);
        image_data(image_data > 0 & im == 0) = NaN;
        image_data                       = cummax(image_data, dim, 'includenan');
        [image_data, ind]                = max(image_data, [], dim);
    end
else
    % normal (bi-directional) MIP
    [image_data_max, ind_max] = max(im, [], dim);
    [image_data_min, ind_min] = min(im, [], dim);
    abs_max_larger_abs_min = abs(image_data_max) > abs(image_data_min);
    image_data             = abs_max_larger_abs_min .* image_data_max + not(abs_max_larger_abs_min) .* image_data_min;
    ind                    = abs_max_larger_abs_min .* ind_max + not(abs_max_larger_abs_min) .* ind_min;
end
image_data = squeeze(image_data);
ind       = squeeze(ind);

if(depth_color)
    depth_pro = zeros(size(image_data));
    switch dim
        case 1
            for j=1:size(im,2)
                for k=1:size(im,3)
                    depth_pro(j,k) = depth(ind(j,k),j,k);
                end
            end
        case 2
            for i=1:size(im,1)
                for k=1:size(im,3)
                    depth_pro(i,k) = depth(i,ind(i,k),k);
                end
            end
        case 3
            for i=1:size(im,1)
                for j=1:size(im,2)
                    depth_pro(i,j) = depth(i,j,ind(i,j));
                end
            end
    end
    depth_pro = double(depth_pro) / double(max(depth(:)));
    
    para.dataType     = '2dim';
    [RGB, clim, ~, cmap] = data2RGB(cat(3,image_data, depth_pro), removeFields(para,{'mask'}));
    
else
    % call data2RGB to convert max(p,[],dim) to an RGB image
    [RGB, clim, ~, cmap] = data2RGB(image_data, removeFields(para,{'mask'}));
end



% should a mask be on the image?
[mask, bool_df] = checkSetInput(para, 'mask', 'logical', false);
if(~bool_df)
    mask_color = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
    mask       = squeeze(any(mask, dim));
    RGB        = maskRGB(RGB, mask, mask_color);
end

if(z_up && ismember(dim, [1,2]))
    RGB = cat(3, RGB(:,:,1)', RGB(:,:,2)', RGB(:,:,3)');
end

% plot it using image()
if(not(isempty(sub_h)))
    tick_format = checkSetInput(para, 'tickFormat', 'char', '%.1e');
    image(RGB, 'Parent', sub_h);
    set(sub_h, 'YTick', zeros(1, 0), 'YDir', 'reverse',...
        'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
    title(title_str);
    if(~depth_color)
        colormap(sub_h, cmap);
        clim_ticks = linspace(clim(1), clim(2), 11);
    else
        colormap(sub_h, squeeze(cmap(end,:,:)));
        clim_ticks = linspace(clim(2,1), clim(2,2), 11) * double(max(depth(:)));
    end
    for i_tick = 1:length(clim_ticks)
        tick_labels{i_tick} = num2str(clim_ticks(i_tick), tick_format);
    end
    colorbar(sub_h,'Ticks', linspace(0,1,11), 'TickLabels', tick_labels);
end

end