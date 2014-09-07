function [z, mu, sigma] = nanzscore(x, mu, sigma)
%  NANZSCORE Standardized z score.
%     Z = NANZSCORE(X) returns a centered, scaled version of X, the same size as X.
%     For vector input X, Z is the vector of z-scores (X-MEAN(X)) ./ STD(X). For
%     matrix X, z-scores are computed using the mean and standard deviation
%     along each column of X.  For higher-dimensional arrays, z-scores are
%     computed using the mean and standard deviation along the first
%     non-singleton dimension.
%  
%     The columns of Z have sample mean zero and sample standard deviation one
%     (unless a column of X is constant, in which case that column of Z is
%     constant at 0).
%  
%     [Z,MU,SIGMA] = ZSCORE(X) also returns MEAN(X) in MU and STD(X) in SIGMA.
%  
%     [...] = ZSCORE(X,MU,SIGMA) normalizes X using (X-MU) ./ SIGMA.
%  
%     See also nanmean, nanstd.

rows = length( x(:, 1) );
e = ones(rows,1);
% calculate mu and sigma if not given
if nargin == 1
    mu = nanmean(x);
    sigma = nanstd(x);
end
%--------------------------------------------------------------------------
% z = x - e*mu; % zero mean
% z = z ./ (e*sigma); % unit variance

sigma0 = sigma;
sigma0(sigma0==0) = 1;
z = bsxfun(@minus,x, mu);
z = bsxfun(@rdivide, z, sigma0);
