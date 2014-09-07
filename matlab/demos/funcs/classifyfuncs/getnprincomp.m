function [features_out coeff]=getnprincomp(features_in,n)
[coeff,score,latent]=princomp(features_in);
features_out=features_in*coeff;
features_out=features_out(:,1:n);
end