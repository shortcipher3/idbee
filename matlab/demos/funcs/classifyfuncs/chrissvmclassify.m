function class=chrissvmclassify(vector,data,groups, varargin)
% includes training then classifying
% see help svmtrain for parameters that can be adjusted and the syntax

groupids=unique(groups);
if length(groupids)==1 % if there is only one group no need to classify
    class=ones(size(vector,1),1)*groupids;
else % classify samples into one group against all others
    class=zeros(size(vector,1),1);
    for k=1:length(groupids)
        % train
        svmstruct=svmtrain(data',groups==groupids(k),varargin{:});
        % classify
        ind=svmclassify(svmstruct,vector);
        class(ind)=groupids(k);    
    end
end