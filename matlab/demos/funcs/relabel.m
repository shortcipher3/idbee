function limg=relabel(limg1,limg2)
% limg1 - label template
% limg2 - mislabeled labels
limg=-limg2;
for m=unique(limg1(limg1>0))'
    limg(limg==limg(find(limg1==m,1,'first')))=m;
end
limg(limg<0)=0;
limg(imfill(limg==limg(1,1),[1,1]))=0;
end