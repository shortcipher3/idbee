function class=mvnclassifywithpca(sample, training, group)

% includes training then classifying, assumes a multivariate Gaussian
% distribution

[coeff,score,latent]=princomp(training);
training=training*coeff;
% figure,hold on;k=1;plot(training(k==group,1),training(k==group,2),'*r');k=2;plot(training(k==group,1),training(k==group,2),'*g');k=3;plot(training(k==group,1),training(k==group,2),'*b');
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
        class=0;plrt=nan;stddist=nan;
        return;
    end
end
% classify
sample=(sample*coeff);
for k=groups'
	p(k) = mvnpdf(sample',mu(:,k),sigma(:,:,k));
end
[pc,class]=max(p);


