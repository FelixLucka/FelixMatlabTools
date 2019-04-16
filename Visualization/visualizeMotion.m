function [figureH, axisH, RGB] = visualizeMotion(v, info, para)
% VISUALIZMOTION plots a dense motion field using color coding of the vectors
%
% DESCRIPTION:
%   visualizeMotion plots a 2D vector field in RGB color coding, .e.g, the
%   direction is indicated by the color and the amplitude by the saturation
%   of it
%
%
% USAGE:
%  [figureH, axisH, RGB] = plotMotion(v,setting,para)
%  plotMotion(v,setting,para)
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
%
%
%  OUTPUTS:
%   figureH - handle to the figure
%   axisH   - handle to the axis
%   RGB     - RGB images to print
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 03.12.2018
%
% See also visualizeImage, addColorFrame, colorWheel


%%% read out parameters common to all dimensions. 
colorVisu    = checkSetInput(para, 'colorVisu', {'none', 'wheel', 'frame'}, 'none');

% figure out whether input is dynamic sequence 
isDynamic = iscell(v);
if(isDynamic)
    dim = nDims(v{1}) - 1;
else
    dim = nDims(v) - 1;
end

para.vector = true;

switch dim
    
%%% 2D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 2
        if(~ isDynamic)
                
                % create figure and axes
                [axisH, figureH] = assignOrCreateAxisHandle(para);
                titleStr = checkSetInput(para, 'title', 'char', 'Motion Field');
                
                % print figure?
                print = checkSetInput(para, 'print', 'logical', false);
                if(print)
                    % additional parameters
                    printPara    = [];
                    rootFilename = checkSetInput(para, 'fileName', 'char', 'motionField');
                    rootFilename = strrep(rootFilename, '.png', '');
                end
                
                % convert v to RGB image
                [RGB, ~, ~, cmap] = data2RGB(v, para);
                
                % add mask to image?
                [mask, dfMask] = checkSetInput(para, 'mask', 'logical', false);
                if(~ dfMask)
                    maskColor     = checkSetInput(para,'maskColor','numeric',[0 0 0]);
                    maskThickness = checkSetInput(para,'maskThickness','i,>0',1);
                    if(maskThickness > 1)
                        NH = radialNeighbourhood(maskThickness, 2);
                        mask = imdilate(mask, NH);
                    end
                    RGB = maskRGB(RGB, mask, maskColor);
                end
                
                % add color frame or wheel to indicate directions
                switch colorVisu
                    case 'frame'
                        frameThickness = checkSetInput(para, 'frameThickness', ...
                            'i>0', ceil(size(v, 1) / 20));
                        RGB = addColorFrame(RGB, frameThickness);
                    case 'wheel'
                        nPixWheel = checkSetInput(para, 'nPixelWheel', ...
                            'i>0', ceil(size(v, 1) / 5));
                        wheel = colorWheel(nPixWheel);
                        
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 1) = wheel(:, :, 1);
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 2) = wheel(:, :, 2);
                        RGB(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 3) = wheel(:, :, 3);
                end
                
                % plot it using image()
                colormap(axisH, cmap);
                image(RGB, 'Parent', axisH);
                set(axisH, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                    'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title(titleStr);
                
                % print image?
                if(print)
                    printPara.fileName = [rootFilename '.png'];
                    printRGB(RGB, printPara);
                end
                
        else % dynamic imaging
                
                T = length(v);
                
                %%% read inputs and parameter
                fps         = checkSetInput(para, 'fps', '>0', 1);
                loop        = checkSetInput(para, 'loop', 'i,>0', 1);
                print       = checkSetInput(para, 'print', 'logical', false);
                addFrameId  = checkSetInput(para, 'addFrameId', 'logical', false);
                fontSize    = checkSetInput(para, 'fontSize', 'i,>0', 20);
                animatedGif = checkSetInput(para, 'animatedGif', 'logical', false);
                endFrame    = checkSetInput(para, 'endFrame', 'i,>0', floor(T/2));
                endFrame    = max(1, min(T, endFrame));
                
                % add a string that identifies the frame number
                if(addFrameId)
                    font = BitmapFont('Arial', fontSize, 't=1234567890');
                end
                
                % extend fps to vector
                if(length(fps) == 1)
                    fps = fps * ones(T,1);
                end
                
                % try loop determines function without error if user closes the window
                try
                    
                    [axisH, figureH] = assignOrCreateAxisHandle(para);
                    set(figureH, 'Name', 'preparing RGB data...');
                    
                    % first prepare and print all the RGBs
                    RGB = data2RGB(v, para);
                    
                    
                    % add mask to images?
                    [mask, dfMask] = checkSetInput(para, 'mask', 'mixed', false);
                    if(~ dfMask)
                        maskColor     = checkSetInput(para,'maskColor','numeric',[0 0 0]);
                        maskThickness = checkSetInput(para,'maskThickness','i,>0',1);
                        NH = radialNeighbourhood(maskThickness, 2);
                        if(~ iscell(mask))
                            mask = repIntoCell(mask, [1,T]);
                        end
                        for iFrame=1:T
                            if(maskThickness > 1)
                                mask{iFrame} = imdilate(mask{iFrame}, NH);
                            end
                            RGB{iFrame} = maskRGB(RGB{iFrame}, mask{iFrame}, maskColor);
                        end
                    end
                    
                    % add color frame or wheel to indicate directions
                    switch colorVisu
                        case 'frame'
                            frameThickness = checkSetInput(para, 'frameThickness', ...
                                'i>0', ceil(size(v{1},1)/20));
                            for iFrame = 1:T
                                RGB{iFrame} = addColorFrame(RGB{iFrame}, frameThickness);
                            end
                        case 'wheel'
                            nPixWheel = checkSetInput(para, 'nPixelWheel', ...
                                'i>0', ceil(size(v{1}, 1) / 5));
                            wheel = colorWheel(nPixWheel);
                            
                            for iFrame = 1:T
                                RGB{iFrame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 1) = wheel(:, :, 1);
                                RGB{iFrame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 2) = wheel(:, :, 2);
                                RGB{iFrame}(end-(nPixWheel-1):end, end-(nPixWheel-1):end, 3) = wheel(:, :, 3);
                            end
                    end
                    
                    % main plotting loop
                    for iFrame = 1:T
                        
                        if(print)
                            % images are printed to .png files
                            incRes4AnisoVoxel = checkSetInput(para,'incRes4AnisoVoxel','logical',false);
                            
                            printPara = [];
                            rootFilename = checkSetInput(para, 'fileName', 'char', 'MotionField');
                            rootFilename = strrep(rootFilename, '.png', '');
                            rootFilename = strrep(rootFilename, '$frame$', int2str(iFrame));
                            
                            printPara.fileName = [rootFilename '.png'];
                            if(incRes4AnisoVoxel)
                                printPara.printPixPerPix = round([info.dx,info.dy]/min(info.dx,info.dy));
                            end
                            printRGB(RGB{iFrame},printPara);
                        end
                        
                        if(addFrameId)
                            % add text to identify the frames, in top left corner,
                            % with offset = fontSize (can be extended later)
                            frameIdentifier = ['t=' int2str(iFrame)];
                            RGB{iFrame}     = AddTextToImage(RGB{iFrame},...
                                frameIdentifier, ceil(fontSize/4)*[1 1], [1 0 1], font);
                        end
                    end
                    
                    % generate animated gif before the images is shown
                    if(animatedGif)
                        
                        set(figureH,'Name','generating animated gif...');
                        animationPara = para;
                        rootFilename = checkSetInput(animationPara, 'fileName', 'char', 'motionFieldMovie');
                        rootFilename = strrep(rootFilename, '.gif', '');
                        rootFilename = strrep(rootFilename, '_t$frame$', '');
                        rootFilename = strrep(rootFilename, 't$frame$', '');
                        rootFilename = strrep(rootFilename, '$frame$', '');
                        animationPara.fileName = rootFilename;
                        animationPara.fps = checkSetInput(animationPara, 'fpsMovie', 'double', mean(fps));
                        
                        % call movieFromRGB.m to do the conversion
                        movieFromRGB(RGB, animationPara);
                        
                    end
                    
                    
                    % make axis
                    image(RGB{1}, 'Parent', axisH);
                    set(axisH, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                        'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                    imageHandleFly = get(axisH, 'Children');
                    
                    %%% plotting, the try block will catch an error if the figure is closed
                    %%% before the visulization is finished
                    iloop = 0;
                    while(iloop < loop)
                        iloop = iloop + 1;
                        for t=1:T
                            tPlotFly = tic;
                            set(imageHandleFly, 'CData', RGB{t});
                            set(figureH, 'Name', ['motion field, frame = ' int2str(t)]);
                            pause(1/fps(t) - toc(tPlotFly))
                        end
                    end
                    set(imageHandleFly, 'CData', RGB{endFrame});
                    set(figureH, 'Name', ['reconstruction, frame = ' int2str(endFrame)]);
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
                dimSlice      = checkSetInput(para, 'dimSlice', 'i,>0', 1);
                dimVectorComp = setdiff([1,2,3], dimSlice);
                
                % read out which slices to show
                slices2show = checkSetInput(para, 'slices2show', 'i,>0', ceil(size(v,dimSlice)/2));
                
                % prepare slices
                if(~isDynamic)
                        % get spatial slice
                        v = sliceArray(v, dimSlice, slices2show, true);
                        % take out the in-slice components of the 3D vector field
                        v = sliceArray(v, 3, dimVectorComp, true);
                else
                    for t=1:length(v)
                        % get spatial slice
                        v{t} = sliceArray(v{t}, dimSlice, slices2show, true);
                        % take out the in-slice components of the 3D vector field
                        v{t} = sliceArray(v{t}, 3, dimVectorComp, true);
                    end
                end
                
                % plot the resulting 2D vector field 
                info.dim = 2;
                [figureH, axisH, RGB] = visualizeMotion(v, info, para);
            otherwise
                notImpErr
        end
end


drawnow();

end