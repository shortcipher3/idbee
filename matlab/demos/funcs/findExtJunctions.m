function junction_pos=findExtJunctions(lveinsthin,junction_pos)

% more iffy, because I can't always see with my eyes where it should be to
% verify
if sum(sum(lveinsthin==17))
    im=bwmorph(lveinsthin==17,'skel');
    [x y]=find(bwmorph(im,'endpoints'),1);
    p=bwtraceboundary(im,[x y],'S');
    P=p;
    [~,I,~]=unique(P,'rows','first');
    P3=P(sort(I),:);
    theta=atan2(P3(1,1)-P3(end,1),P3(1,2)-P3(end,2));
    P4=P3*[cos(theta) sin(theta); -sin(theta) cos(theta)];
    ysignature=abs(bsxfun(@minus,P4(:,1),(P4(1,1)+(P4(1,1)-P4(end,1))/2)));
    [~,ind]=max(ysignature);
    junction_pos(4,:)=[P3(ind,1),P3(ind,2)];
end

if sum(sum(lveinsthin==18))
    im=bwmorph(lveinsthin==18,'skel');
    [x y]=find(bwmorph(im,'endpoints'),1);
    p=bwtraceboundary(im,[x y],'S');
    P=p;
    [~,I,~]=unique(P,'rows','first');
    P3=P(sort(I),:);
    theta=atan2(P3(1,1)-P3(end,1),P3(1,2)-P3(end,2));
    P4=P3*[cos(theta) sin(theta); -sin(theta) cos(theta)];    
    xsignature=abs(bsxfun(@minus,P4(:,2),(P4(1,2)+(P4(1,2)-P4(end,2))/2))); 
    [~,ind]=max(xsignature);
    junction_pos(6,:)=[P3(ind,1),P3(ind,2)];
end

if sum(sum(lveinsthin==20))
    im=bwmorph(lveinsthin==20,'skel');
    [x y]=find(bwmorph(im,'endpoints'),1);
    p=bwtraceboundary(im,[x y],'S');
    P=p;
    [~,I,~]=unique(P,'rows','first');
    P3=P(sort(I),:);
    theta=atan2(P3(1,1)-P3(end,1),P3(1,2)-P3(end,2));
    P4=P3*[cos(theta) sin(theta); -sin(theta) cos(theta)];
    ysignature=abs(bsxfun(@minus,P4(:,1),(P4(1,1)+(P4(1,1)-P4(end,1))/2)));
    [~,ind]=max(ysignature);
    junction_pos(16,:)=[P3(ind,1),P3(ind,2)];
end

if sum(sum(lveinsthin==15))
    im=bwmorph(lveinsthin==15,'skel');
    [x y]=find(bwmorph(im,'endpoints'),1);
    p=bwtraceboundary(im,[x y],'S');
    P=p;
    [~,I,~]=unique(P,'rows','first');
    P3=P(sort(I),:);
    esignature2=sqrt(sum(bsxfun(@minus,P3,junction_pos(2,:)).^2,2));
    esignature10=sqrt(sum(bsxfun(@minus,P3,junction_pos(10,:)).^2,2));
    esigmod=esignature2+esignature10;
    [~, ind]=findpeaks(esigmod,'minpeakdistance',floor(length(esigmod)/2));
    [~,ind1]=min(sqrt(sum(...
        bsxfun(@minus,[P3(ind,1),P3(ind,2)],junction_pos(2,:)).^2,2)));
    [~,ind18]=min(sqrt(sum(...
        bsxfun(@minus,[P3(ind,1),P3(ind,2)],junction_pos(10,:)).^2,2)));
    if ind1~=ind18
        junction_pos(1,:)=[P3(ind(ind1),1),P3(ind(ind1),2)];
        junction_pos(18,:)=[P3(ind(ind18),1),P3(ind(ind18),2)];
    end
end


end
