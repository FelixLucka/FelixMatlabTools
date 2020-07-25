function [figureH, axisH, RGB, clim, scaling] = visualizeImage(im, info, para)
% VISUALIZEIMAGE plots a 2D or 3D image or movie 
%
% DESCRIPTION:
%   visualizeImage is a meta image visulization routine that can be used to
%   plot 2D images or 3D volumes or movies in various ways
%
% USAGE:
%   visualizeImage(x)
%   [figureH, ~, RGB] = visualizeImage(x, setting)
%   [figureH, axisH, RGB] = visualizeImage(x, setting)
%
%  INPUTS:
%   im - 2D, 3D or 4D array
%   info - a struct comprising information about the image that might be
%          acessed by the sub-function
%   para - a struct containing optional parameters
%       - para will be forwarded to assignOrCreateAxisHandle.m to create a
%       figure and axes, see the corresponding documentation for options
%       'blankMask'   - a logical mask of values that will be set to blankValue
%                       before any other operations are performed
%       'blankValue'  - see above
%       'clipIndizes' - a 2x2 or 3x2 array containg start and end indices of 
%                     region of interest to which the image is croped b
%                     before going into sub-function
%       'titleStr'  - a char containing the title of the figure
%       'print'     - a logical indicating whether the plots should be
%                     printed to *.png's
%       'fileName'  - prefix of the png filename if printing is desired
%       'type'      - different types of plotting for 3D, 'maxIntensity',
%                     'slicePlot' or 'flyThrough' (static images only)
%
%  OUTPUTS:
%   figureH - handle to the figure
%   axisH   - handle to the axis
%   RGB     - RGB images to print
%
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 15.03.2017
%   last update     - 19.06.2018
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
[blankMask, dontBlank] = checkSetInput(para, 'blankMask', 'logical', 0);
if(~dontBlank)
    
    blankValue = checkSetInput(para, 'blankValue', 'numeric', 0);
    % blank image
    blankFun = @(im) double(not(blankMask)) .* im + blankValue .* double(blankMask);
    im       = applyToMatOrCell(blankFun, im);
    
end

