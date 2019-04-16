function im2d = merge1dImages(folder, pattern, mergeDir, mergeFileName, delete1d)
%MERGE1DIMAGES merges a stack of 1d images files into a 2d image file
%
% DESCRIPTION:
%   merge1dImages.m can be used to merge a stack of 1d images files
%   into a 2d image file, e.g., to build a simogram from stack of 1d
%   projections for the single angles
%
% USAGE:
%   im2d = merge1dImages(folder, pattern, mergeDir, mergeFileName, delete1d)
%
% INPUTS:
%   folder  - path to folder
%   pattern - search pattern to find the 1d images files to merge
%   mergeDir      - direction in which the 1d files should be
%                   conecated; 1 or 2 (default)
%   mergeFileName - name of the file in which the 2d images is saved (leave
%                   empty if it should not be safed
%   delete1d      - bool indicating whether the 1d image files should be
%                   deleted after printing
%
% OPTIONAL INPUTS:
%   mergeDir      - direction in which the 1d files should be
%                   conecated; 1 or 2 (default)
%   mergeFileName - name of the file in which the 2d images is saved (leave
%                   empty if it should not be safed, default = [])
%   delete1d      - bool indicating whether the 1d image files should be
%                   deleted after printing (default: false)
%
% OUTPUTS:
%   im2d - the merged 2d image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 27.08.2018
%       last update     - 27.08.2018
%
% See also

% check user defined value for z, otherwise assign default value
if(nargin < 3)
    mergeDir = 2;
end

% check user defined value for mergeFileName, otherwise assign default value
if(nargin < 4)
    mergeFileName = [];
end

% check user defined value for delete1d, otherwise assign default value
if(nargin < 5)
    delete1d = false;
end

% get all files
im1dFiles = dir([folder pattern]);
if(isempty(im1dFiles))
    error(['search for ''' folder pattern ''' did not return any results' ]);
end

% get dimensions of the image data
n   = length(im1dFiles);
ref = imread([folder im1dFiles(1).name]);
if(~isvector(ref))
    error('image data is not a single row or column')
end
m   = length(ref(:));

% assemble image
im2d = zeros(m, n, 'like', ref);

for i = 1:n
    im2d(:, i) = imread([folder im1dFiles(i).name]);
end

% flip direction
if(mergeDir == 1)
    im2d = im2d';
end

if(~isempty(mergeFileName))
    
    % print merged image
    imwrite(im2d, [folder mergeFileName]);
    
    % delete single tif files
    if(delete1d)
        for i = 1:n
            delete([folder im1dFiles(i).name]);
        end
    end
    
end

end