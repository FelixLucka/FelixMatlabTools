function [figureH, subPlotH, RGB] = slicePlot(im, info, para)
% SLICEPLOT plots the slices of a given 3D volume or a movie
% of a dynamic sequence of 3D volumes
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%  [figureH, RGB] = slicePlot(im, setting, para)
%  slicePlot(p, setting)
%
%  INPUTS:
%   im    - 3D image volume or cell of 3D image volumes
%   info  - a struct containing information about the image geometry
%   para  - a struct containing optional parameters
%       'dimSlice' - dimension to slice (1,2 or 3)
%       'slices2show' - array of slice values to show
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
%   figureH   - handle to the figure
%   subPlotH  - handle to the subplot axis
%   RGB       - the slices views as RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 01.03.2018
%   last update     - 01.03.2018
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
        figureH     = assignOrCreateFigureHandle(para);
        titleFigure = checkSetInput(para, 'title', 'char', 'Slice Views');
        set(figureH, 'Name', titleFigure)
        
        % read out dimension to slice
        dimSlice    = checkSetInput(para, 'dimSlice', 'i,>0', 1);
        % names of the slices
        dimNames     = {'X','Y','Z'};
        dimSliceName = dimNames{dimSlice};
        % read out which slices to show
        slices2show  = checkSetInput(para, 'slices2show', 'i,>0', ...
                                               ceil(size(im, dimSlice)/2));
        nSlices      = length(slices2show);
        
        % prepare slices
        im = sliceArray(im, dimSlice, slices2show, true);
        [RGB, ~, ~, cmap] = data2RGB(im, para);
        if(length(slices2show) > 1)
            RGB = cellfun(@(x) squeeze(x), num2cell(RGB,setdiff(1:4,dimSlice)), ...
                'UniformOutput', false);
        else
            RGB = {squeeze(RGB)};
        end
        
        %%% printing
        print     = checkSetInput(para,'print','logical',false);
        if(print)
            printPara = [];
            rootFilename = checkSetInput(para, 'fileName', 'char', 'recSol');
            rootFilename = strrep(rootFilename, '.png', '');
            
            incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
            if(incRes4AnisoVoxel)
                
                switch dimSlice
                    case 1
                        printPara.printPixPerPix = round([info.dy,info.dz]/min(info.dy,info.dz));
                    case 2
                        printPara.printPixPerPix = round([info.dx,info.dz]/min(info.dx,info.dz));
                    case 3
                        printPara.printPixPerPix = round([info.dx,info.dy]/min(info.dy,info.dx));
                end
            end
            
            
            trailingZeros = checkSetInput(para, 'trailingZeros', 'logical', false);
            if(trailingZeros)
                integerFormat = ['%0' int2str(1+floor(log10(nSlices))) 'd'];
            else
                integerFormat = '%d';
            end
            
            disp('print the desired slices to png');
            for iSlice=1:length(slices2show)
                printPara.fileName = [rootFilename '_slice' dimSliceName ...
                    sprintf(integerFormat, slices2show(iSlice)) '.png'];
                printRGB(squeeze(RGB{iSlice}), printPara);
            end
        end
        
        
        
        %%% plotting
        colPlots = ceil(sqrt(nSlices));
        rowPlots = ceil(nSlices/colPlots);
        for iSlice = 1:nSlices
            subPlotH{iSlice} = subplot(rowPlots, colPlots, iSlice, 'Parent', figureH);
            colormap(subPlotH{iSlice}, cmap);
            image(RGB{iSlice}, 'Parent', subPlotH{iSlice});
            set(subPlotH{iSlice}, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
            title([dimSliceName ' = ' int2str(slices2show(iSlice))]);
        end
        drawnow();
        
    case 'dynamic'
        
        T = length(im);
        
        %%% read inputs and parameter
        fps                = checkSetInput(para, 'fps', '>0', 1);
        loop               = checkSetInput(para, 'loop', 'i,>0', 1);
        print              = checkSetInput(para, 'print', 'logical', false);
        addFrameIdentifier = checkSetInput(para, 'addFrameIdentifier', 'logical', false);
        fontSize           = checkSetInput(para, 'fontSize', 'i,>0', 20);
        animatedGif        = checkSetInput(para, 'animatedGif', 'logical', false);
        endFrame           = min(T, checkSetInput(para,'endFrame', 'i,>0', ceil(T/2)));
        
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
            drawnow();
            
            
            %%% slice  the solutions
            dimSlice     = checkSetInput(para, 'dimSlice', 'i,>0', 1);
            % names of the slices
            dimNames     = {'X', 'Y', 'Z'};
            dimSliceName = dimNames{dimSlice};
            % read out which slices to show
            slices2show  = checkSetInput(para, 'slices2show', 'i,>0', ...
                ceil(size(im{1}, dimSlice)/2));
            nSlices = length(slices2show);
            
            % prepare slices
            for iFrame = 1:T
                im{iFrame} = sliceArray(im{iFrame}, dimSlice, slices2show);
            end
            
            
            %%% first prepare and print all the RGBs
            dynamicScaling = checkSetInput(para, 'dynamicScaling',...
                {'singleFrame', 'allFrames'}, 'singleFrame');
            switch dynamicScaling
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
                        setdiff(1:4, dimSlice)), 'UniformOutput', false);
                else
                    RGB{iFrame} = {squeeze(RGB{iFrame})};
                end
                
                %%% printing
                trailingZeros = checkSetInput(para, 'trailingZeros', 'logical', false);
                if(trailingZeros)
                    integerFormat = ['%0' int2str(1+floor(log10(nSlices))) 'd'];
                else
                    integerFormat = '%d';
                end
                
                if(print)
                    printPara = [];
                    rootFilename = checkSetInput(para,'fileName', 'char', 'recSol_t$frame$');
                    rootFilename = strrep(rootFilename, '.png', '');
                    rootFilename = strrep(rootFilename, '$frame$', int2str(iFrame));
                    
                    incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                    if(incRes4AnisoVoxel)
                        switch dimSlice
                            case 1
                                printPara.printPixPerPix = round([info.dy,info.dz]/min(info.dy,info.dz));
                            case 2
                                printPara.printPixPerPix = round([info.dx,info.dz]/min(info.dx,info.dz));
                            case 3
                                printPara.printPixPerPix = round([info.dx,info.dy]/min(info.dy,info.dx));
                        end
                    end
                    
                    
                    for iSlice=1:length(slices2show)
                        printPara.fileName = [rootFilename '_slice' dimSliceName ...
                            sprintf(integerFormat, slices2show(iSlice)) '.png'];
                        printRGB(squeeze(RGB{iFrame}{iSlice}), printPara);
                    end
                end
                
                if(addFrameIdentifier)
                    % add text to identify the frames, in top left corner,
                    % with offset = fontSize (can be extended later)
                    frameIdentifier = ['t=' int2str(iFrame)];
                    for iSlice=1:length(slices2show)
                        RGB{iFrame}{iSlice} = AddTextToImage(RGB{iFrame}{iSlice},...
                            frameIdentifier, ceil(fontSize/4)*[1 1], [1 0 1], font);
                    end
                end
            end
            
            % generate animated gif before the images is shown
            if(animatedGif)
                set(figureH,'Name','generating animated gif...');
                animationPara = para;
                rootFilename  = checkSetInput(animationPara, 'fileName', ...
                    'char', [pwd '/recSolMovie']);
                rootFilename  = strrep(rootFilename, '.gif','');
                rootFilename  = strrep(rootFilename, '$frame$', '');
                animationPara.fps = checkSetInput(animationPara, 'fpsMovie', 'double', mean(fps));
                
                for iSlice=1:length(slices2show)
                    animationPara.fileName = [rootFilename '_slice' dimSliceName ...
                        sprintf(integerFormat, slices2show(iSlice))];
                    RGBmovie = cell(1, T);
                    for iFrame=1:T
                        RGBmovie{iFrame} = RGB{iFrame}{iSlice};
                    end
                    % call movieFromRGB.m to do the conversion
                    movieFromRGB(RGBmovie, animationPara);
                end
            end
            
            
            %%% make axis
            colPlots = ceil(sqrt(nSlices));
            rowPlots = ceil(nSlices/colPlots);
            for iSlice = 1:nSlices
                subPlotH{iSlice} = subplot(rowPlots, colPlots, iSlice, 'Parent', figureH);
                colormap(subPlotH{iSlice}, cmap);
                image(zeros(size(RGB{iFrame}{iSlice})), 'Parent', subPlotH{iSlice});
                set(subPlotH{iSlice}, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                    'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title([dimSliceName ' = ' int2str(slices2show(iSlice))]);
                imageHandleFly{iSlice} = get(subPlotH{iSlice}, 'Children');
            end
            
            
            
            
            %%% plotting, the try block will catch an error if the figure is closed
            %%% before the visulization is finished
            iloop = 0;
            while(iloop < loop)
                iloop = iloop + 1;
                for t=1:T
                    tPlotFly = tic;
                    for iSlice = 1:nSlices
                        set(imageHandleFly{iSlice}, 'CData', RGB{t}{iSlice});
                    end
                    set(figureH, 'Name', ['Maximum intensity projection, frame = ' int2str(t)]);
                    pause(1/fps(t) - toc(tPlotFly))
                end
            end
            for iSlice = 1:nSlices
                set(imageHandleFly{iSlice}, 'CData', RGB{endFrame}{iSlice});
            end
            set(figureH,'Name',['Maximum intensity projection, frame = ' int2str(endFrame)]);
            
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