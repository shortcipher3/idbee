function class=mvnclassify(sample, training, group)
% includes training then classifying, assumes a multivariate Gaussian
% distribution

% train
groups=unique(group);
mu=zeros(size(training,2),length(groups));
sigma=zeros(size(training,2),size(training,2),length(groups));
for k=groups'
    mu(:,k)=mean(training(k==group,:));
    sigma(:,:,k)=cov(training(k==group,:));
end
for k=groups' % make sure covariance matrices are positive definite
    [~,notposdef]=chol(sigma(:,:,k));
    if notposdef
        class=0;
        return;
    end
end
% classify
for k=groups'
	p(k) = mvnpdf(sample',mu(:,k),sigma(:,:,k));
end
[~,class]=max(p);
end