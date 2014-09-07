function bwout=starfill3(bw,fillspot)
bwout=false(size(bw));
b=bwboundaries(bw);
% b=b{1};
b=cell2mat(b);
for k=1:size(b,1)
    pix=ceil(max(abs(fillspot(2)-b(k,1)),abs(fillspot(1)-b(k,2))));
    x=round(linspace(fillspot(1),b(k,2),pix));
    y=round(linspace(fillspot(2),b(k,1),pix));    
    z=sub2ind(size(bw),y,x);
    bwout(z)=true;
end
bwout=imfill(bwout,'holes');
end
