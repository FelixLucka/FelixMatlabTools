function [figureH, axesH, RGB] = flyThroughVolume(im, info, para)
% FLYTHROUGHVOLUME plots a slice-by-slice movie of 3D volumes
%
% USAGE:
%   [figureH, axesH, RGB] = flyThroughVolume(im, info, para)
%   flyThroughVolume(im, info, para)
%
%  INPUTS:
%   im      - a 3D volume
%   info    - a struct summarizing spatial information
%   para - a struct containing optional parameters
%       - see data2RGB.m for all parameters specifiying properties of
%       scaling and color map
%       - see assignOrCreateFigureHandle.m for all parameter specifiying
%       properties of the figure window
%       'dimSlice'    - dimension to slice (1,2 or 3)
%       'fps'         - frames per second
%       'loop'        - number of repetitions (set to Inf for endless
%       repetition)
%       'print' -  a logical indicating whether the slices should be
%       printed to png format
%       'slices2print' - an array of integers indicating which slices to
%       print
%       'rootFilename' - a char specifiying the start of the file name to
%       which the png files are printed
%
%  OUTPUTS:
%   figureH - handle to the figure
%   axesH   - handle to axes
%   RGB     - the projections as a cell of RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 07.12.2018
%
% See also visualizeImage, slicePlot, maxIntensityProjection

% check user defined value for info, otherwise assign default value
if(nargin < 2)
    info = [];
end

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

%%% read inputs and parameter
fps           = checkSetInput(para, 'fps', '>0', 25);
loop          = checkSetInput(para, 'loop', 'i,>0', 1);
dimSlice      = checkSetInput(para, 'dimSlice', 'i,>0', 1);
animatedGif   = checkSetInput(para, 'animatedGif', 'logical', false);

% slice information
szIm         = size(im);
dimNames     = {'X','Y','Z'};
dimSliceName = dimNames{dimSlice};
nSlice       = size(im, dimSlice);

endSlice      = checkSetInput(para, 'endSlice', 'i,>0', round(nSlice/2));
endSlice      = min(nSlice, endSlice);

% get the full RGB
RGB = data2RGB(im, para);
clear im
RGB = num2cell(RGB, setdiff(1:4, dimSlice));
RGB = cellfun(@(x) squeeze(x), RGB, 'UniformOutput', false);

%%% first we print the slices
print = checkSetInput(para, 'print', 'logical', false);
if(print)
    printPara = [];
    
    slices2print = checkSetInput(para, 'slices2print', 'i,>0', 1:szIm(dimSlice));
    rootFilename = checkSetInput(para, 'fileName', 'char', 'volume');
    rootFilename = strrep(rootFilename,'.png','');
    
    incRes4AnisoVoxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
    if(incRes4AnisoVoxel)
        enforceFields(info, 'info', {'dx', 'dy', 'dz'})
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
        integerFormat = ['%0' int2str(1+floor(log10(nSlice))) 'd'];
    else
        integerFormat = '%d';
    end
    
    disp('print the chosen slices to png');
    for iSlice = slices2print
        printPara.fileName = [rootFilename '_slice' dimSliceName ...
            sprintf(integerFormat, iSlice) '.png'];
        printRGB(RGB{iSlice}, printPara);
    end
    
    % overwrite endSlice
    endSlice = slices2print(ceil(length(slices2print)/2));
    
end


% generate animated gif before the images is shown
if(animatedGif)
    animationPara = para;
    fileName = checkSetInput(animationPara,'fileName', 'char', [pwd '/volMovie']);
    animationPara.fileName = strrep(fileName, '.gif', '');
    animationPara.fps      = checkSetInput(animationPara, 'fpsMovie', 'double', fps);
    
    % call movieFromRGB.m to do the conversion
    movieFromRGB(RGB, animationPara);
end



%%% now show the movie
try
    % create figure
    figureH = assignOrCreateFigureHandle(para);
    axesH   = axes('Parent',figureH, 'YTick', zeros(1,0), 'YDir', 'reverse', ...
        'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
    box(axesH,'on'); hold(axesH,'all');
    image(RGB{1},'Parent',axesH);
    ylim(axesH, [0.5, size(RGB{1},1)+0.5]);
    xlim(axesH, [0.5, size(RGB{1},2)+0.5]);
    imageHandleFly = get(axesH, 'Children');
    
    %%% plotting, the try block will catch an error if the figure is closed
    %%% before the visulization is finished
    iloop = 0;
    while(iloop < loop)
        iloop = iloop + 1;
        for iSlice=1:nSlice
            tPlotFly = tic;
            set(imageHandleFly, 'CData', RGB{iSlice});
            set(figureH, 'Name', ['fly through volume, slice ' dimSliceName ' = ' int2str(iSlice)]);
            pause(1/fps - toc(tPlotFly))
        end
    end
    
    set(imageHandleFly, 'CData', RGB{endSlice});
    set(figureH, 'Name', ['fly through volume, slice ' dimSliceName ...
        ' = ' int2str(endSlice)]);
    
catch exception
    switch exception.identifier
        case 'MATLAB:class:InvalidHandle'
            disp('fly through volume movie stopped because the window was closed')
        otherwise
            rethrow(exception)
    end
end

drawnow();

end