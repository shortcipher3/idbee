function [y, mu, s] = DataScaling(x, mu, s)
%==========================================================================
% scaling the training data to zero mean and unit variance
%==========================================================================
% [y, mu, s] = DataScaling(x, mu, s);
% mu, s: option inputs
%--------------------------------------------------------------------------
% Input :
%  x [m x n] : the training data (do not include the label)
%              (each row of the matrix represents a datapoint)
%              (each column represents a variable)
%--------------------------------------------------------------------------
% Output :
%  y  [m x n] : the scaled training data
%  mu [1 x n] : the mean value for each attribute
%  s  [1 x n] : the standard deviation for each attribute
%==========================================================================
[m, n] = size(x);

if m > 1
    % if one of feature has the same value for all data points
    % then we do not scale this feature and drop it out
    a = [];
    for i = 1 : n
        a = [a length( unique( x(:,i) ) )];
    end
    x(:, find(a == 1)) = [];
end
%--------------------------------------------------------------------------
rows = length( x(:, 1) );
e = ones(rows,1);
%--------------------------------------------------------------------------
if nargin == 1
    mu = nanmean(x);
    s = nanstd(x);
end
%--------------------------------------------------------------------------
y = x - e*mu; % zero mean
y = y ./ (e*s); % unit variance
%--------------------------------------------------------------------------