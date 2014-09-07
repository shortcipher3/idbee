function class=adaboostclassify(sample, training, group)
% includes training then classifying, assumes a multivariate Gaussian
% distribution

% train
ens = fitensemble(training,group,'AdaBoostM2',100,'Tree');

% classify
class = predict(ens,sample);

end
