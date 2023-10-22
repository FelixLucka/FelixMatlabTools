function [figure_h, axes_h, RGB] = flyThroughVolume(im, info, para)
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
%   figure_h - handle to the figure
%   axes_h   - handle to axes
%   RGB      - the projections as a cell of RGB images
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.10.2023
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
dim_slice      = checkSetInput(para, 'dimSlice', 'i,>0', 1);
if(length(dim_slice) > 1)
    dim_slice = dim_slice(1);
end
animated_gif   = checkSetInput(para, 'animatedGif', 'logical', false);

% slice information
im_sz          = size(im);
dim_names      = {'X','Y','Z'};
dim_slice_name = dim_names{dim_slice};
n_slice        = size(im, dim_slice);

end_slice      = checkSetInput(para, 'endSlice', 'i,>0', round(n_slice/2));
end_slice      = min(n_slice, end_slice);

% get the full RGB
RGB = data2RGB(im, para);
clear im
RGB = num2cell(RGB, setdiff(1:4, dim_slice));
RGB = cellfun(@(x) squeeze(x), RGB, 'UniformOutput', false);

%%% first we print the slices
print = checkSetInput(para, 'print', 'logical', false);
if(print)
    printPara = [];
    
    slices2print = checkSetInput(para, 'slices2print', 'i,>0', 1:im_sz(dim_slice));
    root_filename = checkSetInput(para, 'fileName', 'char', 'volume');
    root_filename = strrep(root_filename,'.png','');
    
    inc_res_4_aniso_voxel = checkSetInput(para, 'incRes4AnisoVoxel', 'logical', false);
    if(inc_res_4_aniso_voxel)
        enforceFields(info, 'info', {'dx', 'dy', 'dz'})
        switch dim_slice
            case 1
                printPara.printPixPerPix = round([info.dy,info.dz]/min(info.dy,info.dz));
            case 2
                printPara.printPixPerPix = round([info.dx,info.dz]/min(info.dx,info.dz));
            case 3
                printPara.printPixPerPix = round([info.dx,info.dy]/min(info.dy,info.dx));
        end
    end
    
    trailing_zeros = checkSetInput(para, 'trailingZeros', 'logical', false);
    if(trailing_zeros)
        integerFormat = ['%0' int2str(1+floor(log10(n_slice))) 'd'];
    else
        integerFormat = '%d';
    end
    
    disp('print the chosen slices to png');
    for iSlice = slices2print
        printPara.fileName = [root_filename '_slice' dim_slice_name ...
            sprintf(integerFormat, iSlice) '.png'];
        printRGB(RGB{iSlice}, printPara);
    end
    
    % overwrite endSlice
    end_slice = slices2print(ceil(length(slices2print)/2));
    
end


% generate animated gif before the images is shown
if(animated_gif)
    animation_para = para;
    filename = checkSetInput(animation_para,'fileName', 'char', [pwd '/volMovie']);
    animation_para.fileName = strrep(filename, '.gif', '');
    animation_para.fps      = checkSetInput(animation_para, 'fpsMovie', 'double', fps);
    
    % call movieFromRGB.m to do the conversion
    movieFromRGB(RGB, animation_para);
end



%%% now show the movie
try
    % create figure
    figure_h = assignOrCreateFigureHandle(para);
    axes_h   = axes('Parent',figure_h, 'YTick', zeros(1,0), 'YDir', 'reverse', ...
        'XTick', zeros(1,0), 'Layer', 'top', 'DataAspectRatio', [1 1 1]);
    box(axes_h,'on'); hold(axes_h,'all');
    image(RGB{1},'Parent',axes_h);
    ylim(axes_h, [0.5, size(RGB{1},1)+0.5]);
    xlim(axes_h, [0.5, size(RGB{1},2)+0.5]);
    imageHandleFly = get(axes_h, 'Children');
    
    %%% plotting, the try block will catch an error if the figure is closed
    %%% before the visulization is finished
    iloop = 0;
    while(iloop < loop)
        iloop = iloop + 1;
        for iSlice=1:n_slice
            tPlotFly = tic;
            set(imageHandleFly, 'CData', RGB{iSlice});
            set(figure_h, 'Name', ['fly through volume, slice ' dim_slice_name ' = ' int2str(iSlice)]);
            pause(1/fps - toc(tPlotFly))
        end
    end
    
    set(imageHandleFly, 'CData', RGB{end_slice});
    set(figure_h, 'Name', ['fly through volume, slice ' dim_slice_name ...
        ' = ' int2str(end_slice)]);
    
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