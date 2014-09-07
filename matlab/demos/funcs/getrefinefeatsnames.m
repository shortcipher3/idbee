function feat_names=getrefinefeatsnames()
%% Assemble names of the features
%     D((i-1)*(m-i/2)+j-i)   

numjuncts=18;
numsegs=7;
m=numjuncts+numsegs;

pNames=cell(m,1);% names of junctions/Centroids
for k=1:numjuncts% for each junction
    pNames{k}=strcat({'junct '}, num2str(k));
end
for k=numjuncts+(1:numsegs)% for each centroid
    pNames{k}=strcat({'Centroid '}, num2str(k-numjuncts));
end
m2=nchoosek(m,2);
Dj2cNames=cell(m2,1);% names of distances between junctions & centroids
for i=1:m
    for j=(i+1):m
        if j==i
            continue;
        else
            Dj2cNames{(i-1)*(m-i/2)+j-i}=...
                strcat(pNames{i},'_to_',pNames{j});
        end
    end
end
Dj2crNames=cell(nchoosek(m2,2),1);% names of distance ratios
for i=1:m2
    for j=(i+1):m2
        if j==i
            continue;
        else
            Dj2crNames{(i-1)*(m2-i/2)+j-i}=...
                strcat(Dj2cNames{i},':',Dj2cNames{j});
        end
    end
end
% sum(cellfun(@isempty,Dj2crNames))

AjcNames=cell(3*nchoosek(m,3),1);% names of angles
m3=m-1;
zstep=nchoosek(m3,2);
for z=1:m
    pNamesTemp=pNames([1:(z-1) (z+1):m]);
    for i=1:m3
        for j=(i+1):m3
            if j==i
                continue;
            else
                AjcNames{(i-1)*(m3-i/2)+j-i+zstep*(z-1)}=...
                    strcat(pNamesTemp{i},'_to_',pNames{z},'_to_',pNamesTemp{j});
            end
        end
    end
end

numveins=20;
veinlenNames=cell(numveins,1);% names of vein lengths
veindistNames=cell(numveins,1);% names of vein distance
veindistlenrNames=cell(numveins,1);% names of vein distance to vein length ratios
for i=1:numveins
    veinlenNames{i}=strcat('Vein_',num2str(i),'_length');
    veindistNames{i}=strcat('Vein_',num2str(i),'_Edistance');
    veindistlenrNames{i}=strcat('Vein_',num2str(i),'_Edistance:length ratio');
end

numcells=7;
cellAreaRNames=cell(nchoosek(numcells,2),1);% cell area ratio names
cellPerRNames=cell(nchoosek(numcells,2),1);% cell perimeter ratio names
m4=numcells;
for i=1:m4
    for j=(i+1):m4
        if j==i
            continue;
        else
            cellAreaRNames{(i-1)*(m4-i/2)+j-i}=...
                strcat('cell_',num2str(i),'_to_cell_',num2str(j),'_area');
            cellPerRNames{(i-1)*(m4-i/2)+j-i}=...
                strcat('cell_',num2str(i),'_to_cell_',num2str(j),'_perimeter');
        end
    end
end

