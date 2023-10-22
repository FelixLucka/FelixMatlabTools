function [figure_h, RGB] = maxIntensityProjection(im, info, para)
% MAXINTENSITYPROJECTION plots the maximum intensity projections of a given
% 3D volume or of a sequece of 3D volumes image as a movie
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%   [figure_h, rgb] = maxIntensityProjection(p, setting, para)
%   maxIntensityProjection(p, setting)
%
%  INPUTS:
%   im    - 3D array or cell of 3D arrays
%   info  - a struct containing information about the image geometry
%   para  - a struct containing optional parameters
%       'figureHandle'- A handle to an existing figure in which the plot should be
%                       placed.
%       'title'       - The title of the figure
%       'bool_print'  - a logical indicating whether the plots should be
%                       printed to *.png's
%       'fileName'    - prefix of the png filename if printing is desired
%       'fps'         - frames per second (movies only)
%       'loop'        - number of repetitions of the movie sequence (movies only)
%       'dynamicScaling' - 'singleFrame' if all frames should be scaled individually,
%           'allFrames' in the opposite case.
%       'bool_animatedGif' - a logical indicating whether an animated gif
%           should be produced
%       'bool_addFrameIdentifier'   - a logical indicating whether a string
%           should be added to each string that identifies the frame
%       'fontSize'    - size of the font used in the frame identifier
%       'font'        - the font used in the frame identifier, see BitmapFont.m;
%
%  OUTPUTS:
%   figure_h      - handle to the figure
%   RGB           - the projections as a cell of RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 14.10.2023
%
% See also slicePlot, flyThroughVolume

% check user defined value for info, otherwise assign default value
if(nargin < 2)
    info = [];
end

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

if(~iscell(im))
    
    figure_h = assignOrCreateFigureHandle(para);
    
    title = checkSetInput(para, 'title', 'char', 'Maximum Intensity Projection');
    set(figure_h, 'Name', title);
    
    % maximum intensity projection in X direction
    sub_x  = subplot(1, 3, 1, 'Parent', figure_h);
    RGB{1} = maxIntProHelp(sub_x, im, 1, 'X', para);
    
    % maximum intensity projection in Y direction
    sub_y  = subplot(1, 3, 2, 'Parent', figure_h);
    RGB{2} = maxIntProHelp(sub_y, im, 2, 'Y', para);
    
    % maximum intensity projection in Z direction
    sub_z  = subplot(1, 3, 3, 'Parent', figure_h);
    RGB{3} = maxIntProHelp(sub_z, im, 3, 'Z', para);
    
    print = checkSetInput(para,'print', 'logical', false);
    if(print)
        
        % images are printed to .png files
        inc_res_4_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
        
        print_para    = [];
        root_filename = checkSetInput(para, 'fileName', 'char', 'maxIntensityPro');
        root_filename = strrep(root_filename,'.png','');
        
        print_para.fileName = [root_filename '_mIX.png'];
        if(inc_res_4_aniso_voxel)
            print_para.printPixPerPix = round([info.dy, info.dz] / min(info.dy, info.dz));
        end
        printRGB(RGB{1}, print_para);
        
        print_para.fileName = [root_filename '_mIY.png'];
        if(inc_res_4_aniso_voxel)
            print_para.printPixPerPix = round([info.dx, info.dz] / min(info.dx, info.dz));
        end
        printRGB(RGB{2}, print_para);
        
        print_para.fileName = [root_filename '_mIZ.png'];
        if(inc_res_4_aniso_voxel)
            print_para.printPixPerPix = round([info.dx, info.dy] / min(info.dx, info.dy));
        end
        printRGB(RGB{3}, print_para);
    end
    
    drawnow();
    
