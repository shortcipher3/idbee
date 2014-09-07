function [finalresults fea classesg classes_tr test_classesg classes_te]= selectfeaturesandtestclassification(...
    trainfeatures,trainlabels,traingroups,testfeatures,testlabels,...
    testgroups,useXfeats,classifyfnc,imputemethod,scaleoptions,...
    selectfeatures,testmethod,cvmethod)
% select features and test classification
% classify everything, with variable grouping info (ie genera, species, 
% sex, subspecies, left/right wing) 
% features - a table of all the available features
% classes - the groups to be differentiated
% groups - any a-priori grouping, ie already know the genera give species
% useXfeats - how many features to use, can be a range
% testdata - percentage to hold out from training data as test data
% classifyfnc - @k1to4nnclassify, @chrissvmclassify, @lindssvmclassify,
% @bayesclassify, @classify, @treebagclassify, @knnclassify, 
% imputemethod - zeros, ones, knn, mean, median, mode
% scaleoptions - nanzscore, zscore, DataScaling, NormalMaxMagnitude,
% zero-one, none
% selectfeatures - mrmr, handpick, princomp, sequentialfs, sequentialbs,
% f-score, gini, corr, chi2, fast corr, infogain, kw, relieff, SBMF,
% blogreg, ttest
% testmethod - method for testdata: none, validation, loocv
% cvmethod - cross-validation method: none, loocv (leave-one-out cross
% validation)

% normalize features
[trainfeatures mu s]=scalefeatures(trainfeatures,scaleoptions);
testfeatures=bsxfun(@rdivide,bsxfun(@minus,testfeatures,mu),s);

% impute missing features for each species/group
trainfeatures=impute(trainfeatures,imputemethod);% add option to impute by groups
testfeatures=impute(testfeatures,imputemethod);

%leave empty for output if unused
classes_tr=[];classes_te=[];K=[];fea=[];M=[];c=[];test_classesg=[];
classesg=[];tfeats=[];

unigroups=unique(traingroups);
finalresults=cell(length(unigroups),length(useXfeats));
for m=1:length(unigroups)
    M=unigroups(m);
    cfeatsg=trainfeatures(strcmp(traingroups,M),:);
    [~,~,classesg]=...
        unique(trainlabels(strcmp(traingroups,M)));

    test_cfeatsg=testfeatures(strcmp(testgroups,M),:);
    [~,~,test_classesg]=...
        unique(testlabels(strcmp(testgroups,M)));

    [cfeatsg2 fea2 w2]=choosefeatures(cfeatsg,classesg,max(useXfeats),...
        selectfeatures,classifyfnc);      
    if length(useXfeats)>length(fea2)
        useXfeats((length(fea2)+1):end)=[];
    end
    if isempty(useXfeats)
        useXfeats=length(fea2);
    end        
    
    for K=useXfeats % number of features to try
        % select features to use 
%         [cfeatsg1 fea w]=choosefeatures(cfeatsg,classesg,K,...
%             selectfeatures,classifyfnc);
        cfeatsg1=cfeatsg2(:,1:K);
        fea=fea2(1:K);
        w=w2(1:K);
        
%         cfeatsg1=cfeatsg2;% for cpca
%         fea=fea2;
%         w=w2;
%         classifyfnc=@(sample,training,group)... 
%             mvnclassifywithcpca(sample, training, group,K);
        
        if strcmp(cvmethod,'loocv')
            [percentcorrect_tr classes_tr]= ...
                LeaveOneOutTest(cfeatsg1,classesg,classifyfnc);
            results(:,K)=[K percentcorrect_tr]';
        elseif strcmp(cvmethod,'none')
            classes_tr=[];
            results=[0 0];
        else
            [percentcorrect_tr classes_tr]= ...
                LeaveOneOutTest(cfeatsg1,classesg,classifyfnc);
            results(:,K)=[K percentcorrect_tr]';
        end

        if strcmp(selectfeatures,'princomp')
            tfeats=test_cfeatsg*fea;
            tfeats=tfeats(:,1:K);
        else
            tfeats=bsxfun(@times,test_cfeatsg(:,fea),w);
        end
        if strcmp(testmethod,'loocv')
            [percentcorrect_te classes_te]= ...
                LeaveOneOutTest(tfeats,test_classesg, ...
                classifyfnc);
            results2(:,K)=[K percentcorrect_te]';
        elseif strcmp(testmethod,'validation')                
            [percentcorrect_te classes_te]=classifytestdata( ...
                tfeats, test_classesg, cfeatsg1, ...
                classesg, classifyfnc);
            results2(:,K)=[K percentcorrect_te]';
        elseif strcmp(testmethod,'none')
            percentcorrect_te=0; 
            classes_te=0;
            results2(:,K)=[K percentcorrect_te]';
        else
            [percentcorrect_te classes_te]=LeaveOneOutTest(...
                tfeats,test_classesg,classifyfnc);
            results2(:,K)=[K percentcorrect_te]';
        end        
        
        % output
        o.classes_tr=classes_tr;o.classes_te=classes_te;o.K=K;
        o.fea=fea;o.group=M;o.test_classes=test_classesg;
        o.train_classesg=classesg;o.c=c;o.testfeats=tfeats;
        o.trainfeats=cfeatsg1;finalresults{m,K}=o;
    end
    results(:,results(1,:)==0)=[];    
    sum(bsxfun(@eq,classesg',unique(classesg)),2)' % number in each class
    results.'
    results=[];    

    results2(:,results2(1,:)==0)=[];
    sum(bsxfun(@eq,test_classesg',unique(test_classesg)),2)' % number in each class
    results2.'
    results2=[];
    
%     if verbose
%         confusionmat(classes_tr,classesg)
%         confusionmat(classes_te,testclassesg)
%     end
end


