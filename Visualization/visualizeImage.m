function [fig_h, axis_h, RGB, clim, scaling] = visualizeImage(im, info, para)
% VISUALIZEIMAGE plots a 2D or 3D image or movie 
%
% DESCRIPTION:
%   visualizeImage is a meta image visulization routine that can be used to
%   plot 2D images or 3D volumes or movies in various ways
%
% USAGE:
%   visualizeImage(x)
%   [fig_h, ~, RGB] = visualizeImage(x, model)
%   [fig_h, axis_h, RGB] = visualizeImage(x, model)
%
%  INPUTS:
%   im - 2D, 3D or 4D array
%   info - a struct comprising information about the image that might be
%          acessed by the sub-function
%   para - a struct containing optional parameters
%       - para will be forwarded to assignOrCreateAxisHandle.m to create a
%       figure and axes, see the corresponding documentation for options
%       - for 3D plots, para will be forwarded to the sub-routine doing the plotting,
%       see the corresponding documentatiom for all options 
%       'blankMask'   - a logical mask of values that will be set to blankValue
%                       before any other operations are performed
%       'blankValue'  - see above
%       'clipIndizes' - a 2x2 or 3x2 array containg start and end indices of 
%                     region of interest to which the image is croped b
%                     before going into sub-function
%       'mask' - a logical array of the same size as im, each pixe which 
%           is "true" will get the following color:
%       'maskColor' - see above
%       'titleStr'  - a char containing the title of the figure
%       'print'     - a logical indicating whether the plots should be
%                     printed to *.png's
%       'fileName'  - prefix of the png filename if printing is desired
%       'type'      - different types of plotting for 3D, 'maxIntensity',
%                     'slicePlot' or 'flyThrough' (static images only)
%       'fps'         - frames per second (movies only)
%       'loop'        - number of repetitions of the movie sequence (movies only)
%       'dynamicScaling' - 'singleFrame' if all frames should be scaled individually,
%           'allFrames' in the opposite case. (movies only)
%       'animatedGif' - a logical indicating whether an animated gif
%           should be produced (movies only)
%       'addFrameId'   - a logical indicating whether a string
%           should be added to each string that identifies the frame (movies only)
%       'endFrame'   - last frame to plot (movies only)
%           should be added to each string that identifies the frame (movies only)
%       'fontSize'    - size of the font used in the frame identifier (movies only)
%       'font'        - the font used in the frame identifier, see
%       BitmapFont.m; (movies only)

%       
%
%  OUTPUTS:
%   fig_h  - handle to the figure
%   axis_h - handle to the axis
%   RGB    - RGB images to print
%
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 15.03.2017
%   last update     - 20.10.2023
%
% See also visulizeMotion, slicePlot, maxIntensityProjection, 
%          flyThroughReconstruction


% =========================================================================
% CHECK INPUT AND INITILIZE VARIABLES
% =========================================================================


% check user defined value for info, otherwise assign default value
if(nargin < 2)
    info = [];
end

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end


dynamic = iscell(im);
if(dynamic)
    dim = ndims(im{1});
else
    dim = ndims(im);
end

% mask images
[blank_mask, dont_blank] = checkSetInput(para, 'blankMask', 'logical', 0);
if(~dont_blank)
    
    blank_value = checkSetInput(para, 'blankValue', 'numeric', 0);
    % blank image
    blank_fun = @(im) double(not(blank_mask)) .* im + blank_value .* double(blank_mask);
    im       = applyToMatOrCell(blank_fun, im);
    
end

% clip images
[c_ind, clip] = checkSetInput(para, 'clipIndizes', 'i,>0', 0);
clip = ~clip;
if(clip)
    
    % crop image
    switch dim
        case 2
            clip_fun = @(im) im(c_ind(1, 1):c_ind(1, 2), c_ind(2, 1):c_ind(2, 2));
        case 3
            clip_fun = @(im) im(c_ind(1, 1):c_ind(1, 2), c_ind(2, 1):c_ind(2, 2), c_ind(3, 1):c_ind(3, 2));
    end
    im      = applyToMatOrCell(clip_fun, im);
    
    % adjust slices if slices are chosen
    if(isfield(para, 'slices2show'))
        dim_slice        = checkSetInput(para, 'dimSlice', 'i,>0', 1);
        if(isscalar(dim_slice))
            para.dimSlice = dim_slice * ones(size(para.slices2show));
        end
        slices_to_keep    = true(size(para.slices2show));
        for i_sl = 1:length(para.slices2show)
            para.slices2show(i_sl) = para.slices2show(i_sl) - (c_ind(para.dimSlice(i_sl), 1) - 1);
            if(para.slices2show(i_sl) <= 0 || para.slices2show(i_sl) > size(im, para.dimSlice(i_sl)))
                slices_to_keep(i_sl) = false;
            end
        end
        para.slices2show = para.slices2show(slices_to_keep);
    end
   
    % clip masks
    if(isfield(para, 'mask'))
        para.mask = applyToMatOrCell(clip_fun, para.mask);
    end

    % clip depth weigthing
    if(isfield(para, 'depth'))
        para.depth = applyToMatOrCell(clip_fun, para.depth);
    end
    
