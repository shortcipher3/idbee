function limg=ExtractCells(img)

fun=@(block_struct) im2bw(block_struct.data,graythresh(block_struct.data));
box=[128 128]/4;
I=rgb2gray(img);

bw1 = blockproc(I,box,fun);
bw2 = blockproc([I(1:floor(box(1)/2),1:end); I],box,fun);
bw2=bw2((floor(box(1)/2)+1):end,1:end);
bw3 = blockproc([I(1:end,1:floor(box(2)/2)) I],box,fun);
bw3=bw3(1:end,(floor(box(2)/2+1)):end);    
bw4 = blockproc([I(1:floor(box(1)/2),1:floor(box(2)/2)) I(1:floor(box(1)/2),1:end); ...
    I(1:end,1:floor(box(2)/2)) I],box,fun);
bw4=bw4((floor(box(1)/2)+1):end,(floor(box(2)/2+1)):end);        

bw6=bw1+bw2+bw3+bw4;
bw6(bw6<3)=0;
bw5=~logical(bw6);

L=bwlabel(bw5);
stats=regionprops(L,'BoundingBox');
a=cell2mat({stats.BoundingBox});
[~,ind]=max(a(3:4:end).*a(4:4:end));
L(L~=ind)=0;% get region with largest footprint

bwveins=~logical(L);

% fill small holes
L=bwlabel(bwveins,4);

x=tabulate(reshape(L,1,numel(L)));
sh=ismember(L,x(x(:,2)<2000/4,1));
bwveins2=~bwveins+sh;

bwveins3=imerode(imdilate(bwveins2,ones(7)),ones(5));        

limg=bwlabel(~bwveins3);    
bor=imfill(bwveins3,'holes');
limg=bor.*limg;% removes the labeled components bordering image boundaries

end
