function output=post_processing(im_org,c,un_rq_indicies,thr)
%After deciding the text CC received this method claculate distance between
%foreground and background, according to the method discussed in report and
%generate binary image. 
%
    %figure('Name','Removed Part'),imagesc(non_text);
    bg_indicies=fg_coordinates(c,mode(c(:)));
    %[bg_org_r, bg_org_g,bg_org_b]=im_org(bg_indicies);
    
    
    
    
    avg_bg_rgb=avg_bg(bg_indicies,im_org);
    [I,J] = ind2sub(size(c),un_rq_indicies);
    for counter=1:size(I,1)
        im_org(I(counter),J(counter),1)=avg_bg_rgb(1,1);
        im_org(I(counter),J(counter),2)=avg_bg_rgb(1,2);
        im_org(I(counter),J(counter),3)=avg_bg_rgb(1,3);
    end
    %figure('Name','After Manupulations'),imshow(im_org);
    %c(bg_indicies)=0;
    %bg_maha=fg_bg_model(im_org,bg_indicies);
    output=zeros(size(c));
    tols=[];
    for obj=1:max(max(c))
        fg_indicies=fg_coordinates(c,obj);
        
        if(size(fg_indicies,1)>5)
            avg_fg_data = avg_bg(fg_indicies,im_org);
            tol=abs(avg_fg_data-avg_bg_rgb);
            tol=round(tol(1,1)/avg_bg_rgb(1,1)+tol(1,2)/avg_bg_rgb(1,2)+tol(1,3)/avg_bg_rgb(1,3));
            tols=[tols;[obj,tol]];
            %fg_maha=fg_bg_model(im_org,fg_indicies);
            %output_temp = fg_maha < bg_maha;
            %output_temp=reshape(output_temp,size(c));
            %figure,imagesc(output_temp);     
            %output=output+output_temp;
        end
    end
        tols;
        thr=thr*(max(tols(:,2))-min(tols(:,2)));
        output=zeros(size(c));
        fg_lbl=[];
        bg_lbl=[];
        for counter=1:size(tols,1)
            %output_temp=zeros(size(c(:)));
            if tols(counter,2)>thr
               tols(counter,1);
               fg_lbl=[fg_lbl;tols(counter,1)];
               %output_temp=reshape(output_temp,size(c));
               %figure('Name','Nops'),imagesc(output_temp);
               %output=output+output_temp;
            else
                bg_lbl=[bg_lbl;tols(counter,1)];
            end
            
        end
    fg_indices=[];
    
    for counter=1:size(fg_lbl,1)    
        fg_indices= [fg_indices;   fg_coordinates(c,fg_lbl(counter))];
    end
    
    
    %fg_indices=[fg_indices;special_indices];
    output(fg_indices)=1;
    %figure('Name','Final'),imagesc(output);     
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% RECONSIDERATION %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %special_indices=[];
    %[I,J] = ind2sub(size(c),bg_indicies);
    
    %for counter=1:size(bg_indicies,1)
    %  size(im_org) ;
    %  rgb_data_r=im_org(I(counter),J(counter),1) ; 
    %  rgb_data_g=im_org(I(counter),J(counter),2) ; 
    %  rgb_data_b=im_org(I(counter),J(counter),3) ; 
    %  %rgb_data=[rgb_data_r,rgb_data_g,rgb_data_b];
    %  dis=[abs(rgb_data_r-avg_bg_rgb(1,1)) +abs(rgb_data_g-avg_bg_rgb(1,2)) +abs(rgb_data_b-avg_bg_rgb(1,3))];
    %  distance=dis(1,1)/avg_bg_rgb(1,1)+dis(1,2)/avg_bg_rgb(1,2)+dis(1,3)/avg_bg_rgb(1,3);
    %      if distance <  thr
     %         special  = sub2ind( size(c), round(I), round(J) );
     %         special_indices=[special_indices;special];
     %     end
              
    %end    
    
    
    end