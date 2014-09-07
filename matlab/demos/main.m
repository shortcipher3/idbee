

%% Find and label connected components from thresholding

close all;
clear all;
clc;
iptsetpref('ImshowBorder','loose')
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
addpath('.\funcs');
for k=1:length(pix)    
    name=char(pix(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    tic;
    limg=ExtractCells(img);
    toc;
    
%     figure,imshow(label2rgb(limg))
%     title([num2str(k) ': ' name])
    
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(limg));    
    set(h,'alphadata',0.6)
    title([num2str(k) ': ' name])
    
    if ~mod(k,20)
        pause;
        close all;
    end          
end
rmpath('.\funcs');

%% Manually label cells
close all;
clear all;
clc;
iptsetpref('ImshowBorder','loose')
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
addpath('.\funcs');
for k=1:length(pix)    
    name=char(pix(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    tic;
    limg=ExtractCells(img);
    toc;
    
    figure(1),imshow(label2rgb(limg))
    title([num2str(k) ': ' name])

    limg2=limg;
    for n=1:8% label the segments 1-7 (sequentially), then label the exterior
        [x,y] = ginput(1);
        limg2(limg2==limg2(round(y),round(x)))=-n;
    end
    limg2(limg2==-8)=0;
    limg2(limg2>0)=0;
    limg2=abs(limg2); 
    
    figure,imshow([label2rgb(limg) label2rgb(limg2)])
    title([num2str(k) ': ' name])
    
    if ~mod(k,3)
        pause;
        close all;
    end          
end
rmpath('.\funcs');

%% Automatically label cells

%% starfill to clean the boundaries of the labeled images
close all;
clear all;
clc;
iptsetpref('ImshowBorder','loose')
folderinl='..\cells\';
pixl=rdir([folderinl '*L1.mat']);
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
for k=1:length(pixl)            
    name=char(pixl(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    load(char(pixl(k).name))
    limg(limg==8)=0; 
    tic;
    limg=CleanCellBoundaries(limg);
    toc;
    
%     figure,imshow(label2rgb(limg))
%     title([num2str(k) ': ' name])
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(limg));    
    set(h,'alphadata',0.6)
    title([num2str(k) ': ' name])
    
    if ~mod(k,20)
        pause;
        close all;
    end                         
end

%% smooth the boundaries of the labeled images, looks nicer, but results worse
close all;
clear all;
clc;
iptsetpref('ImshowBorder','loose')
folderinl='..\cells\';
pixl=rdir([folderinl '*L2.mat']);
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
z=11;% smoothing factor
for k=1:length(pixl) 
    name=char(pixl(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    load(char(pixl(k).name))    
    
    b=bwboundaries(limg>0);        
    bw=ones(size(limg));
    for m=1:length(b) % for each shape boundary
        % pad and take average over z values, then crop to original size
        x=round(imcrop(colfilt(padarray(b{m},z-1,'circular'),[z 1],...
            'sliding',@mean),[1 z 2 size(b{m},1)-1]));
        bw(sub2ind(size(limg),x(:,1),x(:,2)))=0;
    end
    limg2=-bwlabel(bw,4);
    t=regionprops(limg,'Centroid');
    y=cellfun(@(x) sub2ind(size(limg),round(x(2)),round(x(1))),{t.Centroid});
    for m=1:max(max(limg))
        if sum(sum(limg==m))
            limg2(limg2==limg2(y(m)))=m;
        end
    end
    limg2(limg2<0)=0;
%     figure,imshow([label2rgb(limg) label2rgb(limg2)])
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(limg));    
    set(h,'alphadata',0.6)
    title([num2str(k) ': ' name])
    
    if ~mod(k,20)
        pause;
        close all;
    end          
end


%% Find junction features uses branchpoints2 - modularized
% uses shrink instead of skeleton, dilate instead of convhull
close all;
clear all;
clc;

iptsetpref('ImshowBorder','loose')
addpath('.\funcs');
folderinl='..\cells\';
pixl=rdir([folderinl '*L2.mat']);   
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
for k=1:length(pixl)  
    name=char(pixl(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    load(char(pixl(k).name))
    tic;
    [locs veins]=findJunctionsBranchpoints(limg);
    limg2=bwlabel(~veins.*imfill(veins,'holes'),4);
    limg3=relabel(limg,limg2);
    
    [junction_pos junction_labs jneighbs] = labelJunctions(locs,limg3); 
    [lveinsthin lveinsthick]=labelVeins(limg3,limg);
    junction_pos2=findExtJunctions(lveinsthin,junction_pos);
    toc;
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    
    figure;
    imshow(img);
    hold on;
    plot(junction_pos(junction_pos(:,2)>0,2),junction_pos(junction_pos(:,1)>0,1),'*r')
    title([num2str(k) ': ' name])
    
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(limg));    
    set(h,'alphadata',0.6)
    plot(junction_pos2(junction_pos2(:,2)>0,2),junction_pos2(junction_pos2(:,1)>0,1),'*m')
    title([num2str(k) ': ' name])
    
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(lveinsthin));    
    set(h,'alphadata',0.6)
    title([num2str(k) ': ' name])
     
    figure;
    imshow(img);
    hold on;
    h=imshow(label2rgb(lveinsthick));    
    set(h,'alphadata',0.6)
    title([num2str(k) ': ' name])
        
    
    if ~mod(k,4)
        pause;
        close all;            
    end
end
rmpath('./funcs');

%% Affine transform using junctions
close all;
clear all;
clc;
addpath('./funcs');
folderinl='..\cells\';
pixl=rdir([folderinl '*L2.mat']);   
folderin='..\img\';
% pix=rdir([folderin '*Lasioglossum pilosum*.jpg']);   
pix=rdir([folderin '*.jpg']);   
iptsetpref('ImshowBorder','loose')

% get template
k=1;
folderint='..\templates\';
tempp=rdir([folderint '*.jpg']);   
templ=rdir([folderint '*L2.mat']);   
img1=imread(char(tempp(k).name));
img1=rgb2gray(imresize(img1(:,:,1:3),.25));
load(char(templ(k).name))
name=char(tempp(k).name);
ind=strfind(name,filesep);
name1=name(ind(end)+1:end);
[locs veins]=findJunctionsBranchpoints(limg);
limg2=bwlabel(~veins.*imfill(veins,'holes'),4);
limg3=relabel(limg,limg2);
[junction_pos junction_labs jneighbs] = labelJunctions(locs,limg3);
limg_1=limg;
junction_pos_1=junction_pos;

% compare template to others
for k=1:length(pixl)            
    load(char(pixl(k).name))
    name=char(pix(k).name);
    ind=strfind(name,filesep);
    name=name(ind(end)+1:end);
    [locs veins]=findJunctionsBranchpoints(limg);
    limg2=bwlabel(~veins.*imfill(veins,'holes'),4);
    limg3=relabel(limg,limg2);
    
    [junction_pos junction_labs jneighbs] = labelJunctions(locs,limg3);
    [lveinsthin lveinsthick]=labelVeins(limg3,limg);    

    img2=imread(char(pix(k).name));
    img2=rgb2gray(imresize(img2(:,:,1:3),.25));
    
    loc1=junction_pos((junction_pos(:,2)>0)&(junction_pos_1(:,2)>0),[2 1]);
    loc2=junction_pos_1((junction_pos(:,2)>0)&(junction_pos_1(:,2)>0),[2 1]);        
    if numel(loc1)>4
        tform = cp2tform(loc1, loc2, 'affine');   
        img2T = imtransform(img2, tform,'nearest','XData', ...
            [1 (size(img1,2))],'YData', [1 (size(img1,1))]);
    %     img2T=AffineTransform(img2,junction_pos,junction_pos_1);           
        figure,imshow(cat(3,img1,img2T,zeros(size(img1))))
        title([num2str(k) ': ' name ' vs. ' name1])
    end
    
    
    if ~mod(k,20)
        pause;
        close all;            
    end
end
rmpath('./funcs');


%% Make a training set while labeling, (note: use select and test features to choose the classifying strategy)
close all;
clear all;
clc;

% filenames should follow the pattern:
% 'unique id' 'Genus' 'species' 'subspecies if applicable' 'gender' 'right
% or left wing' 'zoom or scale' x.jpg
% example: 001 Osmia lignaria m right 4x.jpg
% if it is unknown the scale/zoom and a unique id should still be known 
% example: 1397 Unknown unknown x right 3.2x.jpg 

iptsetpref('ImshowBorder','loose')
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
addpath('funcs','funcs\classifyfuncs')

feat_names=getrefinefeatsnames();
data=zeros(length(pix),size(feat_names,1));
id=zeros(1,length(pix));
genus=cell(1,length(pix));
species=cell(1,length(pix));
subspecies=cell(1,length(pix));
gender=cell(1,length(pix));
lrwing=cell(1,length(pix));
zoom=zeros(1,length(pix));
for k=1:length(pix)   
    % need zoom/scale to classify    
    [id(k) genus{k} species{k} subspecies{k} gender{k} lrwing{k} ....
        zoom(k)] =  parsefilename(char(pix(k).name));
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    tic;
    limg=ExtractCells(img);
    toc;
    
%     figure,imshow(label2rgb(limg))
%     title([num2str(k) ': ' name])

    limg2=limg;
    
    % label the segments 1-7 (sequentially, by clicking them), 
    % then label the something not belonging to the cells (if you are missing cell 2 label outside as cell 2, then relabel it as the eighth component)
    for n=1:8        
        [x,y] = ginput(1);
        limg2(limg2==limg2(round(y),round(x)))=-n;
    end
    close;
    limg2(limg2==-8)=0;
    limg2(limg2>0)=0;
    limg2=abs(limg2); 
    limg2=CleanCellBoundaries(limg2);
    
%     figure;
%     imshow(img);
%     hold on;
%     h=imshow(label2rgb(limg2));    
%     set(h,'alphadata',0.6)
%     title([num2str(k) ': ' name])
    
    % get features
    feat_vector=getrefinfeats(zoom(k),limg2);
    data(k,:)=feat_vector;
end
save('trainingdata.mat','data','id','genus','species','subspecies',...
    'gender','lrwing','zoom');
scaleoptions='nanzscore';% DataScaling, NormalMaxMagnitude, none
[data mu s]=scalefeatures(data,scaleoptions);
imputemethod='zeros';
data=impute(data,imputemethod);
featind=1:20;
save('readytrainingdata.mat','data','id','genus','species','subspecies',...
    'gender','lrwing','zoom','scaleoptions','mu','s','imputemethod',...
    'featind');
rmpath('.\funcs','.\funcs\classifyfuncs')

%% Make a training set with previously labeled cells, (note: use select and test features to choose the classifying strategy)
close all;
clear all;
clc;

% filenames should follow the pattern:
% 'unique id' 'Genus' 'species' 'subspecies if applicable' 'gender' 'right
% or left wing' 'zoom or scale' x.jpg
% example: 001 Osmia lignaria m right 4x.jpg
% if it is unknown the scale/zoom and a unique id should still be known 
% example: 1397 Unknown unknown x right 3.2x.jpg 

addpath('.\funcs','.\funcs\classifyfuncs')
iptsetpref('ImshowBorder','loose')
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
folderinl='..\cells\';
pixl=rdir([folderinl '*L2.mat']);   

feat_names=getrefinefeatsnames();
data=zeros(length(pix),size(feat_names,1));
id=zeros(1,length(pix));
genus=cell(1,length(pix));
species=cell(1,length(pix));
subspecies=cell(1,length(pix));
gender=cell(1,length(pix));
lrwing=cell(1,length(pix));
zoom=zeros(1,length(pix));
clear feat_names
for k=1:length(pix)   
    % need zoom/scale to classify    
    [id(k) genus{k} species{k} subspecies{k} gender{k} lrwing{k} ....
        zoom(k)] =  parsefilename(char(pix(k).name));
    
%     img=imread(char(pix(k).name));
%     img=imresize(img(:,:,1:3),.25);
    load(char(pixl(k).name))    
    limg2=CleanCellBoundaries(limg);
    
%     figure;
%     imshow(img);
%     hold on;
%     h=imshow(label2rgb(limg2));    
%     set(h,'alphadata',0.6)
%     title([num2str(k) ': ' name])
    
    % get features
    data(k,:)=getrefinefeats(zoom(k),limg2);
end
save('trainingdata.mat','data','id','genus','species','subspecies',...
    'gender','lrwing','zoom');
scaleoptions='nanzscore';% DataScaling, NormalMaxMagnitude, none
[data mu s]=scalefeatures(data,scaleoptions);
imputemethod='zeros';
data=impute(data,imputemethod);
featind=1:20;
save('readytrainingdata.mat','data','id','genus','species','subspecies',...
    'gender','lrwing','zoom','scaleoptions','mu','s','imputemethod',...
    'featind');
rmpath('.\funcs','.\funcs\classifyfuncs')

%% Classify an image
close all;
clear all;
clc;

% filenames should follow the pattern:
% 'unique id' 'Genus' 'species' 'subspecies if applicable' 'gender' 'right
% or left wing' 'zoom or scale' x.jpg
% example: 001 Osmia lignaria m right 4x.jpg
% if it is unknown the scale/zoom and a unique id should still be known 
% example: 1397 Unknown unknown x right 3.2x.jpg 

load('training_data')% training data, includes scaling info (mu/s), feature indices
classifyfnc=@knnclassify;

iptsetpref('ImshowBorder','loose')
folderin='..\img\';
pix=rdir([folderin '*.jpg']);
addpath('.\funcs');
for k=1:length(pix)   
    % need zoom/scale to classify
    [~,~,~,~,~,~,zoom] = parsefilename(char(pix(k).name));
    
    img=imread(char(pix(k).name));
    img=imresize(img(:,:,1:3),.25);
    tic;
    limg=ExtractCells(img);
    toc;
    
%     figure,imshow(label2rgb(limg))
%     title([num2str(k) ': ' name])

    limg2=limg;
    
    % label the segments 1-7 (sequentially, by clicking them), 
    % then label the something not belonging to the cells (if you are missing cell 2 label outside as cell 2, then relabel it as the eighth component)
    for n=1:8        
        [x,y] = ginput(1);
        limg2(limg2==limg2(round(y),round(x)))=-n;
    end
    close;
    limg2(limg2==-8)=0;
    limg2(limg2>0)=0;
    limg2=abs(limg2); 
    limg2=CleanCellBoundaries(limg2);
    
%     figure;
%     imshow(img);
%     hold on;
%     h=imshow(label2rgb(limg2));    
%     set(h,'alphadata',0.6)
%     title([num2str(k) ': ' name])
    
    % get features
    [feat_vector parts_inds num_parts]=getrefinfeats(zoom,limg2);
    % scale features
    norm_feats=bsxfun(@rdivide,bsxfun(@minus,feat_vector,mu),s);    
    % impute features
    feats=impute(norm_feats,imputemethod);
    
    % classify
    class = classifyfnc(feats, training, traininggroups);
    
    fprintf('Predicted class is %s', class);
    
    pause;
    
end
rmpath('.\funcs');
