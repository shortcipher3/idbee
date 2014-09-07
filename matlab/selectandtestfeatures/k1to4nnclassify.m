function class=k1to4nnclassify(vector,data,groups, varargin)
% no training needed, just classifying
% see help knnclassify for additional parameters, the number of neighbors
% is fixed from one to four other parameters may be adjusted

    class=zeros(size(vector,1),4);

    % classify
    for n=1:4 % number of neighbors to use, compare first 4
        class(:,n) = knnclassify(vector, data, groups, n,varargin{:});
    end
end