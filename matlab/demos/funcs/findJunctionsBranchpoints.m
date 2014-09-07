function [locs veins]=findJunctionsBranchpoints(limg)
% uses shrink instead of skeleton

cmask=imfill(imdilate(limg>0,strel('disk',10)),'holes');
bw=(limg==0).*cmask;
veins=bwmorph(bw,'shrink','inf');
junctions=bwmorph(veins,'branchpoints');
[locs(:,1) locs(:,2)]=find(junctions);

end
