function [figure_h, sub_plot_h, RGB] = slicePlot(im, info, para)
% SLICEPLOT plots the slices of a given 3D volume or a movie
% of a dynamic sequence of 3D volumes
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%  [figure_h, RGB] = slicePlot(im, setting, para)
%  slicePlot(p, setting)
%
%  INPUTS:
%   im    - 3D image volume or cell of 3D image volumes
%   info  - a struct containing information about the image geometry
%   para  - a struct containing optional parameters
%       'dimSlice' - dimension to slice (1,2 or 3)
%       'slices2show' - array of slice values to show
%       'mask' - a 3D logical array of voxels, each of which is "true" will
%       get the following color
%       'maskColor' - RGB color to give to the masked pixels
%       'reduceMaskFactor' - a factor by which the mask is subsampled
%       'colPlots' - number of colums used to plot the slices
%       'rowPlots' - number of rows used to plot the slices
%       'figureHandle'- A handle to an existing figure in which the plot should be
%                       placed.
%       'title'       - The title of the figure
%       'print'  - a logical indicating whether the plots should be
%                       printed to *.png's
%       'fileName'    - prefix of the png filename if printing is desired
%       'fps'         - frames per second (movies only)
%       'loop'        - number of repetitions of the movie sequence (movies only)
%       'dynamicScaling' - 'singleFrame' if all frames should be scaled individually,
%           'allFrames' in the opposite case. (movies only)
%       'animatedGif' - a logical indicating whether an animated gif
%           should be produced (movies only)
%       'addFrameIdentifier'   - a logical indicating whether a string
%           should be added to each string that identifies the frame (movies only)
%       'fontSize'    - size of the font used in the frame identifier (movies only)
%       'font'        - the font used in the frame identifier, see
%       BitmapFont.m; (movies only)
%
%  OUTPUTS:
%   figure_h   - handle to the figure
%   sub_plot_h - handle to the subplot axis
%   RGB        - the slices views as RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 01.03.2018
%   last update     - 14.10.2023
%
% See also visualizeImage, maxIntensityProjection, flyThroughReconstruction

% check user defined value for info, otherwise assign default value
if(nargin < 2 || isempty(info))
    info = [];
    if(iscell(im))
        info.type = 'dynamic';
    else
        info.type = 'static';
    end
    info.dx = 1; info.dy = 1; info.dz = 1;
end

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

switch info.type
    case 'static'
        
        % create figure and axis
        figure_h   = assignOrCreateFigureHandle(para);
        title_fig  = checkSetInput(para, 'title', 'char', 'Slice Views');
        set(figure_h, 'Name', title_fig)
        
        % read out dimension to slice
        dim_slice    = checkSetInput(para, 'dimSlice', 'i,>0', 1);

        % names of the slices
        dim_names     = {'X','Y','Z'};
        dim_slice_name = dim_names(dim_slice);
        % read out which slices to show
        slices2show  = checkSetInput(para, 'slices2show', 'i,>0', ceil(size(im, dim_slice(1))/2));
        n_sl         = length(slices2show);
        if(isscalar(dim_slice))
            dim_slice = dim_slice * ones(1, n_sl);
        end

        % prepare slices
        for i_sl = 1:n_sl
            slices{i_sl} = sliceArray(im, dim_slice(i_sl), slices2show(i_sl), true);
        end
        

        [RGB, ~, ~, cmap] = data2RGB(slices, removeFields(para,{'mask'}));
