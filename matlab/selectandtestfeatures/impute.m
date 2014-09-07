function data=impute(data,method,varargin)
% impute function, options are zeros, ones, mean, median, mode, knn, note
% that mean, median, and mode can leave in NaN's if there is a whole row,
% whereas in knn I move in 0's for whole rows
if nargin<1
    data=[];
    return;
elseif nargin<2
    method='zeros';
end
if strcmp(method,'zeros')
    data(isnan(data))=0;% impute with 0's
elseif strcmp(method,'ones')
    data(isnan(data))=1;% impute with 1's
elseif strcmp(method,'mean')
    temp=nanmean(data,2);
    for k=1:size(data,1)
        data(k,isnan(data(k,:)))=temp(k);
    end
elseif strcmp(method,'median')
    temp=nanmedian(data,2);
    for k=1:size(data,1)
        data(k,isnan(data(k,:)))=temp(k);
    end    
elseif strcmp(method,'mode')
    temp=nanmode(data,2);
    for k=1:size(data,1)
        data(k,isnan(data(k,:)))=temp(k);
    end    
elseif strcmp(method,'knn')
%     for k=1:size(data,1)
%         if isempty(data(k,~isnan(data(k,:))))
%             data(k,:)=0;
%         end
%     end
    data=knnimpute(data',1,'Distance','cityblock');% impute with knn
    data=data';
else
    display('Valid option not specified, imputing with 0''s');
    data(isnan(data))=0;% impute with 0's
end
% consider mean without outliers
end

% for k=1:size(data,1)    
%     data(k,isnan(data(k,:)))=mean(data(k,~isnan(data(k,:))),2);% impute with mean
%     data(k,isnan(data(k,:)))=median(data(k,~isnan(data(k,:))),2);% impute with median
%     data(k,isnan(data(k,:)))=mode(data(k,~isnan(data(k,:))),2);% impute with mode
% end
