function [figureH, RGB] = maxIntensityProjection(im, info, para)
% MAXINTENSITYPROJECTION plots the maximum intensity projections of a given
% 3D volume or of a sequece of 3D volumes image as a movie
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%   [figureH, RGB] = maxIntensityProjection(p,setting,para)
%   maxIntensityProjection(p,setting)
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
%   figureH           - handle to the figure
%   RGB               - the projections as a cell of RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
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
    
    figureH = assignOrCreateFigureHandle(para);
    
    title = checkSetInput(para, 'title', 'char', 'Maximum Intensity Projection');
    set(figureH, 'Name', title);
    
    % maximum intensity projection in X direction
    subX   = subplot(1, 3, 1, 'Parent', figureH);
    RGB{1} = maxIntProHelp(subX, im, 1, 'X', para);
    
    % maximum intensity projection in Y direction
    subY   = subplot(1, 3, 2, 'Parent', figureH);
    RGB{2} = maxIntProHelp(subY, im, 2, 'Y', para);
    
    % maximum intensity projection in Z direction
    subZ   = subplot(1, 3, 3, 'Parent', figureH);
    RGB{3} = maxIntProHelp(subZ, im, 3, 'Z', para);
    
    print = checkSetInput(para,'print', 'logical', false);
    if(print)
        
        % images are printed to .png files
        incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
        
        printPara    = [];
        rootFilename = checkSetInput(para, 'fileName', 'char', 'maxIntensityPro');
        rootFilename = strrep(rootFilename,'.png','');
        
        printPara.fileName = [rootFilename '_mIX.png'];
        if(incRes4AnisoVoxel)
            printPara.printPixPerPix = round([info.dy, info.dz] / min(info.dy, info.dz));
        end
        printRGB(RGB{1}, printPara);
        
        printPara.fileName = [rootFilename '_mIY.png'];
        if(incRes4AnisoVoxel)
            printPara.printPixPerPix = round([info.dx, info.dz] / min(info.dx, info.dz));
        end
        printRGB(RGB{2}, printPara);
        
        printPara.fileName = [rootFilename '_mIZ.png'];
        if(incRes4AnisoVoxel)
            printPara.printPixPerPix = round([info.dx, info.dy] / min(info.dx, info.dy));
        end
        printRGB(RGB{3}, printPara);
    end
    
    drawnow();
    
