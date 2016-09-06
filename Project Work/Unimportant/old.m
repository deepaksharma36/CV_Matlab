
index=size(c,1)*size(c,2);

cc_index=1:max(max(c));
az=zeros(size(cc_index'));
az=az+index;

bz=zeros(size(cc_index'));
cc_min_max=[cc_index',az ,bz];

for i=1:index
  if(c(i)>0)  
  if cc_min_max(c(i),2)>i
      cc_min_max(c(i),2)=i;
  end
  if cc_min_max(c(i),3)<i
      cc_min_max(c(i),3)=i;
  end
  end
end
cc_coordinate=[bz,bz,bz,bz];
width=size(c,2);
for i=1:size(cc_min_max,1)
    cc_coordinate(i,1)=abs(cc_min_max(i,2)/width);
    cc_coordinate(i,2)=rem(cc_min_max(i,2),width);
    cc_coordinate(i,3)=abs(cc_min_max(i,3)/width);
    cc_coordinate(i,4)=rem(cc_min_max(i,3),width);

end
useless=[];

for i=1:size(cc_coordinate,1)
    if abs(cc_coordinate(i,1)-cc_coordinate(i,3))>(1/1.5)*abs(cc_coordinate(i,2)-cc_coordinate(i,4))
        useless=[useless,i];
    end
    
    if abs(cc_coordinate(i,1)-cc_coordinate(i,3))<(1.5)*abs(cc_coordinate(i,2)-cc_coordinate(i,4))
        useless=[useless,i];
    end
end
useless;
for i=1:size(useless)
    if c==useless(1,i)
        c=0;
    end
end
figure,imagesc(c);
