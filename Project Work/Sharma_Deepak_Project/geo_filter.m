function [image ,unwanted]=geo_filter(image)
% Implemnation of geomatric filter
area=[];
length=[];
width=[];
unwanted=[];
dim=[];
imageArea=size(image,1)*size(image,2);
bg=mode(image(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Round 1 

for obj=1:max(max(image))
    if obj~=bg
        fg_indices=fg_coordinates(image,obj);
        [I,J] = ind2sub(size(image),fg_indices);
        minI=min(I);
        minJ=min(J);
        maxI=max(I);
        maxJ=max(J);
        major=max([maxJ-minJ,maxI-minI]);
        minor=min([maxJ-minJ,maxI-minI]);
        major_tilted=CalcDistance([minI,minJ],[maxI,maxJ]);
        
        %fg_maha=fg_bg_model(im_org,fg_indicies);
        %output_temp = fg_maha < bg_maha;
        %output_temp=reshape(output_temp,size(c));
        %output=output+output_temp;
        component=zeros(size(image)) ;
        component(fg_indices)=1;
        stats = regionprops('table',component,'Centroid','MajorAxisLength','MinorAxisLength');
        minor_tilted=stats.MinorAxisLength;
        major_tilted=stats.MajorAxisLength;
        if size(fg_indices,1)<10
            
            unwanted=[unwanted;fg_indices];
            %figure,imagesc(component)
            %title('Size');
        elseif maxJ-minJ>.8*size(image,2)
            %image(fg_indices)=-1;
            unwanted=[unwanted;fg_indices];
            %figure,imagesc(component)
            %title('height');
        elseif  major_tilted>.8*size(image,1)
            %image(fg_indices)=-1;
            unwanted=[unwanted;fg_indices];
            %figure,imagesc(component)
            %title('Width');
        elseif  major_tilted/minor_tilted  > 30
               image(fg_indices)=-1;
               unwanted=[unwanted;fg_indices];
              %figure,imagesc(component)
              %disp('Ratio for');
              %obj
              %title('ratio');
        elseif  (maxJ-minJ)/(maxI-minI)  > 1.8
               %image(fg_indices)=-1;    
               unwanted=[unwanted;fg_indices];
               %figure,imagesc(component)
               %title('lower ratio');
        elseif minJ-5<0 
                unwanted=[unwanted;fg_indices];
        elseif maxJ+5>size(image,2)        
            unwanted=[unwanted;fg_indices];
        elseif minI-5 <0
            unwanted=[unwanted;fg_indices];
        
        elseif maxI+5>size(image,1)        
            unwanted=[unwanted;fg_indices];   
        elseif major_tilted<16    
            unwanted=[unwanted;fg_indices];   
            %figure,imagesc(component)
            %title('16');
        elseif major_tilted*minor_tilted<90
            unwanted=[unwanted;fg_indices];   
            %figure,imagesc(component)
            %title('M*Min');
        elseif (maxJ-minJ)/(maxI-minI) >2 && size(fg_indices,1)<2*(major_tilted+minor_tilted)     
            unwanted=[unwanted;fg_indices];   
            
        elseif (maxI-minI)/(maxJ-minJ) >1 && size(fg_indices,1)<2*(major_tilted+minor_tilted)     
            %unwanted=[unwanted;fg_indices];       
        else
            cc_area=size(fg_indices,1);
            area=[area;[obj,size(fg_indices,1)]];
            length=[length;[obj,maxI-minI]];
            width=[width;[obj,maxJ-minJ]];
            dim=[dim;obj, minI,maxI,minJ,maxJ];
            %width=[width;[obj,stats.MinorAxisLength]];
            %m=int2str(round(stats.MinorAxisLength));
            %M=int2str(round(stats.MinorAxisLength));
            %str=strcat('Survived:',int2str(obj),'L',int2str(maxI-minI),'W',int2str(maxJ-minJ));
            %figure,imagesc(component), hold on;
            %plot( minJ,minI, 'mo', 'MarkerSize', 10, 'LineWidth', 2 );

            %plot( maxJ,maxI, 'mo', 'MarkerSize', 10, 'LineWidth', 2 );
            %title(str);
            

        end 
    end    
end

%component=zeros(size(image));
%    component(unwanted)=1;
%figure('Name','Removed By Upper Rules'),imagesc(component);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Round 2
if(size(area,1)>1)
    max_area=max(area);
    avg_area=mean(area(:,2));
    avg_length=mean(length(:,2));
    avg_width=mean(width(:,2));
    %minI,maxI,minJ,maxJ
    %%% removing CC which are inside other CC
    for counter=1:size(area,1)
        for inCounter=1:size(area,1)
           if(area(inCounter,2)<5*avg_area) 
            if (dim(counter,2)>dim(inCounter,2) && dim(counter,3)<dim(inCounter,3)&& dim(counter,4)>dim(inCounter,4)&& dim(counter,5)<dim(inCounter,5))
                unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
             %%%%% Removing CC which are partianly inside other CC    
            elseif(dim(counter,2)>dim(inCounter,2)+5 && dim(counter,3)+5<dim(inCounter,3) && dim(counter,4)<dim(inCounter,5)+10 && dim(counter,5)>dim(inCounter,5)  )     
                unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
           end
           end
        end
        
 
        if area(counter,2)>10*avg_area
            unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
            %image(fg_coordinates(image,area(counter,1)))=-1;
             %disp('Areas gtr Than 10');
        elseif  area(counter,2)<.05*avg_area  
            unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
            %disp('Areas Less Than .1');
            %component=zeros(size(image)) ;

            %areaLessInd=fg_coordinates(image,area(counter,1));
            %component(areaLessInd)=1;

            %figure,imagesc(component)
            %title('Area Less');
            %image(fg_coordinates(image,area(counter,1)))=-1;

        elseif  length(counter,2)/width(counter,2)>10*avg_length/avg_width;
              %unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
         elseif  length(counter,2)/width(counter,2)<.1*avg_length/avg_width;
              %unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
        end
    end
    
end

if(size(area,1)>1)

    avg_length=mean(length(:,2));
    avg_width=mean(width(:,2));
    %minI,maxI,minJ,maxJ
   
    for counter=1:size(area,1)
        if  length(counter,2)>5*avg_length;
              unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
         elseif  width(counter,2)>5*avg_width;
              unwanted=[unwanted;fg_coordinates(image,area(counter,1))];
        end
    end
    
end
%unwanted_temp=[unwanted, ]
%component=zeros(size(image));
%    component(unwanted)=1;
%figure('Name','Removed By down Rules'),imagesc(component);

end

function dis= CalcDistance(p1,p2)
    %this function calculate distance between two points.
    dis=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
end