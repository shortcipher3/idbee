function [id genus species subspecies gender lrwing zoom] = ...
    parsefilename(name)

% parse file information
ind=strfind(name,filesep);
name=name(ind(end)+1:end-4);
labels=textscan(name, '%d %s %s %s %s %f%s');
if cellfun(@isempty,labels(7)) % subspecies also labeled
    temp=textscan(name, '%d %s %s %s %s %s %f%s');
    subspecies=temp(4);
    temp(4)=[];
    labels(:,k)=temp;
    id=labels{1};
    genus=char(labels{2});
    species=char(labels{3});
    subspecies=char(labels{4});
    gender=char(labels{5});
    lrwing=char(labels{6});
    zoom=labels{7};
else
    id=labels{1};
    genus=char(labels{2});
    species=char(labels{3});    
    subspecies='unknown';
    gender=char(labels{4});
    lrwing=char(labels{5});
    zoom=labels{6};    
end


end