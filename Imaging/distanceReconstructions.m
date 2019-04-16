function [dist, thresholds] = distanceReconstructions(im1, im2, para)
% DISTANCERECONSTRUCTIONS computes different distance measure between two input
% images
% 
%  DESCRIPTION: 
%   distanceReconstructions.m computes different distance metrics between 
%   the thresholded versions of two images:  
%   mean squared error (MSE), relative H1 error, peak 
%   signal-to-noise-ratio (PSNR) and strucutre similarity index (SSIM)
%
%  USAGE:
%   [dist, thresholds] = distanceReconstructions(im1, im2, para)
%   dist               = distanceReconstructions(p1,p2,para)
%
%
%  INPUTS:
%   im1         - first  image as array or cell (for dynamic imaging)
%   im2         - second image as array or cell (for dynamic imaging)
%                   case)
%   para - a struct containing optional parameters
%       'normalize'  - a logical indicating whether both pressre
%                        distributions should be normalized (default: true)
%       'dynamicMode'  - for the dynamic case, the error measures are first
%                        computed frame-by-frame. Then, for dynamicMode =
%                        'mean', only the mean is returned, for
%                        'meanMinMax' also min and max and for 'all' a
%                        vector with the frame-by-frame results
%       'normalizationNorm' - norm that is used for normalizing
%       'errorMeasures' - a cell containing the names of the error measures
%                         that are computed. Currently, mean-squared error
%                         ('MSE'), relative H1 error ('relH1'),
%                         peak signal-to-noise-ratio ('PSNR') and structure
%                         strucutre similarity index ('SSIM') are
%                         supported.
%       'thresholds'    - an array with thresholds. For each threshold, p1 and p2 are thresholded
%                         and all error measures are computed for the
%                         thresholded images
%
%  OUTPUTS:
%   dist        - cell containing the error values for all measures and
%                 thresholds. For dynamic inputs
%   thresholds  - the thresholds used
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also norm

if(~ iscell(im1))
    
    dim = ndims(im1);
    
    % convert both to double
    im1 = double(im1);
    im2 = double(im2);
    
    % normalization
    normalize = checkSetInput(para, 'normalize','logical',true);
    if(normalize)
        normalizationNorm = checkSetInput(para,'normalizationNorm',[1,2,inf],inf);
        im1 = im1/norm(im1(:),normalizationNorm);
        im2 = im2/norm(im2(:),normalizationNorm);
    end
    
    maxVal = max([im1(:);im2(:)]);
    
    errorMeasures = checkSetInput(para,'errorMeasures', 'cell', {'MSE'});
    thresholds    = checkSetInput(para,'thresholds','>=0',0:0.1:0.9);
    dist = cell(1,length(errorMeasures));
    
    for i=1:length(thresholds)
        threshold = maxVal * thresholds(i);
        im1_thres = im1;
        im1_thres(im1 < threshold) = 0;
        im2_thres = im2;
        im2_thres(im2 < threshold) = 0;
        
        for j=1:length(errorMeasures)
            switch errorMeasures{j}
                case 'MSE' % mean squared error MSE
                    dist{j}.name = 'MSE';
                    dist{j}.value(i) = sum((im1_thres(:)-im2_thres(:)).^2)/numel(im1_thres(:));
                case 'relH1' % H1 distance
                    dist{j}.name = 'relH1';
                    p1p2diff = im1_thres-im2_thres;
                    
                    switch dim
                        case 2
                            [p1_dx,p1_dy] = gradient(im1_thres);
                            [p2_dx,p2_dy] = gradient(im2_thres);
                            [p1p2diff_dx,p1p2diff_dy] = gradient(p1p2diff);
                            
                            p1_H1 = sqrt(sum(im1(:).^2 + p1_dx(:).^2 + p1_dy(:).^2));
                            p2_H1 = sqrt(sum(im2(:).^2 + p2_dx(:).^2 + p2_dy(:).^2 ));
                            p1p2diff_H1 = sqrt(sum(p1p2diff(:).^2 + p1p2diff_dx(:).^2 + p1p2diff_dy(:).^2));
                        case 3
                            [p1_dx,p1_dy,p1_dz] = gradient(im1_thres);
                            [p2_dx,p2_dy,p2_dz] = gradient(im2_thres);
                            [p1p2diff_dx,p1p2diff_dy,p1p2diff_dz] = gradient(p1p2diff);
                            
                            p1_H1 = sqrt(sum(im1(:).^2 + p1_dx(:).^2 + p1_dy(:).^2 + p1_dz(:).^2));
                            p2_H1 = sqrt(sum(im2(:).^2 + p2_dx(:).^2 + p2_dy(:).^2 + p2_dz(:).^2));
                            p1p2diff_H1 = sqrt(sum(p1p2diff(:).^2 + p1p2diff_dx(:).^2 + p1p2diff_dy(:).^2 + p1p2diff_dz(:).^2));
                    end
                    
                    dist{j}.value(i) = 2 * p1p2diff_H1/(p1_H1+p2_H1);
                case 'PSNR' % PSNR
                    dist{j}.name     = 'PSNR';
                    dist{j}.value(i) = psnr(im1_thres,im2_thres);
                case 'CORR'
                    dist{j}.name     = 'CORR';
                    dist{j}.value(i) =  cov(im1_thres(:).*im2_thres(:))/sqrt(var(im1_thres(:))*var(im2_thres(:)));
                case 'SSIM' % ssim
                    dist{j}.name     = 'SSIM';
                    dist{j}.value(i) = ssim(im1_thres,im2_thres);
                otherwise
                    error(['unkown error measure: ' errorMeasures{j}])
            end
        end
        
    end
else
    % compute error measures frame-by-frame
    T = length(im1);
    for t=1:T
        [distAll{t}, thresholdsAll{t}] = distanceReconstructions(im1{t},im2{t},para);
    end
    
    % accumulate error
    dist  = distAll{1};
    for iErr = 1:length(dist)
        for t=1:T
            dist{iErr}.value(t) = distAll{t}{iErr}.value;
        end
    end
    
    
    % reduce to statistics
    dynamicMode = checkSetInput(para,'dynamicMode',{'mean','meanMinMax','all'},'mean');
    switch dynamicMode
        case 'mean'
            for iErr = 1:length(dist)
                dist{iErr}.value = mean(dist{iErr}.value);
            end
        case 'meanMinMax'
            for iErr = 1:length(dist)
                dist{iErr}.value = [mean(dist{iErr}.value),min(dist{iErr}.value),max(dist{iErr}.value)];
            end
    end
end

end

