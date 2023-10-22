function im = processImage(im, para)
%PROCESSIMAGE implements a series of image processing operations
%
% DETAILS: 
%   processImage.m is a collection of routines that I use or used for
%   simple post-processing of reconstructed images
%
% USAGE:
%   im = processImage(im, para)
%
% INPUTS:
%   im   - image to process
%   para - a struct containing further optional parameters determining if
%   and how processing will be performed. In the following, they are
%   described in the order that the processing takes place
%       'nonNeg' - bool indicating whether negative image intensities
%           should be set to 0
%       'threshold' - fraction of the maximal absolute value. If > 0, all
%           image intensities with absolute value below threshold *
%           max(abs(im(:)) will be set to 0
%       'cc_comp' - fraction of how connected compontents to remove: The
%           image is decomposed into connected components (this requires
%           thresholding to have boundaries between objects). Then, the
%           smallest of those are removed.
%       
%        
%
% OUTPUTS:
%   im - processed image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.12.2021
%       last update     - 13.10.2023
%
% See also

dim = ndims(im);

%%% clip negative parts?
non_neg = checkSetInput(para, 'nonNeg', 'logical', false);
if(non_neg)
   im = max(0, im); 
end

%%% threshold image values? (relative threshold)
threshold = checkSetInput(para, 'threshold', '>=0', 0);
if(threshold > 0)
   im = (abs(im) > threshold * max(abs(im(:)))) .* im;
end

%%% threshold small connected components
cc_comp = checkSetInput(para, 'ccComp', '>=0', 0);
if(cc_comp > 0)
    im_mask        = im > 0;
    n_active_voxel = nnz(im_mask);
    switch dim
        case 2
            cc = bwconncomp(im_mask, 8);
        case 3
            cc = bwconncomp(im_mask, 26);
    end
    [~,ind] = sort(cellfun(@(x) length(x), cc.PixelIdxList), 'descend');
    im_mask = false(size(im));
    if(cc_comp < 1) % threshold based on a percentage of voxels to keep
        i_cc = 1;
        while(nnz(im_mask) < (1-cc_comp) * n_active_voxel)
            im_mask(cc.PixelIdxList{ind(i_cc)}) = true;
            i_cc = i_cc + 1;
        end
    else % get the k largest clusters
        for iComp=1:cc_comp
            im_mask(cc.PixelIdxList{ind(iComp)}) = true;
        end
    end
    im = im .* im_mask;
end


end