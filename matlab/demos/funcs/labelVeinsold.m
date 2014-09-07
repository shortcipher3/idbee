function [lveinsthin lveinsthick]=labelVeins(limg,olimg)
% find & label veins by bridging gaps between two cells

lveinsthin=zeros(size(limg));

temp=ismember(limg,[1 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=5;

temp=ismember(limg,[2 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=6;

temp=ismember(limg,[3 4]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=7;

temp=ismember(limg,[4 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=8;

temp=ismember(limg,[1 2]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=13;

temp=ismember(limg,[2 3]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=14;

temp=ismember(limg,[3 5]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=15;

temp=ismember(limg,[4 5]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=18;

temp=ismember(limg,[2 4]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=19;

temp=ismember(limg,[4 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=21;

temp=ismember(limg,[5 6]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=22;

temp=ismember(limg,[6 7]);
lveinsthin(imfill(bwmorph(temp,'bridge'),'holes')&~temp)=23;        

% thicken the veins
lveinsthick=(olimg==0).*imdilate(lveinsthin,strel('disk',10));

end
