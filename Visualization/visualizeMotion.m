function [figure_h, axis_h, RGB] = visualizeMotion(v, info, para)
% VISUALIZMOTION plots a dense motion field using color coding of the vectors
%
% DESCRIPTION:
%   visualizeMotion plots a 2D vector field in RGB color coding, .e.g, the
%   direction is indicated by the color and the amplitude by the saturation
%   of it
%
% USAGE:
%  [figureH, axisH, RGB] = visualizeMotion(v, info, para)
%
%  INPUTS:
%   v    - 2D or 3D vetor field
%   info - a struct containing information about the problem's geometry
%   para - a struct containing optional parameters
%       - para will be forwarded to assignOrCreateAxisHandle.m to create a
%       figure and axes, see the corresponding documentation for options
%       'type'      - different types of plotting for 3D, 'maxIntensity', 
%                       'slicePlot' or 'flyThrough' (static settings only)
%       'titleStr'  - a char containing the title of the figure
%       'print'     - a logical indicating whether the plots should be
%                       printed to *.png's
%       'fileName'  - prefix of the png filename if printing is desired
%       'colorVisu' - 'none', 'wheel' or 'frame' determine how the color
%                       coding of the motion field should be displayed.
%       'frameThickness' - thickness of frame in pixel if colorVisu =
%       'frame'
%       'nPixelWheel' - size of the color wheel for colorVisu =
%       'wheel'
%       'mask - a logical array of the same size as im, each pixe which 
%           is "true" will get the following color:
%       'maskColor' - see above
%       'maskThickness' - size of dilation kernel (in pixel) to blow up the
%           mask
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
%   figure_h - handle to the figure
%   axis_h   - handle to the axis
%   RGB      - RGB images to print
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 20.10.2023
%
% See also visualizeImage, addColorFrame, colorWheel


%%% read out parameters common to all dimensions. 
color_visu    = checkSetInput(para, 'colorVisu', {'none', 'wheel', 'frame'}, 'none');

% figure out whether input is dynamic sequence 
is_dynamic = iscell(v);
if(is_dynamic)
    dim = nDims(v{1}) - 1;
else
    dim = nDims(v) - 1;
end

para.dataType = 'vector';

switch dim
    