else
    
    %%% dynamic visulization
    
    T = length(im);
    
    %%% read inputs and parameter
    fps                = checkSetInput(para, 'fps', '>0', 1);
    loop               = checkSetInput(para, 'loop', 'i,>0', 1);
    print              = checkSetInput(para, 'print', 'logical', false);
    addFrameIdentifier = checkSetInput(para, 'addFrameIdentifier', 'logical', false);
    fontSize           = checkSetInput(para, 'fontSize', 'i,>0', 20);
    animatedGif        = checkSetInput(para, 'animatedGif', 'logical', false);
    endFrame           = checkSetInput(para, 'endFrame', 'i,>0', T);
    endFrame           = min(T, endFrame);
    
    % add a string that identifies the frame number
    if(addFrameIdentifier)
        font = BitmapFont('Arial', fontSize, 't=1234567890');
    end
    
    % extend fps to vector
    if(length(fps) == 1)
        fps = fps * ones(T,1);
    end
    
    
    % try loop determines function without error if user closes the window
    try
        
        figureH = assignOrCreateFigureHandle(para);
        set(figureH, 'Name', 'preparing RGB data...');
        
        %%% first prepare and print all the RGBs
        dynamicScaling = checkSetInput(para, 'dynamicScaling', {'singleFrame', 'allFrames'}, 'singleFrame');
        switch dynamicScaling
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
                incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                if(incRes4AnisoVoxel)
                    enforceFields(info, 'info', {'dx', 'dy', 'dz'})
                end
                
                printPara = [];
                rootFilename = checkSetInput(para, 'fileName', 'char', 'maxIntensityPro');
                rootFilename = strrep(rootFilename,'.png','');
                rootFilename = strrep(rootFilename, '$frame$', int2str(i_T));
                
                printPara.fileName = [rootFilename '_mIX.png'];
                if(incRes4AnisoVoxel)
                    printPara.printPixPerPix = round([info.dy, info.dz] / min(info.dy, info.dz));
                end
                printRGB(RGB{1, i_T}, printPara);
                
                printPara.fileName = [rootFilename '_mIY.png'];
                if(incRes4AnisoVoxel)
                    printPara.printPixPerPix = round([info.dx, info.dz] / min(info.dx, info.dz));
                end
                printRGB(RGB{2, i_T}, printPara);
                
                printPara.fileName = [rootFilename '_mIZ.png'];
                if(incRes4AnisoVoxel)
                    printPara.printPixPerPix = round([info.dx, info.dy] / min(info.dx, info.dy));
                end
                printRGB(RGB{3, i_T}, printPara);
            end
            
            if(addFrameIdentifier)
                % add text to identify the frames, in top left corner,
                % with offset = fontSize (can be extended later)
                frameIdentifier = ['t=' int2str(i_T)];
                RGB{1, i_T} = AddTextToImage(RGB{1, i_T}, frameIdentifier, ceil(fontSize/4)*[1 1], [1 0 1], font);
            end
        end
        
        % generate animated gif before the images is shown
        if(animatedGif)
            
            set(figureH, 'Name', 'generating animated gif...');
            animationPara = para;
            rootFilename  = checkSetInput(animationPara, 'fileName', 'char', 'maxIntensityProMovie');
            rootFilename  = strrep(rootFilename, '.gif', '');
            rootFilename  = strrep(rootFilename, '$frame$', '');
            animationPara.fileName = [rootFilename '_mI'];
            animationPara.fps = checkSetInput(animationPara, 'fpsMovie', 'double', mean(fps));
            
            RGBmovie = cell(1, T);
            gapColor = checkSetInput(para, 'gapColor', 'double', [0 0 0]);
            gapWidth = checkSetInput(para, 'gapWidth', 'i,>0', 10);
            
            lengthVert = max([size(RGB{1, 1}, 2), size(RGB{2, 1}, 2), size(RGB{3, 1}, 2)]);
            fillVert   = ones(gapWidth, lengthVert);
            fillVert   = cat(3, gapColor(1) * fillVert, gapColor(2) * fillVert, gapColor(3) * fillVert);
            for iDim = 1:3
                fillHorz{iDim} = ones(size(RGB{iDim, 1}, 1), lengthVert-size(RGB{iDim, 1}, 2));
                fillHorz{iDim} = cat(3, gapColor(1) * fillHorz{iDim}, gapColor(2) * fillHorz{iDim}, gapColor(3) * fillHorz{iDim});
            end
            for i_T = 1:T
                RGBmovie{i_T} = cat(1, cat(2, RGB{1,i_T}, fillHorz{1}),...
                    fillVert, cat(2, RGB{2, i_T}, fillHorz{2}),...
                    fillVert, cat(2, RGB{3, i_T}, fillHorz{3}));
            end
            
            % call movieFromRGB.m to do the conversion
            movieFromRGB(RGBmovie, animationPara);
            
        end
        
        
        %%% create  axis
        axesXH = subplot(1, 3, 1, 'Parent', figureH, 'YTick', zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axesXH, 'on'); hold(axesXH, 'all');
        image(zeros(size(RGB{1, 1})), 'Parent', axesXH);
        ylim(axesXH, [0.5, size(RGB{1, 1}, 1) + 0.5]); 
        xlim(axesXH, [0.5, size(RGB{1, 1}, 2) + 0.5]);
        imageHandleFly{1} = get(axesXH, 'Children');
        ylabel('y'); xlabel('z');
        axesXH.Title.String = 'X projection';
        
        axesYH = subplot(1, 3, 2, 'Parent', figureH, 'YTick', zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axesYH,'on'); hold(axesYH, 'all');
        image(zeros(size(RGB{2, 1})), 'Parent', axesYH);
        ylim(axesYH, [0.5, size(RGB{2, 1}, 1) + 0.5]); 
        xlim(axesYH, [0.5, size(RGB{2, 1}, 2) + 0.5]);
        imageHandleFly{2} = get(axesYH, 'Children');
        ylabel('x'); xlabel('z');
        axesYH.Title.String = 'Y projection';
        
        axesZH = subplot(1, 3, 3,'Parent', figureH, 'YTick',zeros(1, 0), ...
            'YDir', 'reverse', 'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
        box(axesZH, 'on'); hold(axesZH, 'all');
        image(zeros(size(RGB{3, 1})), 'Parent', axesZH);
        ylim(axesZH, [0.5, size(RGB{3, 1}, 1) + 0.5]); 
        xlim(axesZH, [0.5, size(RGB{3, 1}, 2) + 0.5]);
        imageHandleFly{3} = get(axesZH, 'Children');
        ylabel('x'); xlabel('y');
        axesZH.Title.String = 'Z projection';
        
        
        %%% plotting, the try block will catch an error if the figure is closed
        %%% before the visulization is finished
        i_loop = 0;
        while(i_loop < loop)
            i_loop = i_loop + 1;
            for i_T = 1:T
                tPlotFly = tic;
                for i_pl = 1:length(imageHandleFly)
                    set(imageHandleFly{i_pl}, 'CData', RGB{i_pl, i_T});
                end
                set(figureH, 'Name', ['Maximum intensity projection, frame = ' int2str(i_T)]);
                pause(1/fps(i_T) - toc(tPlotFly))
            end
        end
        for i_pl = 1:length(imageHandleFly)
            set(imageHandleFly{i_pl}, 'CData', RGB{i_pl, endFrame});
        end
        set(figureH, 'Name', ['Maximum intensity projection, frame = ' int2str(endFrame)]);
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