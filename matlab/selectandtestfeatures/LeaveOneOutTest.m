function [classification_rate classes]= ...
    LeaveOneOutTest(data,groups,classifyfnc)
% leave-one-out cross-validation
% data - matrix of all the features, rows correspond to a sample
% groups - a vector of the groups each sample belongs to
% classifyfnc - function to classify with
% if training is required for the classifier, the classify function should
% take that into account, thus you may need to make a wrapper function
% which first calls the training function followed by the classify function

for k=1:length(groups) % for each test sample
    tdata=data;
    tdata(k,:)=[];
    tgroups=groups;
    tgroups(k)=[];
    class = classifyfnc(data(k,:), tdata, tgroups);  
    if ~exist('correct','var')
        correct=zeros(size(class));
        classes=zeros(length(class),length(groups));
    end
    correct=correct+(class==repmat(groups(k),size(class)));% did it make the right decision?, yes add 1
    classes(:,k)=class;
end
classification_rate=correct./length(groups);


end