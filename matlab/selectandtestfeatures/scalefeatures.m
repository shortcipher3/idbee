function [data mu s]=scalefeatures(data,scaleoptions)
% Scale the features

if strcmp(scaleoptions,'nanzscore')
    [data, mu, s] = nanzscore(data);
elseif strcmp(scaleoptions,'DataScaling')
    [data, mu, s] = DataScaling(data);
elseif strcmp(scaleoptions,'NormalMaxMagnitude')
    data=data./repmat(max(abs(data),[],1),size(data,1),1);
    mu=zeros(1,size(data,2));
    s=max(abs(data),[],1);
elseif strcmp(scaleoptions,'zscore')
    [data, mu, s] = zscore(data);
elseif strcmp(scaleoptions,'zero-one')
	data = (data - repmat(min(data,[],1),size(data,1),1))*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));
	mu=min(data,[],1);
	s=(max(data,[],1)-min(data,[],1));
elseif strcmp(scaleoptions,'none')    
    mu=zeros(1,size(data,2));
    s=ones(1,size(data,2));
else 
    [data, mu, s] = nanzscore(data);
end

end
