function class=mvnclassifywithcpca(sample, training, group, K)

% includes training then classifying, assumes a multivariate Gaussian
% distribution

% train
groups=unique(group);
mu=zeros(K,length(groups));
sigma=zeros(K,K,length(groups));
for k=groups'
    coeff(:,:,k)=princomp(training(k==group,:));
    features=training(k==group,:)*coeff(:,:,k);
    mu(:,k)=mean(features(:,1:K));
    sigma(:,:,k)=cov(features(:,1:K));
end
for k=groups' % make sure covariance matrices are positive definite
    [~,notposdef]=chol(sigma(:,:,k));
    if notposdef
        class=0;plrt=nan;stddist=nan;
        return;
    end
end
% classify
for k=groups'
    sample=sample*coeff(:,:,k);
	p(k) = mvnpdf(sample(1:K)',mu(:,k),sigma(:,:,k));
end
[pc,class]=max(p);