else
    
    %%% dynamic visulization
    
    T = length(im);
    
    %%% read inputs and parameter
    fps          = checkSetInput(para, 'fps', '>0', 1);
    loop         = checkSetInput(para, 'loop', 'i,>0', 1);
    print        = checkSetInput(para, 'print', 'logical', false);
    add_frame_id = checkSetInput(para, 'addFrameIdentifier', 'logical', false);
    font_size    = checkSetInput(para, 'fontSize', 'i,>0', 20);
    animated_gif = checkSetInput(para, 'animatedGif', 'logical', false);
    end_frame    = checkSetInput(para, 'endFrame', 'i,>0', T);
    end_frame    = min(T, end_frame);
    
    % add a string that identifies the frame number
    if(add_frame_id)
        font = BitmapFont('Arial', font_size, 't=1234567890');
    end
    
    % extend fps to vector
    if(length(fps) == 1)
        fps = fps * ones(T,1);
    end
    
    
    % try loop determines function without error if user closes the window
    try
        
        figure_h = assignOrCreateFigureHandle(para);
        set(figure_h, 'Name', 'preparing RGB data...');
        
        %%% first prepare and print all the RGBs
        dynamic_scaling = checkSetInput(para, 'dynamicScaling', {'singleFrame', 'allFrames'}, 'singleFrame');
        switch dynamic_scaling
            case 'singleFrame'
            case 'allFrames'
                [clim, ~]    = determineClim(vec(cell2mat(im)), para);
                para.scaling = 'manualLin';
                para.clim    = clim;
        end
        
        RGB = cell(3, T);
        for i_T = 1:T
            
            % maximum intensity projection in X direction
            RGB{1, i_T} = maxIntProHelp([], im{i_T}, 1, 'X', para);
            % maximum intensity projection in Y direction
            RGB{2, i_T} = maxIntProHelp([], im{i_T}, 2, 'Y', para);
            % maximum intensity projection in Z direction
            RGB{3, i_T} = maxIntProHelp([], im{i_T}, 3, 'Z', para);
            
            if(print)
                % images are printed to .png files
                inc_res_4_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                if(inc_res_4_aniso_voxel)
                    enforceFields(info, 'info', {'dx', 'dy', 'dz'})
                end
                
                print_para = [];
                root_filename = checkSetInput(para, 'fileName', 'char', 'maxIntensityPro');
                root_filename = strrep(root_filename,'.png','');
                root_filename = strrep(root_filename, '$frame$', int2str(i_T));
                
                print_para.fileName = [root_filename '_mIX.png'];
                if(inc_res_4_aniso_voxel)
                    print_para.printPixPerPix = round([info.dy, info.dz] / min(info.dy, info.dz));
                end
                printRGB(RGB{1, i_T}, print_para);
                
                print_para.fileName = [root_filename '_mIY.png'];
                if(inc_res_4_aniso_voxel)
                    print_para.printPixPerPix = round([info.dx, info.dz] / min(info.dx, info.dz));
                end
                printRGB(RGB{2, i_T}, print_para);
                
                print_para.fileName = [root_filename '_mIZ.png'];
                if(inc_res_4_aniso_voxel)
                    print_para.printPixPerPix = round([info.dx, info.dy] / min(info.dx, info.dy));
                end
                printRGB(RGB{3, i_T}, print_para);
            end
            
            if(add_frame_id)
                % add text to identify the frames, in top left corner,
                % with offset = fontSize (can be extended later)
                frame_id    = ['t=' int2str(i_T)];
                RGB{1, i_T} = AddTextToImage(RGB{1, i_T}, frame_id, ceil(font_size/4)*[1 1], [1 0 1], font);
            end
        end
        
        % generate animated gif before the images is shown
        if(animated_gif)
            
            set(figure_h, 'Name', 'generating animated gif...');
            animation_para = para;
            root_filename  = checkSetInput(animation_para, 'fileName', 'char', 'maxIntensityProMovie');
            root_filename  = strrep(root_filename, '.gif', '');
            root_filename  = strrep(root_filename, '$frame$', '');
            animation_para.fileName = [root_filename '_mI'];
            animation_para.fps = checkSetInput(animation_para, 'fpsMovie', 'double', mean(fps));
            
            rgb_movie = cell(1, T);
            gap_color = checkSetInput(para, 'gapColor', 'double', [0 0 0]);
            gap_width = checkSetInput(para, 'gapWidth', 'i,>0', 10);
            
            length_vert = max([size(RGB{1, 1}, 2), size(RGB{2, 1}, 2), size(RGB{3, 1}, 2)]);
            fill_vert   = ones(gap_width, length_vert);
            fill_vert   = cat(3, gap_color(1) * fill_vert, gap_color(2) * fill_vert, gap_color(3) * fill_vert);
            for iDim = 1:3
                fill_horz{iDim} = ones(size(RGB{iDim, 1}, 1), length_vert-size(RGB{iDim, 1}, 2));
                fill_horz{iDim} = cat(3, gap_color(1) * fill_horz{iDim}, gap_color(2) * fill_horz{iDim}, gap_color(3) * fill_horz{iDim});
            end
            for i_T = 1:T
                rgb_movie{i_T} = cat(1, cat(2, RGB{1,i_T}, fill_horz{1}),...
                    fill_vert, cat(2, RGB{2, i_T}, fill_horz{2}),...
                    fill_vert, cat(2, RGB{3, i_T}, fill_horz{3}));
            end
            
            % call movieFromRGB.m to do the conversion
            movieFromRGB(rgb_movie, animation_para);
            
        end
        
        
        %%% create  axis
        axes_x_h = subplot(1, 3, 1, 'Parent', figure_h, 'YTick', zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axes_x_h, 'on'); hold(axes_x_h, 'all');
        image(zeros(size(RGB{1, 1})), 'Parent', axes_x_h);
        ylim(axes_x_h, [0.5, size(RGB{1, 1}, 1) + 0.5]); 
        xlim(axes_x_h, [0.5, size(RGB{1, 1}, 2) + 0.5]);
        imageHandleFly{1} = get(axes_x_h, 'Children');
        ylabel('y'); xlabel('z');
        axes_x_h.Title.String = 'X projection';
        
        axes_y_h = subplot(1, 3, 2, 'Parent', figure_h, 'YTick', zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axes_y_h,'on'); hold(axes_y_h, 'all');
        image(zeros(size(RGB{2, 1})), 'Parent', axes_y_h);
        ylim(axes_y_h, [0.5, size(RGB{2, 1}, 1) + 0.5]); 
        xlim(axes_y_h, [0.5, size(RGB{2, 1}, 2) + 0.5]);
        imageHandleFly{2} = get(axes_y_h, 'Children');
        ylabel('x'); xlabel('z');
        axes_y_h.Title.String = 'Y projection';
        
        axes_z_h = subplot(1, 3, 3,'Parent', figure_h, 'YTick',zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axes_z_h, 'on'); hold(axes_z_h, 'all');
        image(zeros(size(RGB{3, 1})), 'Parent', axes_z_h);
        ylim(axes_z_h, [0.5, size(RGB{3, 1}, 1) + 0.5]); 
        xlim(axes_z_h, [0.5, size(RGB{3, 1}, 2) + 0.5]);
        imageHandleFly{3} = get(axes_z_h, 'Children');
        ylabel('x'); xlabel('y');
        axes_z_h.Title.String = 'Z projection';
        
        
        %%% plotting, the try block will catch an error if the figure is closed
        %%% before the visulization is finished
        i_loop = 0;
        while(i_loop < loop)
            i_loop = i_loop + 1;
            for i_T = 1:T
                t_pl_fly = tic;
                for i_pl = 1:length(imageHandleFly)
                    set(imageHandleFly{i_pl}, 'CData', RGB{i_pl, i_T});
                end
                set(figure_h, 'Name', ['Maximum intensity projection, frame = ' int2str(i_T)]);
                pause(1/fps(i_T) - toc(t_pl_fly))
            end
        end
        for i_pl = 1:length(imageHandleFly)
            set(imageHandleFly{i_pl}, 'CData', RGB{i_pl, end_frame});
        end
        set(figure_h, 'Name', ['Maximum intensity projection, frame = ' int2str(end_frame)]);
        %close(figureH);
        
    catch exception
        switch exception.identifier
            case 'MATLAB:class:InvalidHandle'
                disp('maximum intensity projection movie stopped because the window was closed')
            otherwise
                rethrow(exception)
        end
    end
end

end