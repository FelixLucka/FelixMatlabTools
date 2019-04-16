function RGB = maxIntProHelp(subH, im, dim, titleStr, para)
% MAXINTPROHELP is an auxiliary function to be called by other plotting funtions
%
% DESCRIPTION:
%   TODO
%
% USAGE:
%  RGB = maxIntProHelp(subH,p,dim,titleStr,para)
%
%  INPUTS:
%   subH        - a handle to the sub-axies in which the plot should be placed
%   p           - image
%   dim         - the dimension over which the maximum should be computed
%   titleStr    - a string displayed as the title of the subplot
%   para - a struct containing optional parameters which are all redirected
%   to data2RGB
%
%  OUTPUTS:
%   RGB         - an RGB image (which can be printed by another
%   application)
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also visualizeImage, maxIntensityProjection

im                 = double(im);
imageDataMax       = squeeze(max(im, [], dim));
imageDataMin       = squeeze(min(im, [], dim));
AbsMaxLargerAbsMin = abs(imageDataMax) > abs(imageDataMin);
imageData          = AbsMaxLargerAbsMin.*imageDataMax + not(AbsMaxLargerAbsMin).*imageDataMin;

% call data2RGB to convert max(p,[],dim) to an RGB image
[RGB, ~, ~, cmap] = data2RGB(imageData, para);

% should a mask be on the image?
[mask, bool_df] = checkSetInput(para, 'mask', 'logical', false);
if(~bool_df)
    maskColor  = checkSetInput(para, 'maskColor', 'numeric', [1 0 1]);
    mask       = squeeze(any(mask, dim));
    RGB        = maskRGB(RGB, mask, maskColor);
end


% plot it using image()
if(not(isempty(subH)))
    colormap(subH, cmap);
    image(RGB, 'Parent', subH);
    set(subH, 'YTick', zeros(1, 0), 'YDir', 'reverse',...
              'XTick', zeros(1, 0), 'Layer', 'top', 'DataAspectRatio', [1 1 1])
    title(titleStr);
end

end