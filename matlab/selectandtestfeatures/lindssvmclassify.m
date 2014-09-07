function class=lindssvmclassify(vector,data,groups)
% includes training then classifying

groupids=unique(groups);
n=size(data,2);
% train
w_class = [];
gam_class = [];
for k=1:length(groupids)

    C = data(groups==groupids(k),:); c = size(C,1);
    E = data(groups~=groupids(k),:); e = size(E,1);
    mu = 0.01;

    cvx_begin
        variables w(n) g(1) y(c) z(e)
        minimize(mu/2*w'*w + ((1/c)*ones(1,c)*y + (1/e)*ones(1,e)*z));
        C*w - g >= 1-y;
        E*w - g <= -(1-z);
        y >= 0;
        z >= 0;
    cvx_end
    
     w_class = [w_class w];
     gam_class = [gam_class g];
end        

% classify
dist1=bsxfun(@minus,vector*w_class, gam_class);
[~,ind]=max(dist1,[],2);
% [~,ind]=sort(dist1,2,'descend');ind=ind(:,1:3);% top 3
class=groupids(ind);
