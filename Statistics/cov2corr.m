function corrMat = cov2corr(covMat)
%COV2CORR converts a covariance matrix to a correlation matrix
%
% DESCRIPTION: 
%   cov2corr.m: consult wikipedia for the definition of covariance and
%   correlation matrix of multi-variate random variables. 
%
% USAGE:
%   corrMat = cov2corr(covMat)
%
% INPUTS:
%   covMat - covariance matrix as computed by cov()
%
% OUTPUTS:
%   corrMat - correltation matrix
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also covariancePlot

varVec  = diag(covMat);
sigma   = sqrt(varVec);
corrMat = bsxfun(@rdivide, covMat,  sigma);
corrMat = bsxfun(@rdivide, corrMat, sigma');
t       = find(abs(corrMat) > 1); corrMat(t) = corrMat(t)./abs(corrMat(t));
corrMat(1:size(covMat,1)+1:end) = sign(diag(corrMat));

end