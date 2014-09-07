function limg=CleanCellBoundaries(limg)

s = regionprops(limg, 'Orientation', 'MajorAxisLength', 'Centroid');    

for m = 1:7%length(s)
    if sum(sum(limg==m))>100
        xbar = s(m).Centroid(1);
        ybar = s(m).Centroid(2);

        a = s(m).MajorAxisLength/2;
        theta = -pi*s(m).Orientation/180;
        % fill based on 2/3 major axis length
        fillspot=[round(xbar),round(ybar)];
        if ~sum([fillspot<0 fillspot(1)>size(limg,1) fillspot(2)>size(limg,2)])
            limg(starfill3(limg==m,fillspot))=m;                
        end            
        dist23=a*2/3;
        fillspot=[round(xbar+dist23*cos(theta)),round(ybar+dist23*sin(theta))];
        if ~sum([fillspot<0 fillspot(1)>size(limg,1) fillspot(2)>size(limg,2)])
            limg(starfill3(limg==m,fillspot))=m;
        end
        fillspot=[round(xbar-dist23*cos(theta)),round(ybar-dist23*sin(theta))];
        if ~sum([fillspot<0 fillspot(1)>size(limg,1) fillspot(2)>size(limg,2)])
            limg(starfill3(limg==m,fillspot))=m;
        end            
    end
end

end