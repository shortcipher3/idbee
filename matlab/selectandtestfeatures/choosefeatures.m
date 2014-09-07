function [goodfeatures ind weights]=choosefeatures(features,groups,K,...
    selectfeatures,classifyfnc)
weights=ones(1,K);
if length(unique(groups))<2% nothing to classify
    ind = 1:K;
    goodfeatures=features(:,ind);
    return;
end

if strcmp(selectfeatures,'mrmr')
    ind = mrmr_mid_d(features, groups, K);% mRMR method
    goodfeatures=features(:,ind);
elseif strcmp(selectfeatures,'princomp')
    [goodfeatures ind]=getnprincomp(features,K);% makes vague features used
elseif strcmp(selectfeatures,'sequentialfs') % returns however many features it likes
    c=cvpartition(groups,'k',10);
    opts=statset('display','iter');    
    fun=@(Xtrain,Ytrain,Xtest,Ytest) ...
        mean(sum(bsxfun(@ne,classifyfnc(Xtest, Xtrain, Ytrain),Ytest),1));
    [fs,history]=sequentialfs(fun,features,groups,'cv',c,'options',opts);
    ind=find(fs);
    goodfeatures=features(:,ind);
%     [goodfeatures ind]=getnprincomp(features,K);% makes vague features used    
elseif strcmp(selectfeatures,'sequentialbs') % returns however many features it likes
    c=cvpartition(groups,'k',10);
    opts=statset('display','iter');
    fun=@(Xtrain,Ytrain,Xtest,Ytest) ...
        mean(sum(bsxfun(@ne,classifyfnc(Xtest, Xtrain, Ytrain),Ytest),1));
    [fs,history]=sequentialfs(fun,features,groups,'cv',c,'options',...
        opts,'direction','backward');    
    ind=find(fs);
    goodfeatures=features(:,ind);
elseif strcmp(selectfeatures,'f-score')
    w=fsFisher(features,groups);
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(w.fList(1:K));
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'gini')
    w=fsGini(features,groups);
    ind=w.fList;ind=ind(1:K);    
    goodfeatures=features(:,ind);% no weights
elseif strcmp(selectfeatures,'corr')
    w=fsCFS(features,groups);
    ind=w.fList;ind=ind(1:K);    
    goodfeatures=features(:,ind);% no weights
%     weights=w.W(w.fList(1:K));
%     goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'chi2')
    w=fsChiSquare(features,groups);
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(w.fList(1:K));
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'fast corr')
    w=fsFCBF(features,groups);
    ind=w.fList;ind=ind(1:K);    
    goodfeatures=features(:,ind);% no weights
elseif strcmp(selectfeatures,'infogain')
    w=fsInfoGain(features,groups);
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(w.fList(1:K));
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'kw')
    w=fsKruskalWallis(features,groups);
    ind=w.fList;ind=ind(1:K);    
    goodfeatures=features(:,ind);% no weights
elseif strcmp(selectfeatures,'relieff')
    w=fsReliefF(features,groups,178,178);
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(w.fList(1:K));
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'SBMLR')
    w=fsSBMLR(features,groups);
    K=min(K,length(w.fList));
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(w.fList(1:K))';
    if sum(isinf(weights))
        weights=ones(1,length(weights));
    end
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),weights);%with weights
% elseif strcmp(selectfeatures,'spectrum')
%     [wFeat sf]=fsSpectrum(features*features',features,-1);
%     ind=w.fList;ind=ind(1:K);    
% %     goodfeatures=features(:,ind);% no weights
%     weights=w.W(w.fList(1:K));
%     goodfeatures=bsxfun(@times,features(:,ind(1:K)),w.W(w.fList(1:K)));%with weights
elseif strcmp(selectfeatures,'blogreg')
    param.tol=1;
    w=fsblogreg(features,groups,param);
    ind=w.fList;ind=ind(1:K);    
%     goodfeatures=features(:,ind);% no weights
    weights=w.W(1:K)';
    goodfeatures=bsxfun(@times,features(:,ind(1:K)),weights);%with weights    
elseif strcmp(selectfeatures,'ttest')
    w=fsTtest(features,groups);
    w.fList=w.fList(~isnan(w.W(w.fList)));
    ind=w.fList;ind=ind(1:K);    
    goodfeatures=features(:,ind);% no weights  
elseif strcmp(selectfeatures,'handpick')% not currently working, worked in old code
    featurenames2={'Bounding Box X Width (seg 9)';... adding mm loses 1 pic
        'mm per pixel';...
        'Fourier Descriptor 5.1/5.2 Magnitude (seg 10)';...
        'E-Dist seg 10 Centroid to seg 5 Centroid mm';...
        'E-Dist Centroid to BB UL Corner (seg 9)'...
        };
    [ind indorder]=getFeatureIndicesByName(featurenames,featurenames2);
    ind=ind(indorder);
%     featurenames=featurenames(ind,:);
    goodfeatures=features(:,ind(1:K));    
elseif strcmp(selectfeatures,'none')% if already have chosen and ordered
    ind=1:size(features,2);%1:K;% changed for pca results
    goodfeatures=features(:,ind);
else
    ind = mrmr_mid_d(features, groups, K);% mRMR method
    goodfeatures=features(:,ind);
end