%         if(length(slices2show) > 1)
%             RGB = cellfun(@(x) squeeze(x), num2cell(RGB,setdiff(1:4,dim_slice)), ...
%                 'UniformOutput', false);
%         else
%             RGB = {squeeze(RGB)};
%         end
        
        % add mask to image?
        [mask, no_mask] = checkSetInput(para,'mask', 'mixed', false);
        if(~no_mask)
            mask_color = checkSetInput(para, 'maskColor', 'mixed', [1 0 1]);
            reduce_mask_factor = checkSetInput(para, 'reduceMaskFactor', '>0', 1);
            for i_slice = 1:length(RGB)
                mask_i = sliceArray(mask, dim_slice(i_slice), slices2show(i_slice), true);
                if(reduce_mask_factor < 1)
                    mask_i = reduceMask(mask_i, reduce_mask_factor);
                end
                RGB{i_slice} = maskRGB(RGB{i_slice}, mask_i, mask_color);
            end
        end
                
        %%% printing
        print     = checkSetInput(para,'print','logical',false);
        if(print)
            print_para = [];
            root_file_name = checkSetInput(para, 'fileName', 'char', 'recSol');
            root_file_name = strrep(root_file_name, '.png', '');
            
            inc_res_4_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
            if(inc_res_4_aniso_voxel)
                switch dim_slice
                    case 1
                        print_para.printPixPerPix = round([info.dy,info.dz]/min(info.dy,info.dz));
                    case 2
                        print_para.printPixPerPix = round([info.dx,info.dz]/min(info.dx,info.dz));
                    case 3
                        print_para.printPixPerPix = round([info.dx,info.dy]/min(info.dy,info.dx));
                end
            end
            
            
            trailing_zeros = checkSetInput(para, 'trailingZeros', 'logical', false);
            if(trailing_zeros)
                integer_format = ['%0' int2str(1+floor(log10(n_sl))) 'd'];
            else
                integer_format = '%d';
            end

            print_para.printPixPerPix = checkSetInput(para, 'printPixPerPix', 'i,>0', [1 1]);            
            disp('print the desired slices to png');
            for i_slice=1:length(slices2show)
                print_para.fileName = [root_file_name '_slice' dim_slice_name{i_slice} ...
                    sprintf(integer_format, slices2show(i_slice)) '.png'];
                printRGB(squeeze(RGB{i_slice}), print_para);
            end
        end
        
        
        %%% plotting
        screen_info  = get( groot, 'Screensize' );
        screen_ratio = screen_info(3)/screen_info(4);
        col_plots = checkSetInput(para, 'colPlots', 'i,>0', floor(sqrt(n_sl) * screen_ratio));
        row_plots = checkSetInput(para, 'rowPlots', 'i,>0', ceil(n_sl/col_plots));
        for i_slice = 1:n_sl
            sub_plot_h{i_slice} = subplot(row_plots, col_plots, i_slice, 'Parent', figure_h);
            colormap(sub_plot_h{i_slice}, cmap);
            image(RGB{i_slice}, 'Parent', sub_plot_h{i_slice});
            set(sub_plot_h{i_slice}, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
            title([dim_slice_name{i_slice} ' = ' int2str(slices2show(i_slice))]);
        end
        drawnow();
        
    case 'dynamic'
        
        T = length(im);
        
        %%% read inputs and parameter
        fps          = checkSetInput(para, 'fps', '>0', 1);
        loop         = checkSetInput(para, 'loop', 'i,>0', 1);
        print        = checkSetInput(para, 'print', 'logical', false);
        add_frame_id = checkSetInput(para, 'addFrameId', 'logical', false);
        font_sz      = checkSetInput(para, 'fontSize', 'i,>0', 20);
        animated_gif = checkSetInput(para, 'animatedGif', 'logical', false);
        end_frame     = min(T, checkSetInput(para,'endFrame', 'i,>0', ceil(T/2)));
        
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
            
            figure_h = assignOrCreateFigureHandle(para);
            set(figure_h, 'Name', 'preparing RGB data...');
            drawnow();
            
            
            %%% slice  the solutions
            dim_slice     = checkSetInput(para, 'dimSlice', 'i,>0', 1);
            % names of the slices
            dim_names     = {'X', 'Y', 'Z'};
            dim_slice_name = dim_names{dim_slice};
            % read out which slices to show
            slices2show  = checkSetInput(para, 'slices2show', 'i,>0', ...
                ceil(size(im{1}, dim_slice)/2));
            n_sl = length(slices2show);
            
            % prepare slices
            for iFrame = 1:T
                im{iFrame} = sliceArray(im{iFrame}, dim_slice, slices2show);
            end
            
            
            %%% first prepare and print all the RGBs
            dynamic_scaling = checkSetInput(para, 'dynamicScaling',...
                {'singleFrame', 'allFrames'}, 'singleFrame');
            switch dynamic_scaling
                case 'singleFrame'
                case 'allFrames'
                    [clim, scaling] = determineClim(vec(cell2mat(im)), para);
                    para.scaling    = 'manualLin';
                    para.clim       = clim;
            end
            
            
            for iFrame = 1:T
                [RGB{iFrame}, ~, ~, cmap] = data2RGB(im{iFrame}, para);
                if(length(slices2show) > 1)
                    RGB{iFrame} = cellfun(@(x) squeeze(x),num2cell(RGB{iFrame},...
                        setdiff(1:4, dim_slice)), 'UniformOutput', false);
                else
                    RGB{iFrame} = {squeeze(RGB{iFrame})};
                end
                
                %%% printing
                trailing_zeros = checkSetInput(para, 'trailingZeros', 'logical', false);
                if(trailing_zeros)
                    integer_format = ['%0' int2str(1+floor(log10(n_sl))) 'd'];
                else
                    integer_format = '%d';
                end
                
                if(print)
                    print_para = [];
                    root_file_name = checkSetInput(para,'fileName', 'char', 'recSol_t$frame$');
                    root_file_name = strrep(root_file_name, '.png', '');
                    root_file_name = strrep(root_file_name, '$frame$', int2str(iFrame));
                    
                    inc_res_4_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                    if(inc_res_4_aniso_voxel)
                        switch dim_slice
                            case 1
                                print_para.printPixPerPix = round([info.dy,info.dz]/min(info.dy,info.dz));
                            case 2
                                print_para.printPixPerPix = round([info.dx,info.dz]/min(info.dx,info.dz));
                            case 3
                                print_para.printPixPerPix = round([info.dx,info.dy]/min(info.dy,info.dx));
                        end
                    end
                    
                    
                    for i_slice=1:length(slices2show)
                        print_para.fileName = [root_file_name '_slice' dim_slice_name ...
                            sprintf(integer_format, slices2show(i_slice)) '.png'];
                        printRGB(squeeze(RGB{iFrame}{i_slice}), print_para);
                    end
                end
                
                if(add_frame_id)
                    % add text to identify the frames, in top left corner,
                    % with offset = fontSize (can be extended later)
                    frame_id = ['t=' int2str(iFrame)];
                    for i_slice=1:length(slices2show)
                        RGB{iFrame}{i_slice} = AddTextToImage(RGB{iFrame}{i_slice},...
                            frame_id, ceil(font_sz/4)*[1 1], [1 0 1], font);
                    end
                end
            end

            
            % generate animated gif before the images is shown
            if(animated_gif)
                set(figure_h,'Name','generating animated gif...');
                animation_para = para;
                root_file_name  = checkSetInput(animation_para, 'fileName', ...
                    'char', [pwd '/recSolMovie']);
                root_file_name  = strrep(root_file_name, '.gif','');
                root_file_name  = strrep(root_file_name, '$frame$', '');
                animation_para.fps = checkSetInput(animation_para, 'fpsMovie', 'double', mean(fps));
                
                for i_slice=1:length(slices2show)
                    animation_para.fileName = [root_file_name '_slice' dim_slice_name ...
                        sprintf(integer_format, slices2show(i_slice))];
                    rgb_movie = cell(1, T);
                    for iFrame=1:T
                        rgb_movie{iFrame} = RGB{iFrame}{i_slice};
                    end
                    % call movieFromRGB.m to do the conversion
                    movieFromRGB(rgb_movie, animation_para);
                end
            end
            
            
            %%% make axis
            col_plots = ceil(sqrt(n_sl));
            row_plots = ceil(n_sl/col_plots);
            for i_slice = 1:n_sl
                sub_plot_h{i_slice} = subplot(row_plots, col_plots, i_slice, 'Parent', figure_h);
                colormap(sub_plot_h{i_slice}, cmap);
                image(zeros(size(RGB{iFrame}{i_slice})), 'Parent', sub_plot_h{i_slice});
                set(sub_plot_h{i_slice}, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                    'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title([dim_slice_name ' = ' int2str(slices2show(i_slice))]);
                image_handle_fly{i_slice} = get(sub_plot_h{i_slice}, 'Children');
            end
            
            
            %%% plotting, the try block will catch an error if the figure is closed
            %%% before the visulization is finished
            i_loop = 0;
            while(i_loop < loop)
                i_loop = i_loop + 1;
                for t=1:T
                    t_plot_fly = tic;
                    for i_slice = 1:n_sl
                        set(image_handle_fly{i_slice}, 'CData', RGB{t}{i_slice});
                    end
                    set(figure_h, 'Name', ['Maximum intensity projection, frame = ' int2str(t)]);
                    pause(1/fps(t) - toc(t_plot_fly))
                end
            end
            for i_slice = 1:n_sl
                set(image_handle_fly{i_slice}, 'CData', RGB{end_frame}{i_slice});
            end
            set(figure_h,'Name',['Maximum intensity projection, frame = ' int2str(end_frame)]);
                        
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