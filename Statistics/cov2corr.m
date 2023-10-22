function corr_mat = cov2corr(cov_mat)
%COV2CORR converts a covariance matrix to a correlation matrix
%
% DESCRIPTION: 
%   cov2corr.m: consult wikipedia for the definition of covariance and
%   correlation matrix of multi-variate random variables. 
%
% USAGE:
%   corr_mat = cov2corr(covMat)
%
% INPUTS:
%   cov_mat - covariance matrix as computed by cov()
%
% OUTPUTS:
%   corr_mat - correltation matrix
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also covariancePlot

varVec  = diag(cov_mat);
sigma   = sqrt(varVec);
corr_mat = bsxfun(@rdivide, cov_mat,  sigma);
corr_mat = bsxfun(@rdivide, corr_mat, sigma');
t       = find(abs(corr_mat) > 1); corr_mat(t) = corr_mat(t)./abs(corr_mat(t));
corr_mat(1:size(cov_mat,1)+1:end) = sign(diag(corr_mat));

end