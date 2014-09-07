
%% ended up using mRMR code to determine max relevancy min redundancy feats
%% Assess the usefulness of features for detecting which segment it is
%% Assess the usefulness of features for detecting which class of bees it
%% belongs to
%% Tell me which features help identify which segments and give me a
%% weighting for how useful they are

%% this is my attempt to semi-manually look at the features, not done, but
%% may not be necessary (may be better ways to do)
close all;
clear all;
for k=1:13 % for each segment (legit and illegit)
    load(['segment' num2str(k) 'features'])
%     mystuff{6}{1}{3};
    %segment
end
plot(segment_features((segment_features(:,3)==12).*(segment_features(:,4)==1),5))
plot(segment_features((segment_features(:,3)==7&&segment_features(:,4)==1),5))




k=5;
% for k=40:150;
    % correlation with segment?
figure;hold on;
plot(segment_features(logical((segment_features(:,3)==1).*(segment_features(:,4)==1)),k),'b')
plot(segment_features(logical((segment_features(:,3)==2).*(segment_features(:,4)==1)),k),'r')
plot(segment_features(logical((segment_features(:,3)==3).*(segment_features(:,4)==1)),k),'k')
plot(segment_features(logical((segment_features(:,3)==4).*(segment_features(:,4)==1)),k),'y')
plot(segment_features(logical((segment_features(:,3)==5).*(segment_features(:,4)==1)),k),'m')
plot(segment_features(logical((segment_features(:,3)==6).*(segment_features(:,4)==1)),k),'c')
figure;hold on;
plot(segment_features(logical((segment_features(:,3)==7).*(segment_features(:,4)==1)),k),'g')
plot(segment_features(logical((segment_features(:,3)==8).*(segment_features(:,4)==1)),k),'b')
plot(segment_features(logical((segment_features(:,3)==9).*(segment_features(:,4)==1)),k),'r')
plot(segment_features(logical((segment_features(:,3)==10).*(segment_features(:,4)==1)),k),'k')
plot(segment_features(logical((segment_features(:,3)==11).*(segment_features(:,4)==1)),k),'y')
plot(segment_features(logical((segment_features(:,3)==12).*(segment_features(:,4)==1)),k),'m')
% plot(segment_features(logical((segment_features(:,3)==13).*(segment_features(:,4)==1)),k),'c')

% correlation with class?
for m=1:12
figure;
k=7;
x=logical((segment_features(:,3)==m).*(segment_features(:,4)==1));
plotyy(1:sum(x),segment_features(x,k),1:sum(x),segment_features(x,2));
title(num2str(m))
end
pause;
close all;
% end

% correlation with genus?
genus=segment_features(:,2);
genus(genus<4)=1;
genus(logical((genus>3).*(genus<13)))=3;
genus(genus==13)=4;
genus(genus>13)=5;
for m=1:12
figure;
k=7;
x=logical((segment_features(:,3)==m).*(segment_features(:,4)==1));
plotyy(1:sum(x),segment_features(x,k),1:sum(x),genus(x,2));
title(num2str(m))
end

for k=1:200 % segment, works, kth feature
    k
[1 mean(segment_features(logical((segment_features(:,3)==1).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==1).*(segment_features(:,4)==1)),k));
2 mean(segment_features(logical((segment_features(:,3)==2).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==2).*(segment_features(:,4)==1)),k));
3 mean(segment_features(logical((segment_features(:,3)==3).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==3).*(segment_features(:,4)==1)),k));
4 mean(segment_features(logical((segment_features(:,3)==4).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==4).*(segment_features(:,4)==1)),k));
5 mean(segment_features(logical((segment_features(:,3)==5).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==5).*(segment_features(:,4)==1)),k));
6 mean(segment_features(logical((segment_features(:,3)==6).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==6).*(segment_features(:,4)==1)),k));
7 mean(segment_features(logical((segment_features(:,3)==7).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==7).*(segment_features(:,4)==1)),k));
8 mean(segment_features(logical((segment_features(:,3)==8).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==8).*(segment_features(:,4)==1)),k));
9 mean(segment_features(logical((segment_features(:,3)==9).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==9).*(segment_features(:,4)==1)),k));
10 mean(segment_features(logical((segment_features(:,3)==10).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==10).*(segment_features(:,4)==1)),k));
11 mean(segment_features(logical((segment_features(:,3)==11).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==11).*(segment_features(:,4)==1)),k));
12 mean(segment_features(logical((segment_features(:,3)==12).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==12).*(segment_features(:,4)==1)),k));
13 mean(segment_features(logical((segment_features(:,3)==13).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,3)==13).*(segment_features(:,4)==1)),k))]
pause;
end

for k=1:200 % class segment, works, kth feature
%     for m=1:12
    k
%     m=9;
[1 mean(segment_features(logical((segment_features(:,2)==1).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==1).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
2 mean(segment_features(logical((segment_features(:,2)==2).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==2).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
3 mean(segment_features(logical((segment_features(:,2)==3).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==3).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
4 mean(segment_features(logical((segment_features(:,2)==4).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==4).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
5 mean(segment_features(logical((segment_features(:,2)==5).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==5).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
6 mean(segment_features(logical((segment_features(:,2)==6).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==6).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
7 mean(segment_features(logical((segment_features(:,2)==7).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==7).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
8 mean(segment_features(logical((segment_features(:,2)==8).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==8).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
9 mean(segment_features(logical((segment_features(:,2)==9).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==9).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
10 mean(segment_features(logical((segment_features(:,2)==10).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==10).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
11 mean(segment_features(logical((segment_features(:,2)==11).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==11).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
12 mean(segment_features(logical((segment_features(:,2)==12).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==12).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));
13 mean(segment_features(logical((segment_features(:,2)==13).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k)) std(segment_features(logical((segment_features(:,2)==13).*(segment_features(:,3)==m).*(segment_features(:,4)==1)),k));]
pause;
%     end
end




