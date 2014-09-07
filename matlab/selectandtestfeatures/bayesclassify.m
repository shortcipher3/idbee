function class=bayesclassify(sample, training, group,varargin)
% includes training then classifying
% see help NaiveBayes.fit for parameters that can be adjusted and the 
% syntax

% train
Bayes_Model = NaiveBayes.fit(training, group, varargin{:});

% classify
class = Bayes_Model.predict(sample);

end