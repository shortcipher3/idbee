function indices=getSegmentFeatureIndices(parts,seg2rem)
indices=[];
for k=1:length(seg2rem)
    indices=[indices (parts(seg2rem(k)+2)+1):parts(seg2rem(k)+3)];
end
end