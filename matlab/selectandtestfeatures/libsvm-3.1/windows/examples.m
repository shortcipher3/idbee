
% Train and test on the provided data heart_scale:

[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = svmpredict(heart_scale_label, heart_scale_inst, model); % test the training data

% For probability estimates, you need '-b 1' for training and testing:

[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07 -b 1');
[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');
[predict_label, accuracy, prob_estimates] = svmpredict(heart_scale_label, heart_scale_inst, model, '-b 1');

% To use precomputed kernel, you must include sample serial number as
% the first column of the training and testing data (assume your kernel
% matrix is K, # of instances is n):

n=5;

K1 = [(1:n)', K]; % include sample serial number as first column
model = svmtrain(label_vector, K1, '-t 4');
[predict_label, accuracy, dec_values] = svmpredict(label_vector, K1, model); % test the training data

% We give the following detailed example by splitting heart_scale into
% 150 training and 120 testing data.  Constructing a linear kernel
% matrix and then using the precomputed kernel gives exactly the same
% testing error as using the LIBSVM built-in linear kernel.

[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');

% Split Data
train_data = heart_scale_inst(1:150,:);
train_label = heart_scale_label(1:150,:);
test_data = heart_scale_inst(151:270,:);
test_label = heart_scale_label(151:270,:);

% Linear Kernel
model_linear = svmtrain(train_label, train_data, '-t 0');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, test_data, model_linear);

% Precomputed Kernel
model_precomputed = svmtrain(train_label, [(1:150)', train_data*train_data'], '-t 4');
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(test_label, [(1:120)', test_data*train_data'], model_precomputed);

accuracy_L % Display the accuracy using linear kernel
accuracy_P % Display the accuracy using precomputed kernel

%% Genus

features=nanzscore(features);
features(isnan(features))=0;
model = svmtrain(genus', features, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = svmpredict(genus', features, model); % test the training data

% Split Data
c=cvpartition(genus','holdout',.3);
% train_data = heart_scale_inst(1:150,:);
% train_label = heart_scale_label(1:150,:);
% test_data = heart_scale_inst(151:270,:);
% test_label = heart_scale_label(151:270,:);

% Linear Kernel
model_linear = svmtrain(genus(c.training)', features(c.training,:), '-t 0');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(genus(c.training)', features(c.training,:), model_linear);
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(genus(c.test)', features(c.test,:), model_linear);

% Precomputed Kernel
model_precomputed = svmtrain(genus(c.training)', [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], '-t 4');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(genus(c.training)', [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], model_precomputed);
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(genus(c.test)', [(1:size(features(c.test,:),1))', features(c.test,:)*features(c.training,:)'], model_precomputed);

%% species

features=nanzscore(features);
features(isnan(features))=0;
model = svmtrain(species', features, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = svmpredict(species', features, model); % test the training data

% Split Data
c=cvpartition(species','holdout',.3);
% train_data = heart_scale_inst(1:150,:);
% train_label = heart_scale_label(1:150,:);
% test_data = heart_scale_inst(151:270,:);
% test_label = heart_scale_label(151:270,:);

% Linear Kernel
model_linear = svmtrain(species(c.training)', features(c.training,:), '-t 0');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(species(c.training)', features(c.training,:), model_linear);
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(species(c.test)', features(c.test,:), model_linear);

% 75.5%

% Precomputed Kernel
model_precomputed = svmtrain(species(c.training)', [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], '-t 4');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(species(c.training)', [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], model_precomputed);
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(species(c.test)', [(1:size(features(c.test,:),1))', features(c.test,:)*features(c.training,:)'], model_precomputed);

% 75.5%

%% 

% Split Data
g=5;
group=species(genus==g)';
data=features(genus==g,:);
c=cvpartition(group,'holdout',.3);
% train_data = heart_scale_inst(1:150,:);
% train_label = heart_scale_label(1:150,:);
% test_data = heart_scale_inst(151:270,:);
% test_label = heart_scale_label(151:270,:);

% Linear Kernel
model_linear = svmtrain(group(c.training), data(c.training,:), '-t 0');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(group(c.training), data(c.training,:), model_linear);
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(group(c.test), data(c.test,:), model_linear);

% genus 1: 76.47%, 88
% genus 3: 61.77, 68
% genus 4:
% genus 5: 92.85, 64

% Precomputed Kernel
model_precomputed = svmtrain(group(c.training), [(1:size(data(c.training,:),1))', data(c.training,:)*data(c.training,:)'], '-t 4');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(group(c.training), [(1:size(data(c.training,:),1))', data(c.training,:)*data(c.training,:)'], model_precomputed);
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(group(c.test), [(1:size(data(c.test,:),1))', data(c.test,:)*data(c.training,:)'], model_precomputed);

% genus 1: 76.47
% genus 3: 61.67
% genus 4:
% genus 5: 92.85


%% species abis pictures
features=feats';samples_data;%[samples_data feats'];
features=nanzscore(features);
features(isnan(features))=0;
[~,~,groups]=unique(species);
groups=groups';
model = svmtrain(groups, features, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = svmpredict(groups, features, model); % test the training data

% Split Data
c=cvpartition(species','holdout',.3);
% train_data = heart_scale_inst(1:150,:);
% train_label = heart_scale_label(1:150,:);
% test_data = heart_scale_inst(151:270,:);
% test_label = heart_scale_label(151:270,:);

% Linear Kernel
model_linear = svmtrain(groups(c.training), features(c.training,:), '-t 0');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(groups(c.training), features(c.training,:), model_linear);
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(groups(c.test), features(c.test,:), model_linear);

% 75.5%

% Precomputed Kernel
model_precomputed = svmtrain(groups(c.training), [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], '-t 4');
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(groups(c.training), [(1:size(features(c.training,:),1))', features(c.training,:)*features(c.training,:)'], model_precomputed);
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(groups(c.test), [(1:size(features(c.test,:),1))', features(c.test,:)*features(c.training,:)'], model_precomputed);
