function [junction_pos junction_labs jneighbs]=labelJunctions(locs,limg)
% number the junctions consistantly among images, the junctions are
% identified by their cell neighbors

jneighbs=zeros([size(locs,1) 4]);

for m=1:size(locs,1)% find neighbors of each branchpoint
    neighbors=unique(limg((locs(m,1)-1):(locs(m,1)+1),...
        (locs(m,2)-1):(locs(m,2)+1)));
    jneighbs(m,:)=[neighbors(2:end)' zeros(1,5-length(neighbors))];
end

% label the junctions
junction_pos=zeros(18,2);
junction_labs=zeros(1,size(jneighbs,1));

% label junctions best described by vein neighbors

% 2nd abscissa of R's/1st transverse cubital        
indvein=sum(ismember(jneighbs,[3,4]),2)==2;
indtop=sum(ismember(jneighbs,[3,4,5]),2)==3;
if sum(indtop)==1
    junction_labs(indtop)=7;
    junction_pos(7,:) = locs(indtop,:);
end
if sum(indvein&indtop)==1
    junction_labs(indvein&~indtop)=8;
    junction_pos(8,:) = locs(indvein&~indtop,:);
end


% r-m/2nd trans cub        
indvein=sum(ismember(jneighbs,[4,6]),2)==2;
indtop=sum(ismember(jneighbs,[4,6,5]),2)==3;
if sum(indtop)==1
    junction_labs(indtop)=14;
    junction_pos(14,:) = locs(indtop,:);
end
if sum(indvein&indtop)==1
junction_labs(indvein&~indtop)=13;
junction_pos(13,:) = locs(indvein&~indtop,:);
end

% 1m-cu/1st recurrent    
indvein=sum(ismember(jneighbs,[2,7]),2)==2;
indbot=sum(ismember(jneighbs,[1,2,7]),2)==3;
if sum(indbot)==1
    junction_labs(indbot)=9;
    junction_pos(9,:) = locs(indbot,:);
end
if sum(indvein&indbot)==1
    junction_labs(indvein&~indbot)=12;
    junction_pos(12,:) = locs(indvein&~indbot,:);
end

% label junctions best described by neighbors
ind=(sum(ismember(jneighbs,[1,7]),2)==2) & ...
    (sum(ismember(jneighbs,2),2)==0);
if sum(ind)==1
    junction_pos(10,:) = locs(ind,:);
    junction_labs(ind)=10;
end

ind=(sum(ismember(jneighbs,[1,2]),2)==2) & ...
    (sum(ismember(jneighbs,7),2)==0);
if sum(ind)==1
    junction_pos(2,:) = locs(ind,:);
    junction_labs(ind)=2;
end

ind=(sum(ismember(jneighbs,[2,3]),2)==2) & ...
    (sum(ismember(jneighbs,[4,7]),2)==0);
if sum(ind)==1
    junction_pos(3,:) = locs(ind,:);
    junction_labs(ind)=3;
end

ind=(sum(ismember(jneighbs,[3,5]),2)==2) & ...
    (sum(ismember(jneighbs,4),2)==0);
if sum(ind)==1
    junction_pos(5,:) = locs(ind,:);
    junction_labs(ind)=5;
end

ind=(sum(ismember(jneighbs,[6,7]),2)==2) & ...
    (sum(ismember(jneighbs,[2,4]),2)==0);
if sum(ind)==1
    junction_pos(17,:) = locs(ind,:);
    junction_labs(ind)=17;
end

ind=(sum(ismember(jneighbs,[5,6]),2)==2) & ...
    (sum(ismember(jneighbs,[3,4]),2)==0);
if sum(ind)==1
    junction_pos(15,:) = locs(ind,:);
    junction_labs(ind)=15;
end
end