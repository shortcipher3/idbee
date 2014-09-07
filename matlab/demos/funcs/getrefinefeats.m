function [feat_vector parts_inds num_parts]=getrefinefeats(zoom,limg)% Training Data

% preprocessing
numcells=7;
[locs veins]=findJunctionsBranchpoints(limg);
limg2=bwlabel(~veins.*imfill(veins,'holes'),4);
limg3=relabel(limg,limg2);
junction_pos = labelJunctions(locs,limg3); 
[lveinsthin lveinsthick]=labelVeins(limg3,limg);
junction_pos=findExtJunctions(lveinsthin,junction_pos);
junction_pos(junction_pos(:,2)==0,:)=nan;

%     figure,imshow(label2rgb(limg))
%     hold on;
%     plot(junction_pos(junction_pos(:,2)>0,2),junction_pos(junction_pos(:,1)>0,1),'*r')

% vein length is:
t=regionprops(lveinsthin,'Area');
veinlength=[t(:).Area];
veinlength=[veinlength zeros(1,20-length(veinlength))];
% vein length, Euclidean distance between endpoints
veinlengthe=zeros(1,20);
for m=unique(lveinsthin(lveinsthin>0))% for each vein
    z=[];
    [z(:,1) z(:,2)]=ind2sub(size(lveinsthin),...
        find(bwmorph(lveinsthin==1,'endpoints')));
    if ~isempty(z)
        veinlengthe(m)=sqrt(sum((z(1,:)-z(2,:)).^2));        
    end
end
% euclidean distance between endpoints to vein length ratio
vlr=veinlengthe./veinlength;
vlr(isnan(vlr))=1;

% average vein width
t=regionprops(lveinsthick,'Area');
veinarea=[t(:).Area];
veinarea=[veinarea zeros(1,20-length(veinarea))];
avgveinwidth=veinarea./veinlength;
avgveinwidth(isnan(avgveinwidth))=1;

% junctions and centroids all together
t=regionprops(limg,'Centroid');
x=[t.Centroid];
if length(x)<14
    x(13:14)=nan;
