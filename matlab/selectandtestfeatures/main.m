%% Initialize - set up all features for use while experimenting
addpath('mRMR_0.9_compiled')
addpath('mi')
run(['fspack' filesep 'fspackage' filesep 'load_fspackage'])
run(['cvx' filesep 'cvx_setup'])


%% Select and test features, one function call, but there are many adjustable knobs

% clean up
close all;
clear all;

% load features from a file
load in/data
features=real(data);

% select an equal number of each species of bee for this test
m=30;
mystr='first';
ind=[];
ind=[ind find(strcmp('sericeus',species),m,mystr)];% genus Agapostemon
ind=[ind find(strcmp('texanus',species),m,mystr)];
ind=[ind find(strcmp('virescens',species),m,mystr)];
ind=[ind find(strcmp('MAWIspB',species),m,mystr)];% genus Lasioglossum
ind=[ind find(strcmp('acuminatum',species),m,mystr)];
ind=[ind find(strcmp('coriaceum',species),m,mystr)];
ind=[ind find(strcmp('leucozonium',species),m,mystr)];
ind=[ind find(strcmp('nymphaerum',species),m,mystr)];
ind=[ind find(strcmp('pilosum',species),m,mystr)];
ind=[ind find(strcmp('rohweri',species),m,mystr)];
ind=[ind find(strcmp('zephyrum',species),m,mystr)];
ind=[ind find(strcmp('zonulum',species),m,mystr)];
ind=[ind find(strcmp('calcarata',species),m,mystr)];% genus Ceratina
ind=[ind find(strcmp('impatiens',species),m,mystr)];% genus Bombus
ind=[ind find(strcmp('bimaculata',species),m,mystr)];
ind=[ind find(strcmp('griseocolis',species),m,mystr)];
ind=[ind find(strcmp('coloradensis',species),m,mystr)];% genus Osmia
ind=[ind find(strcmp('lignaria',species),m,mystr)];
ind=[ind find(strcmp('pusilla',species),m,mystr)];
ind=[ind find(strcmp('ribifloris',species),m,mystr)];
ind=[ind find(strcmp('Osmiatexana',strcat(genus,species)),m,mystr)];
features=features(ind,:);
species=species(ind);
genus=genus(ind);
sex=sex(ind);
lrwing=lrwing(ind);
id=id(ind);

ind=find(sum(isnan(features))==size(features,1));
features(:,ind)=[];
featurenames(ind)=[];


groups=genus';% or all belong to same group cellstr(num2str(ones(length(species),1)));
tlabels=species';% what we are classifying, genus, species,  
useXfeats=1:20;% how many features to use

% the function for classifying, many available: svmclassify, knnclassify, lindssvmclassify, treebagclassify, mvnclassify, bayesclassify, adaboostclassify
% classifyfunc=@(sample,training,group)... tried and substantially worse
%     k1to4nnclassify(sample, training, group,'cityblock');
classifyfunc=@(sample,training,group)... tried and substantially worse
    knnclassify(sample, training, group,3,'cityblock');
% classifyfunc=@lindssvmclassify;
% classifyfunc=@(sample,training,group)KNNclassifyDP(sample,training,group,3);

imputemethod='zeros';% zeros, ones, mean, median, mode, knn
scaleoptions='nanzscore';% DataScaling, NormalMaxMagnitude, none
selectfeatures='SBMLR';% SBMLR, mrmr, princomp, sequentialfs, sequentialbs, f-score, gini, corr, chi2, fast corr, infogain, kw, relieff, blogreg, none
testmethod='validation';% loocv, none
cvmethod='none';% loocv
testdata=0.34;% how much to use for test (remaining used for training)
c=cvpartition(strcat(groups,tlabels),'holdout',testdata);

tic;
finalresults = selectfeaturesandtestclassification(...
    features(c.training,:),tlabels(c.training),groups(c.training),...
    features(c.test,:),tlabels(c.test),groups(c.test),useXfeats,...
    classifyfunc,imputemethod,scaleoptions,selectfeatures,testmethod,...
    cvmethod);
toc;


