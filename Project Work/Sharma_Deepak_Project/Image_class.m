%this method calls geomatric filter and manupulate/remove non text elements after 
%the exection of Geomatric filter
function [c,un_rq_indicies]=Image_class(c,im_org)
    
    edge_indicies=fg_coordinates(c,0);
    %c=edgeAdjestment(edge_indicies,c);
    %c(edge_indicies)=mode(c(:));
    %figure('Name','Edge Value adjestment'),imagesc(c)
    [c,un_rq_indicies]=geo_filter(c);
    
    un_rq_indicies=[un_rq_indicies;edge_indicies];
    c(un_rq_indicies)=mode(c(:));
    
    % after performing the Geomatric filter it removes too small objects 
    bg_ind=mode(c(:));
    area=[];
    unwanted=[];
    for i=1:max(c(:))
        if i~=bg_ind
            fg_size=size(fg_coordinates(c,i),1);
            area=[area;i,fg_size];
        end
    end
    if(size(area,1)>0)
        maxArea=max(area(:,2));
        for i=1:size(area,1)
            if(area(i,2)< maxArea/30)
                unwanted=[unwanted;area(i,1)];
    
            end
        end 
        
     notRequired=[];   
     for i=1:size(unwanted)   
         notRequired=[notRequired;fg_coordinates(c,unwanted(i,1))];
     end
     %figure('Name','Area Less by befor'),imagesc(c);
     %c(notRequired)=mode(c(:));
     %figure('Name','Area Less by After'),imagesc(c);
     %component=zeros(size(image));
     %component(notRequired)=1;
     %figure('Name','Area Less by 10'),imagesc(component);
     un_rq_indicies=[un_rq_indicies; notRequired];
     
     
    end
end
    
    
    %imb=im2bw(output);
    %


