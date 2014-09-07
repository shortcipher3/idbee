
m=9;
d=segment_features(logical((segment_features(:,3)==m).*(segment_features(:,4)==1)),2:end);
f=segment_features(logical((segment_features(:,3)==m).*(segment_features(:,4)==1)),2);%working ones, segment m, class only
K=1;
% d-data table f-class variable K=number of features? 


[fea] = mrmr_miq_d(d, f, K)
[fea] = mrmr_mid_d(d, f, K)
[fea] = mrmr_mibase_d(d, f, K)