cellCentroidNames=cellfun(@(x) strcat('Centroid_cell_',x),cellstr(...centroid position names
    num2str(reshape([1:numcells;1:numcells],1,numcells*2)')),'UniformOutput',false);
cellCentroidNames(1:2:end)=strcat(cellCentroidNames(1:2:end),'_x');
cellCentroidNames(2:2:end)=strcat(cellCentroidNames(2:2:end),'_y');

cellbbNames=cellfun(@(x) strcat('BoundingBox_cell_',x),cellstr(...bounding box names
    num2str(reshape([1:numcells;1:numcells;1:numcells;1:numcells],...
    1,numcells*4)')),'UniformOutput',false);
cellbbNames(1:4:end)=strcat(cellbbNames(1:4:end),'_x');
cellbbNames(2:4:end)=strcat(cellbbNames(2:4:end),'_y');
cellbbNames(3:4:end)=strcat(cellbbNames(3:4:end),'_width');
cellbbNames(4:4:end)=strcat(cellbbNames(4:4:end),'_height');

cellextrNames=cellfun(@(x) strcat('Extrema_cell_',x),cellstr(...extrema names
    num2str(reshape(repmat(1:numcells,16,1),1,numcells*16)')),...
    'UniformOutput',false);
cellextrNames(1:2:end)=strcat(cellextrNames(1:2:end),'_x');
cellextrNames(2:2:end)=strcat(cellextrNames(2:2:end),'_y');
cellextrNames=strcat(cellextrNames,'_number_',cellstr(num2str(repmat(1:16,1,numcells)')));

numdesc=5;
FSDsNames=cellfun(@(x) strcat('Fourier Shape Descriptors_cell_',x),...FSDs names
    cellstr(num2str(reshape(repmat(1:numcells,4*numdesc,1),1,...
    numcells*4*numdesc)')),'UniformOutput',false);
FSDsNames=strcat(FSDsNames,'_desc_',cellstr(num2str(repmat(...
    reshape(repmat(1:numdesc,4,1),1,numdesc*4),1,numcells)')));
FSDsNames=strcat(FSDsNames,'_number_',cellstr(num2str(...
    repmat(1:4,1,numcells*numdesc)')));

halfmagFSDsNames=cellfun(@(x) strcat('Fourier Shape Descriptors_half_mag_cell_',x),...FSDs names
    cellstr(num2str(reshape(repmat(1:numcells,2*numdesc,1),1,...
    numcells*2*numdesc)')),'UniformOutput',false);
halfmagFSDsNames=strcat(halfmagFSDsNames,'_desc_',cellstr(num2str(repmat(...
    reshape(repmat(1:numdesc,2,1),1,numdesc*2),1,numcells)')));
halfmagFSDsNames=strcat(halfmagFSDsNames,'_number_',cellstr(num2str(...
    repmat(1:2,1,numcells*numdesc)')));


magFSDsNames=cellfun(@(x) strcat('Fourier Shape Descriptors_mag_cell_',x),...FSDs names
    cellstr(num2str(reshape(repmat(1:numcells,numdesc,1),1,...
    numcells*numdesc)')),'UniformOutput',false);
magFSDsNames=strcat(magFSDsNames,'_desc_',cellstr(num2str(repmat(...
    1:numdesc,1,numcells)')));

feat_names=[
    'zoom'; ... 1
    cellfun(@(x) strcat('vein len_',x),cellstr(num2str((1:20)')),'UniformOutput',false);... 20
    cellfun(@(x) strcat('vein len E_',x),cellstr(num2str((1:20)')),'UniformOutput',false);... 20
    cellfun(@(x) strcat('vein len ratio_',x),cellstr(num2str((1:20)')),'UniformOutput',false);... 20
    cellfun(@(x) strcat('avg vein width_',x),cellstr(num2str((1:20)')),'UniformOutput',false);... 20
    Dj2cNames; ... 300
    cellfun(@(x) strcat(x,'_zoom'),Dj2cNames); ... 300    
    Dj2crNames; ... 44850    
    cellfun(@(x) strcat(x,'_x'),Dj2cNames); ... 300
    cellfun(@(x) strcat(x,'_x_zoom'),Dj2cNames); ... 300
    cellfun(@(x) strcat(x,'_x'),Dj2crNames); ... 44850
    cellfun(@(x) strcat(x,'_y'),Dj2cNames); ... 300
    cellfun(@(x) strcat(x,'_y_zoom'),Dj2cNames); ... 300
    cellfun(@(x) strcat(x,'_y'),Dj2crNames); ... 44850    
    AjcNames; ... 6900
    cellfun(@(x) strcat('Area_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Area_z2_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellAreaRNames; ... 21
    cellbbNames; ... 28
    cellCentroidNames; ... 14
    cellfun(@(x) strcat('ConvexArea_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Eccentricity_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Extent_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellextrNames; ... 7*16=112
	cellfun(@(x) strcat('MajorAxis_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('MinorAxis_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Major_to_Minor_Axis_ratio_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Orientation_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellfun(@(x) strcat('Perimeter_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    cellPerRNames; ... 21
	cellfun(@(x) strcat('Solidity_seg_',x),cellstr(num2str((1:7)')),'UniformOutput',false); ... 7
    FSDsNames; ... 4*5*7 140
    halfmagFSDsNames; ... 70
    magFSDsNames; ... 35
    ];        
end


