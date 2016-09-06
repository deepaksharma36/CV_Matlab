function status =HW10_BottleChecker(image)
        close all;
        addpath('../TEST_IMAGES');
        image=imread(image);
        image=imcrop(image,[round(size(image,2)/3),1,round(size(image,2)/3),size(image,1)]);
      

        image_R=image(:,:,1);
        image_B=image(:,:,3);
        %imagesc(image_B);
        status=false;
        %checking if bottle exist or missing
        if(Empty(image_B, image_R)==true)
            disp('empty')
            status=true;
        %checking cap is missing
        elseif (checkCap(image_B)==false)
            disp('noCap');
        %checking for over filled bottle
        elseif (checkCook(image_R)==false)
            disp('OverFiled');
        %checking for under filled bottle
        elseif (checkLowCook(image_R)==false)
            disp('Less Filed');
      
        %checking for Label 
        elseif (checklbl(image_R)==false)
            disp('no lbl');
        %checking for not printed lable
        elseif (checkWhitelbl(image_B)==false)
            disp('White lbl');
        else
            status=true;
        end
end

function status= checkCap(image_B)
    image_B=imcrop(image_B,[1,1,size(image_B,2),50]);
    %figure,imagesc(image_B);
    [row,col]=find(image_B<=100);
    value=size(row,1);
    if value<1900
        status=false;
    else
        status=true;
    end
   
end



function status= checkCook(image_R)
    image_R=imcrop(image_R,[1,60,size(image_R,2),134-60]);
    %figure,imagesc(image_R);
    [row,col]=find(image_R<=100);
    value=size(row,1);
    if value>350
        status=false;
    else
        status=true;
    end
   
end

function status= checkLowCook(image_R)
    image_R=imcrop(image_R,[1,140,size(image_R,2),183-140]);
    %figure,imagesc(image_R);
    [row,col]=find(image_R<=100);
    value=size(row);
    if value<1000
        status=false;
    else
        status=true;
    end
   
end

function status= checklbl(image_R)
    image_R=imcrop(image_R,[1,183,size(image_R,2),268-183]);
    %figure,imagesc(image_R);
    [row,col]=find(image_R<=80);
    disp('For no lbl');
    value=size(row,1);
    if value>1000
        status=false;
    else
        status=true;
    end
end
function status= checkWhitelbl(image_B)
    %image_R=imcrop(image_R,[1,183,size(image_R,2),268-183]);
    image_B=imcrop(image_B,[1,183,size(image_B,2),268-183]);
    %figure,imagesc(image_B);
    [row,col]=find(image_B>=150);
    [row_r,col_r]=find(image_B<=50);
    value=size(row,1);
    %value_red=size(row_r,1)
    if value>4000 
        status=false;
    else
        status=true;
    end

    
end

function status= Empty(image_B,image_R)
    %image_B=imcrop(image_B,[1,1,size(image_B,2),50]);
    %figure,imagesc(image_B);
    [row,col]=find(image_B>=150);
    disp('Empty')
    value=size(row,1);
    if value>18000 && checkCap(image_B)==false && checkLowCook(image_R)==false
        status=true;
    else
        status=false;
    end
   
end