end


% =========================================================================
% MAIN VISULIZATION
% =========================================================================

switch dim
    
    case 2
        
        % =================================================================
        % 2D VISULIZATION
        % =================================================================
                
        if(~dynamic)
            
                % create figure and axes
                [axis_h, fig_h] = assignOrCreateAxisHandle(para);
                title_str = checkSetInput(para, 'title', 'char', '');
                
                % print figure?
                print = checkSetInput(para, 'print', 'logical', false);
                if(print)
                    % additional parameters
                    print_para = [];
                    root_file_name = checkSetInput(para, 'fileName', 'char', 'recSol');
                    root_file_name = strrep(root_file_name,'.png', '');
                end 
                
                % convert p to RGB image
                [RGB, clim, scaling, cmap] = data2RGB(im, para);
                
                % add sensor mask to image?
                [mask no_mask] = checkSetInput(para,'mask', 'mixed', false);
                if(~no_mask)
                    mask_color = checkSetInput(para, 'maskColor', 'mixed', [1 0 1]);   
                    if(~iscell(mask))
                        mask   = {mask};
                        mask_color = {mask_color};
                    end
                    for iMask = 1:length(mask)
                        RGB = maskRGB(RGB, mask{iMask}, mask_color{iMask});
                    end
                end
                
                % plot it using image()
                colormap(axis_h, cmap);
                image(RGB, 'Parent', axis_h);
                set(axis_h, 'YTick', zeros(1,0), 'YDir', 'reverse','XTick', ...
                    zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title(title_str);
                
                % print image?
                if(print)
                    print_para.fileName = [root_file_name '.png'];
                    printRGB(RGB,print_para);
                end
                
        else % ~dynamic
            
                T = length(im);
                
                type = checkSetInput(para,'type',{'movie', 'colorPlot'}, 'movie');
                
                switch type
                    
                    case 'movie'
                        
                        %%% read inputs and parameter
                        fps          = checkSetInput(para, 'fps', '>0', 1);
                        loop         = checkSetInput(para, 'loop', 'i,>0', 1);
                        print        = checkSetInput(para, 'print', 'logical', false);
                        add_frame_id = checkSetInput(para, 'addFrameId', 'logical', false);
                        font_sz      = checkSetInput(para, 'fontSize', 'i,>0', 20);
                        animated_gif = checkSetInput(para, 'animatedGif', 'logical', false);
                        end_frame    = checkSetInput(para, 'endFrame','i,>0', floor(T/2));
                        end_frame    = max(1, min(T, end_frame));
                        
                        [mask no_mask] = checkSetInput(para, 'RGBMask', 'cell', false);
                        mask_color        = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
                        
                        % add a string that identifies the frame number
                        if(add_frame_id)
                            font = BitmapFont('Arial', font_sz, 't=1234567890');
                        end
                        
                        % extend fps to vector
                        if(length(fps) == 1)
                           fps = fps * ones(T,1); 
                        end
                        
                        % try loop determines function without error if user closes the window
                        try
                            
                            [axis_h, fig_h] = assignOrCreateAxisHandle(para);
                            set(fig_h, 'Name', 'preparing RGB data...');
                            
                            %%% prepare and print all the RGBs
                            
                            [RGB, clim, scaling] = data2RGB(im,para);
                            clear im
                            
                            for iFrame = 1:T
                                
                                % add mask?
                                if(~no_mask)
                                    RGB{iFrame} = maskRGB(RGB{iFrame}, mask{iFrame}, mask_color);
                                end
                            
                                if(print)
                                    % images are printed to .png files
                                    inc_res_for_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                                    
                                    print_para = [];
                                    root_file_name = checkSetInput(para,'fileName','char','image');
                                    root_file_name = strrep(root_file_name,'.png','');
                                    root_file_name = strrep(root_file_name, '$frame$', int2str(iFrame));
                                    
                                    print_para.fileName = [root_file_name '.png'];
                                    if(inc_res_for_aniso_voxel)
                                        print_para.printPixPerPix = round([info.dx,info.dy]/min(info.dx,info.dy));
                                    end
                                    printRGB(RGB{iFrame}, print_para);
                                end
                                
                                if(add_frame_id)
                                    % add text to identify the frames, in top left corner,
                                    % with offset = fontSize (can be extended later)
                                    frame_id = ['t=' int2str(iFrame)];
                                    RGB{1,iFrame} = AddTextToImage(RGB{iFrame},...
                                        frame_id, ceil(font_sz/4)*[1 1], [1 0 1], font);
                                end
                            end
                            
                            % generate animated gif before the images is shown
                            if(animated_gif)
                                set(fig_h,'Name','generating animated gif...');
                                animation_para = para;
                                root_file_name = checkSetInput(animation_para,...
                                    'fileName', 'char', 'maxIntensityProMovie');
                                root_file_name = strrep(root_file_name, '.gif','');
                                root_file_name = strrep(root_file_name, '_t$frame$', '');
                                root_file_name = strrep(root_file_name, 't$frame$', '');
                                root_file_name = strrep(root_file_name, '$frame$', '');
                                animation_para.fileName = root_file_name;
                                animation_para.fps = checkSetInput(animation_para,...
                                    'fpsMovie', 'double', mean(fps));
                                
                                % call movieFromRGB.m to do the conversion
                                movieFromRGB(RGB, animation_para);
                            end
                            
                            
                            % to make axis
                            image(RGB{1},'Parent',axis_h);
                            set(axis_h,'YTick',zeros(1,0),'YDir','reverse',...
                                'XTick',zeros(1,0),'Layer','top','DataAspectRatio',[1 1 1])
                            image_handle_fly = get(axis_h,'Children');
                            
                            %%% plotting, the try block will catch an error if the figure is closed
                            %%% before the visulization is finished
                            i_loop = 0;
                            while(i_loop < loop)
                                i_loop = i_loop + 1;
                                for t=1:T
                                    tPlotFly = tic;
                                    set(image_handle_fly,'CData', RGB{t});
                                    set(fig_h,'Name', ['reconstruction, frame = ' int2str(t)]);
                                    pause(1/fps(t) - toc(tPlotFly))
                                end
                            end
                            set(image_handle_fly, 'CData', RGB{end_frame});
                            set(fig_h, 'Name', ['reconstruction, frame = ' int2str(end_frame)]);
                            %close(figureH);
                            
                        catch exception
                            switch exception.identifier
                                case 'MATLAB:class:InvalidHandle'
                                    disp('maximum intensity projection movie stopped because the window was closed')
                                otherwise
                                    rethrow(exception)
                            end
                        end
                        
                    case 'colorPlot'
                        
                        % create figure and axes
                        [axis_h, fig_h] = assignOrCreateAxisHandle(para);
                        title_str = checkSetInput(para, 'title', 'char', '');
                        [mask, no_mask] = checkSetInput(para, 'RGBMask', 'logical', false);
                        mask_color         = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
                        
                        % print figure?
                        print = checkSetInput(para, 'print', 'logical', false);
                        if(print)
                            % additional parameters
                            print_para = [];
                            root_file_name = checkSetInput(para, 'fileName', 'char', 'recSol');
                            root_file_name = strrep(root_file_name, '.png', '');
                        end
                        
                        alpha_merge = checkSetInput(para, 'alphaMerge', 'numeric', 0.5);
                        visu_thres  = checkSetInput(para, 'visuThres', 'double', 0.1);

                        sz_im  = size(im{1});
                        RGB    = ones([sz_im, 3]);
                        max_im = max(vec(cell2mat(im)));
                        min_im = min(vec(cell2mat(im)));
                        
                        if(min_im < 0)
                            error('negative intensities')
                        end
                        
                        for t=1:T
                            colors = hsv2rgb([t/T * ones(prod(sz_im), 1), ...
                                im{t}(:)/max_im, ones(prod(sz_im), 1)]);
                            R      = reshape(colors(:, 1), sz_im);
                            G      = reshape(colors(:, 2), sz_im);
                            B      = reshape(colors(:, 3), sz_im);
                            RGB_t  = cat(ndims(R)+1, R, G, B);
                            
                            alpha_mask = alpha_merge * ((im{t}/max_im) > visu_thres);
                            RGB = (bsxfun(@times, alpha_mask, RGB_t) + ...
                                bsxfun(@times, (1-alpha_mask), RGB));
                        end
                        clear im
                        
                        % add RGB mask to image?
                        if(~no_mask)
                            RGB = maskRGB(RGB, mask, mask_color);
                        end
                
                        % plot it using image()
                        image(RGB, 'Parent', axis_h);
                        set(axis_h, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                            'XTick', zeros(1,0), 'Layer', 'top', ...
                            'DataAspectRatio',[1 1 1])
                        title(title_str);
                        
                        % print image?
                        if(print)
                            print_para.fileName = [root_file_name '.png'];
                            printRGB(RGB, print_para);
                        end
                end % switch type 
        end % if(~dynamic), else branch
        
    case 3
        
        % =================================================================
        % 3D VISULIZATION
        % =================================================================
        
        axis_h = [];
        if(~dynamic)
            % static case
            allowedTypes = {'maxIntensity', 'slicePlot', 'flyThrough'};
        else
            % dynamic case
            allowedTypes = {'maxIntensity', 'slicePlot'};
        end
        
        type = checkSetInput(para, 'type', allowedTypes, 'maxIntensity');
        switch type
            case 'maxIntensity'
                [fig_h, RGB] = maxIntensityProjection(im, info, para);
            case 'flyThrough'
                [fig_h, axis_h, RGB] = flyThroughVolume(im, info, para);
            case 'slicePlot'
                [fig_h, axis_h, RGB] = slicePlot(im, info, para);
        end
        
end


% update figures and process callbacks
drawnow();


end