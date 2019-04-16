function image = embedROI(imageROI, ROI, bgdVal)
%EMBEDROI embeds a vector of pixel/voxel values of a region of interest (ROI)
%into an image/volume
%
% DESCRIPTION:
%       embedROI embeds a vector of pixel/voxel values into a region of 
%       interest (ROI) within an image/volume
%
% USAGE:
%       image = embedROI(imageROI, ROI, bgdVal)
%
% INPUTS:
%       imageROI - vector of image values in the ROI
%       ROI      - binary mask showing the ROI
%
% OPTIONAL INPUTS:
%       bgdVal - value that will be assigned to all non-ROI voxels 
%
% OUTPUTS:
%       image - an image in the format of the ROI mask
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 16.06.2018
%       last update     - 16.06.2018
%
% See also constructROI

if(nargin < 3)
    bgdVal = 0;
end

image      = bgdVal * ones(size(ROI));
image(ROI) = imageROI;

end