% clip images
[cInd, clip] = checkSetInput(para, 'clipIndizes', 'i,>0', 0);
clip = ~clip;
if(clip)
    
    % crop image
    switch dim
        case 2
            clipFun = @(im) im(cInd(1, 1):cInd(1, 2), cInd(2, 1):cInd(2, 2));
        case 3
            clipFun = @(im) im(cInd(1, 1):cInd(1, 2), cInd(2, 1):cInd(2, 2), cInd(3, 1):cInd(3, 2));
    end
    im      = applyToMatOrCell(clipFun, im);
    
    % adjust slices if slices are chosen
    if(isfield(para, 'slices2show'))
        switch para.dimSlice
            case 1
                para.slices2show = para.slices2show - (cInd(1, 1) - 1);
            case 2
                para.slices2show = para.slices2show - (cInd(2, 1) - 1);
            case 3
                para.slices2show = para.slices2show - (cInd(3, 1) - 1);
        end
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
                [axisH, figureH] = assignOrCreateAxisHandle(para);
                titleStr = checkSetInput(para, 'title', 'char', '');
                
                % print figure?
                print = checkSetInput(para, 'print', 'logical', false);
                if(print)
                    % additional parameters
                    printPara = [];
                    rootFilename = checkSetInput(para, 'fileName', 'char', 'recSol');
                    rootFilename = strrep(rootFilename,'.png', '');
                end 
                
                % convert p to RGB image
                [RGB, clim, scaling, cmap] = data2RGB(im, para);
                
                % add sensor mask to image?
                [RGBMask noMask] = checkSetInput(para,'RGBMask', 'mixed', false);
                if(~noMask)
                    maskColor = checkSetInput(para, 'maskColor', 'mixed', [1 0 1]);   
                    if(~iscell(RGBMask))
                        RGBMask   = {RGBMask};
                        maskColor = {maskColor};
                    end
                    for iMask = 1:length(RGBMask)
                        RGB = maskRGB(RGB, RGBMask{iMask}, maskColor{iMask});
                    end
                end
                
                % plot it using image()
                colormap(axisH, cmap);
                image(RGB, 'Parent', axisH);
                set(axisH, 'YTick', zeros(1,0), 'YDir', 'reverse','XTick', ...
                    zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
                title(titleStr);
                
                % print image?
                if(print)
                    printPara.fileName = [rootFilename '.png'];
                    printRGB(RGB,printPara);
                end
                
        else % ~dynamic
            
                T = length(im);
                
                type = checkSetInput(para,'type',{'movie', 'colorPlot'}, 'movie');
                
                switch type
                    
                    case 'movie'
                        
                        %%% read inputs and parameter
                        fps         = checkSetInput(para, 'fps', '>0', 1);
                        loop        = checkSetInput(para, 'loop', 'i,>0', 1);
                        print       = checkSetInput(para, 'print', 'logical', false);
                        addFrameId  = checkSetInput(para, 'addFrameId', 'logical', false);
                        fontSize    = checkSetInput(para, 'fontSize', 'i,>0', 20);
                        animatedGif = checkSetInput(para, 'animatedGif', 'logical', false);
                        endFrame    = checkSetInput(para, 'endFrame','i,>0', floor(T/2));
                        endFrame    = max(1, min(T, endFrame));
                        
                        [RGBMask noMask] = checkSetInput(para, 'RGBMask', 'cell', false);
                        maskColor        = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
                        
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
                            
                            %%% prepare and print all the RGBs
                            
                            [RGB, clim, scaling] = data2RGB(im,para);
                            clear im
                            
                            for iFrame = 1:T
                                
                                % add mask?
                                if(~noMask)
                                    RGB{iFrame} = maskRGB(RGB{iFrame}, RGBMask{iFrame}, maskColor);
                                end
                            
                                if(print)
                                    % images are printed to .png files
                                    incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
                                    
                                    printPara = [];
                                    rootFilename = checkSetInput(para,'fileName','char','image');
                                    rootFilename = strrep(rootFilename,'.png','');
                                    rootFilename = strrep(rootFilename, '$frame$', int2str(iFrame));
                                    
                                    printPara.fileName = [rootFilename '.png'];
                                    if(incRes4AnisoVoxel)
                                        printPara.printPixPerPix = round([info.dx,info.dy]/min(info.dx,info.dy));
                                    end
                                    printRGB(RGB{iFrame}, printPara);
                                end
                                
                                if(addFrameId)
                                    % add text to identify the frames, in top left corner,
                                    % with offset = fontSize (can be extended later)
                                    frameIdentifier = ['t=' int2str(iFrame)];
                                    RGB{1,iFrame} = AddTextToImage(RGB{iFrame},...
                                        frameIdentifier, ceil(fontSize/4)*[1 1], [1 0 1], font);
                                end
                            end
                            
                            % generate animated gif before the images is shown
                            if(animatedGif)
                                set(figureH,'Name','generating animated gif...');
                                animationPara = para;
                                rootFilename = checkSetInput(animationPara,...
                                    'fileName', 'char', 'maxIntensityProMovie');
                                rootFilename = strrep(rootFilename, '.gif','');
                                rootFilename = strrep(rootFilename, '_t$frame$', '');
                                rootFilename = strrep(rootFilename, 't$frame$', '');
                                rootFilename = strrep(rootFilename, '$frame$', '');
                                animationPara.fileName = rootFilename;
                                animationPara.fps = checkSetInput(animationPara,...
                                    'fpsMovie', 'double', mean(fps));
                                
                                % call movieFromRGB.m to do the conversion
                                movieFromRGB(RGB, animationPara);
                            end
                            
                            
                            % to make axis
                            image(RGB{1},'Parent',axisH);
                            set(axisH,'YTick',zeros(1,0),'YDir','reverse',...
                                'XTick',zeros(1,0),'Layer','top','DataAspectRatio',[1 1 1])
                            imageHandleFly = get(axisH,'Children');
                            
                            %%% plotting, the try block will catch an error if the figure is closed
                            %%% before the visulization is finished
                            iloop = 0;
                            while(iloop < loop)
                                iloop = iloop + 1;
                                for t=1:T
                                    tPlotFly = tic;
                                    set(imageHandleFly,'CData', RGB{t});
                                    set(figureH,'Name', ['reconstruction, frame = ' int2str(t)]);
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
                        
                    case 'colorPlot'
                        
                        % create figure and axes
                        [axisH, figureH] = assignOrCreateAxisHandle(para);
                        titleStr = checkSetInput(para, 'title', 'char', '');
                        [RGBMask, noMask] = checkSetInput(para, 'RGBMask', 'logical', false);
                        maskColor         = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
                        
                        % print figure?
                        print = checkSetInput(para, 'print', 'logical', false);
                        if(print)
                            % additional parameters
                            printPara = [];
                            rootFilename = checkSetInput(para, 'fileName', 'char', 'recSol');
                            rootFilename = strrep(rootFilename, '.png', '');
                        end
                        
                        alphaMerge = checkSetInput(para, 'alphaMerge', 'numeric', 0.5);
                        visuThres  = checkSetInput(para, 'visuThres', 'double', 0.1);

                        size_p = size(im{1});
                        RGB    = ones([size_p, 3]);
                        max_p  = max(vec(cell2mat(im)));
                        min_p  = min(vec(cell2mat(im)));
                        
                        if(min_p < 0)
                            error('negative intensities')
                        end
                        
                        for t=1:T
                            colors = hsv2rgb([t/T * ones(prod(size_p), 1), ...
                                im{t}(:)/max_p, ones(prod(size_p), 1)]);
                            R      = reshape(colors(:, 1), size_p);
                            G      = reshape(colors(:, 2), size_p);
                            B      = reshape(colors(:, 3), size_p);
                            RGB_t  = cat(ndims(R)+1, R, G, B);
                            
                            alphaMask = alphaMerge * ((im{t}/max_p) > visuThres);
                            RGB = (bsxfun(@times, alphaMask, RGB_t) + ...
                                bsxfun(@times, (1-alphaMask), RGB));
                        end
                        clear im
                        
                        % add RGB mask to image?
                        if(~noMask)
                            RGB = maskRGB(RGB, RGBMask, maskColor);
                        end
                
                        % plot it using image()
                        image(RGB, 'Parent', axisH);
                        set(axisH, 'YTick', zeros(1,0), 'YDir', 'reverse',...
                            'XTick', zeros(1,0), 'Layer', 'top', ...
                            'DataAspectRatio',[1 1 1])
                        title(titleStr);
                        
                        % print image?
                        if(print)
                            printPara.fileName = [rootFilename '.png'];
                            printRGB(RGB, printPara);
                        end
                end % switch type 
        end % if(~dynamic), else branch
        
    case 3
        
        % =================================================================
        % 3D VISULIZATION
        % =================================================================
        
        axisH = [];
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
                [figureH, RGB] = maxIntensityProjection(im, info, para);
            case 'flyThrough'
                [figureH, axisH, RGB] = flyThroughVolume(im, info, para);
            case 'slicePlot'
                [figureH, axisH, RGB] = slicePlot(im, info, para);
        end
        
end


% update figures and process callbacks
drawnow();


end