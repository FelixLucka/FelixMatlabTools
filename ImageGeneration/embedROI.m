function image = embedROI(image_roi, roi, bgd_val)
%EMBEDROI embeds a vector of pixel/voxel values of a region of interest (ROI)
%into an image/volume
%
% DESCRIPTION:
%       embedROI embeds a vector of pixel/voxel values into a region of 
%       interest (ROI) within an image/volume
%
% USAGE:
%       image = embedROI(image_roi, roi, bgd_val)
%
% INPUTS:
%       image_roi - vector of image values in the ROI
%       roi       - binary mask showing the ROI
%
% OPTIONAL INPUTS:
%       bgd_val - value that will be assigned to all non-ROI voxels 
%
% OUTPUTS:
%       image - an image in the format of the ROI mask
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 16.06.2018
%       last update     - 29.09.2023
%
% See also constructROI

if(nargin < 3)
    bgd_val = 0;
end

image      = bgd_val * ones(size(roi));
image(roi) = image_roi;

end