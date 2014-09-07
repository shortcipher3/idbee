function class=treebagclassify(vector,data,groups,varargin)
% includes training then classifying

% train
if nargin>3
    model=TreeBagger(varargin{1},data,groups,varargin{2:end});
else    
    model=TreeBagger(100,data,groups);
end

% classify
class=predict(model,vector);
class=double(char(class))-'0';
end
%treebagger(ntrees, x,y,'param1',val1,...)