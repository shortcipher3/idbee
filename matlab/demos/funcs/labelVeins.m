function [lveinsthin lveinsthick]=labelVeins2(limg,olimg)
% find & label veins by bridging gaps between two cells

lveinsthin=zeros(size(limg));

% interior veins
temp=ismember(limg,[2 1]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=1;

temp=ismember(limg,[3 2]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=2;

temp=ismember(limg,[3 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=3;

temp=ismember(limg,[5 2]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=4;

temp=ismember(limg,[5 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=5;

temp=ismember(limg,[7 2]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=6;

temp=ismember(limg,[7 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=7;

temp=ismember(limg,[4 3]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=8;

temp=ismember(limg,[4 5]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=9;

temp=ismember(limg,[4 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=10;

temp=ismember(limg,[1 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=11;

temp=ismember(limg,[2 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=12;        

temp=ismember(limg,[5 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=13;

temp=ismember(limg,[3 5]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=14;

% exterior veins
extveins=imdilate(limg>0,ones(3))&~(lveinsthin>0)&~(limg>0);
L=bwlabel(extveins);
lveinsthin(L==mode(L(L>0)))=15;

lveinsthin(imdilate(limg==2,ones(3))&(lveinsthin==15))=16;

lveinsthin(imdilate(limg==3,ones(3))&(lveinsthin==15))=17;

lveinsthin(imdilate(limg==4,ones(3))&(lveinsthin==15))=18;

lveinsthin(imdilate(ismember(limg,[5 7]),ones(3))&(lveinsthin==15))=19;

lveinsthin(imdilate(limg==6,ones(3))&(lveinsthin==15))=20;

% thicken the veins
lveinsthick=(olimg==0).*imdilate(lveinsthin,strel('disk',10));

end
