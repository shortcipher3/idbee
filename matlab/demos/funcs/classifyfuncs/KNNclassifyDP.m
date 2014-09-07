function [class distance] = KNNclassifyDP(sample,training,groups,k)
% adjusted to work with groups not numbered 1, 2, ..., n, but rather any
% numbers, noticed that he uses the mean of the first k neighbors or number
% of neighbors (this means it isn't always the nearest neighbors, and it
% isn't always the k neighbors (could be k=1)
% more of a mean of the k-nearest neighbors of each class, but seems to
% work better on average than choosing the k-nearest neighbors
%Author: Daniel Pimentel

%Find out how many groups we have
g = unique(groups);

% Calculate the L2 norm distance between the sample and all the training
% points
% d = mydist(sample,training,2,[]);
d = mydist(sample,training);

% % weights vector (weight of each feature in the overall distance)
% w = ones(1,length(sample));
% 
% % get the weighted distances
% d = w*d;

%Initialize the matrix of K distances
D = zeros(1,length(g));

% Find the k nearest neighbours per class
for i=1:length(g)
    % get only the distances of the selected class
    aux = d(groups==g(i));
%     aux = d(strcmp(groups,g(i)));
    % sort them
    aux = sort(aux);
    
    % add only the first k distances
    D(i) = mean(aux(1:min(k,length(aux))));
end

[distance,ind] = min(D);
class=g(ind);