%%% 2D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 2
        if(~ is_dynamic)
                
                % create figure and axes
                [axis_h, figure_h] = assignOrCreateAxisHandle(para);
                titleStr = checkSetInput(para, 'title', 'char', 'Motion Field');
                
                % print figure?
                print = checkSetInput(para, 'print', 'logical', false);
                if(print)
                    % additional parameters
                    print_para    = [];
                    root_filename = checkSetInput(para, 'fileName', 'char', 'motionField');
                    root_filename = strrep(root_filename, '.png', '');
                end
                
                % convert v to RGB image
                [RGB, ~, ~, cmap] = data2RGB(v, para);
                
                % add mask to image?
                [mask, df] = checkSetInput(para, 'mask', 'logical', false);
                if(~ df)
                    mask_color     = checkSetInput(para,'maskColor','numeric',[0 0 0]);
                    mask_thickness = checkSetInput(para,'maskThickness','i,>0',1);
                    if(mask_thickness > 1)
                        NH = radialNeighbourhood(mask_thickness, 2);
                        mask = imdilate(mask, NH);
                    end
                    RGB = maskRGB(RGB, mask, mask_color);
                end
                
                % add color frame or wheel to indicate directions
                switch color_visu
                    case 'frame'
                        frame_thickness = checkSetInput(para, 'frameThickness', ...
                            'i>0', ceil(size(v, 1) / 20));
                        RGB = addColorFrame(RGB, frame_thickness);
                    case 'wheel'
                        nPixWheel = checkSetInput(para, 'nPixelWheel', ...
                            'i>0', ceil(size(v, 1) / 5));
                        wheel = colorWheel(nPixWheel);
                        
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 1) = wheel(:, :, 1);
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 2) = wheel(:, :, 2);
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 3) = wheel(:, :, 3);
                end
                
                % plot it using image()
                colormap(axis_h, cmap);
                image(RGB, 'Parent', axis_h);
                set(axis_h, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                    'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title(titleStr);
                
                % print image?
                if(print)
                    print_para.fileName = [root_filename '.png'];
                    printRGB(RGB, print_para);
                end
                
        else % dynamic imaging
                
                T = length(v);
                
                %%% read inputs and parameter
                fps          = checkSetInput(para, 'fps', '>0', 1);
                loop         = checkSetInput(para, 'loop', 'i,>0', 1);
                print        = checkSetInput(para, 'print', 'logical', false);
                add_frame_id = checkSetInput(para, 'addFrameId', 'logical', false);
                font_sz      = checkSetInput(para, 'fontSize', 'i,>0', 20);
                animated_gif = checkSetInput(para, 'animatedGif', 'logical', false);
                end_frame    = checkSetInput(para, 'endFrame', 'i,>0', floor(T/2));
                end_frame    = max(1, min(T, end_frame));
                
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
                    
                    [axis_h, figure_h] = assignOrCreateAxisHandle(para);
                    set(figure_h, 'Name', 'preparing RGB data...');
                    
                    % first prepare and print all the RGBs
                    RGB = data2RGB(v, para);
                    
                    
                    % add mask to images?
                    [mask, df] = checkSetInput(para, 'mask', 'mixed', false);
                    if(~ df)
                        mask_color     = checkSetInput(para,'maskColor','numeric',[0 0 0]);
                        mask_thickness = checkSetInput(para,'maskThickness','i,>0',1);
                        NH = radialNeighbourhood(mask_thickness, 2);
                        if(~ iscell(mask))
                            mask = repIntoCell(mask, [1,T]);
                        end
                        for i_frame=1:T
                            if(mask_thickness > 1)
                                mask{i_frame} = imdilate(mask{i_frame}, NH);
                            end
                            RGB{i_frame} = maskRGB(RGB{i_frame}, mask{i_frame}, mask_color);
                        end
                    end
                    
                    % add color frame or wheel to indicate directions
                    switch color_visu
                        case 'frame'
                            frame_thickness = checkSetInput(para, 'frameThickness', ...
                                'i>0', ceil(size(v{1},1)/20));
                            for i_frame = 1:T
                                RGB{i_frame} = addColorFrame(RGB{i_frame}, frame_thickness);
                            end
                        case 'wheel'
                            nPixWheel = checkSetInput(para, 'nPixelWheel', ...
                                'i>0', ceil(size(v{1}, 1) / 5));
                            wheel = colorWheel(nPixWheel);
                            
                            for i_frame = 1:T
                                RGB{i_frame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 1) = wheel(:, :, 1);
                                RGB{i_frame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 2) = wheel(:, :, 2);
                                RGB{i_frame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 3) = wheel(:, :, 3);
                            end
                    end
                    
                    % main plotting loop
                    for i_frame = 1:T
                        
                        if(print)
                            % images are printed to .png files
                            inc_res_for_aniso_voxel = checkSetInput(para,'incRes4AnisoVoxel','logical',false);
                            
                            print_para = [];
                            root_filename = checkSetInput(para, 'fileName', 'char', 'MotionField');
                            root_filename = strrep(root_filename, '.png', '');
                            root_filename = strrep(root_filename, '$frame$', int2str(i_frame));
                            
                            print_para.fileName = [root_filename '.png'];
                            if(inc_res_for_aniso_voxel)
                                print_para.printPixPerPix = round([info.dx,info.dy]/min(info.dx,info.dy));
                            end
                            printRGB(RGB{i_frame},print_para);
                        end
                        
                        if(add_frame_id)
                            % add text to identify the frames, in top left corner,
                            % with offset = fontSize (can be extended later)
                            frame_id = ['t=' int2str(i_frame)];
                            RGB{i_frame}     = AddTextToImage(RGB{i_frame},...
                                frame_id, ceil(font_sz/4)*[1 1], [1 0 1], font);
                        end
                    end
                    
                    % generate animated gif before the images is shown
                    if(animated_gif)
                        
                        set(figure_h,'Name','generating animated gif...');
                        animation_para = para;
                        root_filename = checkSetInput(animation_para, 'fileName', 'char', 'motionFieldMovie');
                        root_filename = strrep(root_filename, '.gif', '');
                        root_filename = strrep(root_filename, '_t$frame$', '');
                        root_filename = strrep(root_filename, 't$frame$', '');
                        root_filename = strrep(root_filename, '$frame$', '');
                        animation_para.fileName = root_filename;
                        animation_para.fps = checkSetInput(animation_para, 'fpsMovie', 'double', mean(fps));
                        
                        % call movieFromRGB.m to do the conversion
                        movieFromRGB(RGB, animation_para);
                        
                    end
                    
                    
                    % make axis
                    image(RGB{1}, 'Parent', axis_h);
                    set(axis_h, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                        'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                    imageHandleFly = get(axis_h, 'Children');
                    
                    %%% plotting, the try block will catch an error if the figure is closed
                    %%% before the visulization is finished
                    i_loop = 0;
                    while(i_loop < loop)
                        i_loop = i_loop + 1;
                        for t=1:T
                            tPlotFly = tic;
                            set(imageHandleFly, 'CData', RGB{t});
                            set(figure_h, 'Name', ['motion field, frame = ' int2str(t)]);
                            pause(1/fps(t) - toc(tPlotFly))
                        end
                    end
                    set(imageHandleFly, 'CData', RGB{end_frame});
                    set(figure_h, 'Name', ['reconstruction, frame = ' int2str(end_frame)]);
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

%%% 3D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 3 % dim = 3
        
        type = checkSetInput(para,'type', {'slicePlot'}, 'slicePlot');
        switch type
            case 'slicePlot'
                
                % read out dimension to slice
                dim_slice       = checkSetInput(para, 'dimSlice', 'i,>0', 1);
                dim_vector_comp = setdiff([1,2,3], dim_slice);
                
                % read out which slices to show
                slices2show = checkSetInput(para, 'slices2show', 'i,>0', ceil(size(v,dim_slice)/2));
                
                % prepare slices
                if(~is_dynamic)
                        % get spatial slice
                        v = sliceArray(v, dim_slice, slices2show, true);
                        % take out the in-slice components of the 3D vector field
                        v = sliceArray(v, 3, dim_vector_comp, true);
                else
                    for t=1:length(v)
                        % get spatial slice
                        v{t} = sliceArray(v{t}, dim_slice, slices2show, true);
                        % take out the in-slice components of the 3D vector field
                        v{t} = sliceArray(v{t}, 3, dim_vector_comp, true);
                    end
                end
                
                % plot the resulting 2D vector field 
                info.dim = 2;
                [figure_h, axis_h, RGB] = visualizeMotion(v, info, para);
            otherwise
                notImpErr
        end
end


drawnow();

end