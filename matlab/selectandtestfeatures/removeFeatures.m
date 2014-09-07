
% remove segments and their associated features
seg2rem=[1 2 3 7 8 9 10 11 12];% -1, 0, 13 are bonus features img, wing, bee
ind=getSegmentFeatureIndices(parts,seg2rem);
featurenames(ind,:)=[];
samples_data(:,ind)=[];

% remove features by name
% featurenames2={'Bounding Box X Width (seg 9)';... adding mm loses 1 pic
%     'mm per pixel';...
%     'Fourier Descriptor 5.1/1.2 Magnitude (seg 10)';...
%     'E-Dist seg 10 Centroid to seg 5 Centroid mm';...
%     'E-Dist Centroid to BB UL Corner (seg 9)'};
featurenames2={'X-Dist seg 7 Centroid to seg 5 Centroid mm';'Y-Dist seg 7 Centroid to seg 5 Centroid mm';'X-Dist seg 7 Centroid to seg 5 Centroid';'Y-Dist seg 7 Centroid to seg 5 Centroid';'E-Dist seg 7 Centroid to seg 5 Centroid mm';'E-Dist seg 7 Centroid to seg 5 Centroid';'X-Dist seg 8 Centroid to seg 5 Centroid mm';'Y-Dist seg 8 Centroid to seg 5 Centroid mm';'X-Dist seg 8 Centroid to seg 5 Centroid';'Y-Dist seg 8 Centroid to seg 5 Centroid';'E-Dist seg 8 Centroid to seg 5 Centroid mm';'E-Dist seg 8 Centroid to seg 5 Centroid';'X-Dist seg 9 Centroid to seg 5 Centroid mm';'Y-Dist seg 9 Centroid to seg 5 Centroid mm';'X-Dist seg 9 Centroid to seg 5 Centroid';'Y-Dist seg 9 Centroid to seg 5 Centroid';'E-Dist seg 9 Centroid to seg 5 Centroid mm';'E-Dist seg 9 Centroid to seg 5 Centroid';'X-Dist seg 10 Centroid to seg 5 Centroid mm';'Y-Dist seg 10 Centroid to seg 5 Centroid mm';'X-Dist seg 10 Centroid to seg 5 Centroid';'Y-Dist seg 10 Centroid to seg 5 Centroid';'E-Dist seg 10 Centroid to seg 5 Centroid mm';'E-Dist seg 10 Centroid to seg 5 Centroid';'X-Dist seg 6 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'Y-Dist seg 6 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'E-Dist seg 6 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'X-Dist seg 7 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'Y-Dist seg 7 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'E-Dist seg 7 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'X-Dist seg 8 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'Y-Dist seg 8 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'E-Dist seg 8 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'X-Dist seg 9 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'Y-Dist seg 9 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'E-Dist seg 9 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'X-Dist seg 10 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'Y-Dist seg 10 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'E-Dist seg 10 Cent to seg 5 Cent:seg 4 to seg 5 ratio';'seg 7:5 ratio';'seg 8:5 ratio';'seg 9:5 ratio';'seg 10:5 ratio';'seg 7:4 ratio';'seg 8:4 ratio';'seg 9:4 ratio';'seg 10:4 ratio';'seg 6:10 ratio';'seg 7:10 ratio';'seg 8:10 ratio';'seg 9:10 ratio';};
ind=getFeatureIndicesByName(featurenames,featurenames2);
featurenames(ind,:)=[];
samples_data(:,ind)=[];