end
cj=[junction_pos; [x(1:2:end); x(2:2:end)]'];
Dj2c=pdist(cj,'euclidean'); % junction/centroid distances 
% Dj2cr=pdist(Dj2c',@(Xi,Xj) min(Xi./Xj,Xj./Xi));% junction/centroid distances ratios    
Dj2cr=pdist(Dj2c',@(Xi,Xj) Xi./max(Xj,1));% junction/centroid distances ratios    
Dj2cx=pdist(cj(:,1),'euclidean'); % junction/centroid distances 
% Dj2cxr=pdist(Dj2cx',@(Xi,Xj) min(Xi./Xj,Xj./Xi));% junction/centroid distances ratios  
Dj2cxr=pdist(Dj2cx',@(Xi,Xj) Xi./max(Xj,1));% junction/centroid distances ratios  
Dj2cy=pdist(cj(:,2),'euclidean'); % junction/centroid distances 
% Dj2cyr=pdist(Dj2cy',@(Xi,Xj) min(Xi./Xj,Xj./Xi));% junction/centroid distances ratios  
Dj2cyr=pdist(Dj2cy',@(Xi,Xj) Xi./max(Xj,1));% junction/centroid distances ratios  

% angles between junctions and centroids
Ajc=[];
for i=1:size(cj,1) % i is index of the vertex, Xi, Xj form vectors
%     Ajc=[Ajc pdist(cj([1:(i-1) (i+1):end],:),@(Xi,Xj) acos(bsxfun(@minus,Xi,cj(i,:))*...
%         bsxfun(@minus,Xj,cj(i,:))'./(sqrt(sum(bsxfun(@minus,Xi,...
%         cj(i,:)).^2,2))*sqrt(sum(bsxfun(@minus,Xj,cj(i,:)).^2,2)))))];
    x=pdist(cj([1:(i-1) (i+1):end],:),@(Xi,Xj) (bsxfun(@minus,Xi,cj(i,:))*bsxfun(@minus,Xj,cj(i,:))'));
    y=pdist(cj([1:(i-1) (i+1):end],:),@(Xi,Xj) (sqrt(sum(bsxfun(@minus,Xj,cj(i,:)).^2,2))*sqrt(sum(bsxfun(@minus,Xi,cj(i,:)).^2,2))));
    Ajc=[Ajc acos(x./y)];
end                

    
% cell area ratios are:
t=regionprops(limg,'Area','BoundingBox','Centroid',...
    'ConvexArea','Eccentricity','Extent','Extrema','MajorAxisLength',...
    'MinorAxisLength','Orientation','Perimeter','Solidity');
cellareas=[t(:).Area];
cellareas(cellareas==0)=nan;
cellareas=[cellareas nan(1,numcells-length(cellareas))];
cellarear=pdist(cellareas',@(Xi,Xj) Xi./Xj);% junction/centroid distances ratios    

cellbb=[t.BoundingBox];
cellbb(cellbb==0)=nan;
cellbb(cellbb==0.5)=nan;
cellbb=[cellbb nan(1,numcells*4-length(cellbb))];
cellc=[t.Centroid];
cellc=[cellc nan(1,numcells*2-length(cellc))];
cellca=[t.ConvexArea];
cellca(cellca==0)=nan;
cellca=[cellca nan(1,numcells-length(cellca))];
cellecc=[t.Eccentricity];
cellecc(cellecc==0)=nan;
cellecc=[cellecc nan(1,numcells-length(cellecc))];
cellext=[t.Extent];
cellext=[cellext nan(1,numcells-length(cellext))];
cellextr=[t.Extrema];
cellextr(:,(size(cellextr,2)+1):(numcells*2))=nan;
cellmajax=[t.MajorAxisLength];
cellmajax(cellmajax==0)=nan;
cellmajax=[cellmajax nan(1,numcells-length(cellmajax))];
cellminax=[t.MinorAxisLength];
cellminax(cellminax==0)=nan;
cellminax=[cellminax nan(1,numcells-length(cellminax))];
cellaxr=cellmajax./cellminax;
cellangle=[t.Orientation];
cellangle(isnan(cellareas))=nan;
cellangle=[cellangle nan(1,numcells-length(cellangle))];
cellper=[t.Perimeter];
cellper(cellper==0)=nan;
cellper=[cellper nan(1,numcells-length(cellper))];
cellperr=pdist(cellper',@(Xi,Xj) Xi./Xj);% junction/centroid distances ratios    
cellsol=[t.Solidity];
cellsol=[cellsol nan(1,numcells-length(cellsol))];

% Fourier Descriptors
z=5; % number of Fourier Shape Descriptors to gather
FSDs=nan(4,z,7);
for m=unique(limg(limg>0))'
    b=bwboundaries(limg==m);
    b=b{1};
    FSDs(:,:,m) = fEfourier(b, z, true, true);        
end

halfmagFSDS=[sqrt(sum(FSDs([1 2],:,:).^2,1)); sqrt(sum(FSDs([3 4],:,:).^2,1))];
magFSDs=sqrt(sum(FSDs.^2,1));
FSDs=FSDs(:);
halfmagFSDS=halfmagFSDS(:);
magFSDs=magFSDs(:);
    
% feat_vector=nan(1,x);
feat_vector=[% keep these up to date with the list of names in getrefinefeatsnames if you choose to edit
    zoom ... 1
    veinlength ... 20    
    veinlengthe ... 20
    vlr ... 20
    avgveinwidth ... 20
    Dj2c ... 300    
    Dj2c.*zoom ... 300
    Dj2cr ... 44850
    Dj2cx ... 300
    Dj2cx.*zoom ... 300
    Dj2cxr ... 44850    
    Dj2cy ... 300
    Dj2cy.*zoom ... 300
    Dj2cyr ... 44850
    Ajc ... 6900
    cellareas ... 7
    cellareas*zoom^2 ... 7    
    cellarear ... 21
    cellbb ... 28
    cellc ... 14
    cellca ... 7
    cellecc ... 7    
    cellext ... 7
    cellextr(:)' ... 7*x    
    cellmajax ... 7
    cellminax ... 7
    cellaxr ... 7 
    cellangle ... 7
    cellper ... 7
    cellperr ... 21
    cellsol ... 7
    FSDs' ... 4*5*7 140
    halfmagFSDS' ... 70
    magFSDs' ... 35
    ];
    
    
num_parts=[length(zoom) ...
    length(veinlength) ...
    length(veinlengthe) ...
    length(vlr) ...
    length(avgveinwidth) ...
    length(Dj2c) ...
    length(Dj2c) ...
    length(Dj2cr) ...
    length(Dj2cx) ...
    length(Dj2cx) ...
    length(Dj2cxr) ...
    length(Dj2cy) ...
    length(Dj2cy) ...
    length(Dj2cyr) ...
    length(Ajc) ...
    length(cellareas) ...
    length(cellareas*zoom^2) ...
    length(cellarear) ...
    length(cellbb) ...
    length(cellc) ...
    length(cellca) ...
    length(cellecc) ...
    length(cellext) ...
    length(cellextr(:)') ...
    length(cellmajax) ...
    length(cellminax) ...
    length(cellaxr) ...
    length(cellangle) ...
    length(cellper) ...
    length(cellperr) ...
    length(cellsol) ...
    length(FSDs) ... 
    length(halfmagFSDS) ... 
    length(magFSDs) ... 
    ];
parts_inds=cumsum(num_parts);

end
