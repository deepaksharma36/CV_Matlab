function oldVersion

close all;
filename='38.jpg';
im=imread(filename);
figure('Name','Original'),imagesc(im);
%if(size(im,1)>512 && size(im,2)>512);
im=imresize(im,[512,512]);
%end
%67 39 need contrast enhancement
im_org=im;

im=imgaussfilt(im, 1);
%im=rgb2hsv(im);
%im=im(:,:,1);
im=rgb2gray(im);
im_gray=im;

im=255*im2double(im);
figure('Name','Gray'),imagesc(im);
disp('entropy');
ent=entropy(im_gray)
avgfilter=[1 1 1
    1 2 1
    1 1 1];
im=imfilter(im, avgfilter);
figure('Name','Smooth'),imagesc(im);
im=Greyscale_extension(im);

figure('Name','Scaled'),imagesc(im);
[im_nc , angle_nc]=Sobel1(im);
%im_nc=im_nc/max(max(im_nc));

im_nc=preProcessing_fake_edge(im_nc,3.5);

figure('Name','EdgeNC'),imshow(im_nc), hold on;

%figure('Name','No Fake'),imagesc(im_nc);

preProcessing_corner(im_nc)

if(ent<7)
    %im=255./(1+exp((mean(im(:))-im)/15));
end

figure('Name','Constrasted'),imshow(im/255);
%im=im2bw(im);
%im=imdilate(im,[1,1 ; 1, 1;1,1]);
[im , angle]=Sobel1(im);


%im=combine(im,im_nc);
thr=1.4;
results=zeros(size(im));
im_fix=im;
p=512*512;
while(thr>1.4)
    
    im=preProcessing_fake_edge(im_fix , thr);
    
    im_cp=1-im;
    
    %figure('Name','Reversed'),imshow(im_cp);
    c_in=zeros(size(im));
    c_in = bwlabel(im_cp);
    [c,un_rq_indicies]=Image_class(c_in,im_org);
    
    if max(max(c))< 1.8*p
        %figure('Name','After Geometric'),imagesc(c);
        results=combineLabel(results,c);
        p=max(max(c));
    end
    thr=thr-.2;
    
end
figure('Name','EdgesContrasted'),imagesc(results);
bg=mode(results(:));
final = zeros(size(results));

final(results~=bg)=1;

imopen(final,[1 1;1 1]);

figure('Name','Output'),imagesc(final);
c=bwlabel(final);
    
%im=im/max(max(im));
%im=im+im_nc;
%im=im/(max(im(:))-min(im(:)));
%figure('Name','Edges Shifted'),imshow(im);
%[im ]=preProcessing_mag(im, .9);

%figure('Name','Edges Adjested'),imshow(im), hold on;

%[im]=preProcessing_angle(im, angle);
%[im]=preProcessing_corner(im);
%im=histeq(im);

%im=preProcessing_mag(im,.3);
%im=im2bw(im);
%im_edges=imclose(im_edges,[1,1;1 1]);

%im=imopen(im,[1,1]);
%im=imclose(im,[1;1;1]);

%figure,imshow(im_edges);
%c = bwlabel(im);

%[c,un_rq_indicies]=Image_class(c,im_org);

%output=post_processing(im_org,results,un_rq_indicies,.15);
%c = bwlabel(output);
[c,un_rq_indicies]=Image_class(c,im_org);
figure('Name','Sencond Label'),imagesc(c)
output=post_processing(im_org,c,un_rq_indicies,.15);


figure('Name','???'),imshow(output);
%saving output as image
output=strcat(filename,'_output.fig') ;   
savefig(output);
outputJPG=strcat(filename,'_output.jpg') ;   
outputfig=openfig(output,'new','invisible');
saveas(outputfig,outputJPG,'jpg')
close(outputfig);
end


function im=combine(im1,im2)
    im=zeros(size(im1,1));
    for i=1:size(im1,2)
        for j=1:size(im2)
            if(im2(i,j)>im1(i,j))
                im(i,j)=1.7*im2(i,j);
            else    
            im(i,j)=max(im1(i,j),im2(i,j));
            end
        end
    end
    figure('Name','combineEdg'),imagesc(im);
end

function im=combineLabel(im1,im2)
    im=zeros(size(im1,1));
    bg1=mode(im1(:));
    bg2=mode(im2(:));
    %if bg1<bg2
   im1(fg_coordinates(im1,bg1))=0;
    %elseif bg1>bg2
   im2(fg_coordinates(im2,bg2))=0;
   % end    
    for i=1:size(im1,2)
        for j=1:size(im2)
           
            im(i,j)=max(im1(i,j),im2(i,j));
            
        end
    end
    %figure('Name','Result'),imagesc(im);
end
function mag  = preProcessing_mag(mag, range)
%this function remote magnitude which dont fall in top 20%

thrshold=0;
mag_col=mag(:); 
%shorted the magnitude col vector
mag_col_sorted=sort(mag_col);
limit=.09;%%tile of edge mag
adjested=0; %flag
while(adjested==0 && limit>.001)
    while thrshold <limit
        %find the index of top 5 for generating threshold
        top_value_index=round(size(mag_col_sorted,1)*range);
        thrshold=mag_col_sorted(size(mag_col_sorted,1)-top_value_index);
        %remoted the magnitudes below the threshold
        range=range-.005;
    end
    for counter=1:size(mag_col,1)
        if mag_col(counter)<thrshold
            mag_col(counter)=0;
        else 
            mag_col(counter)=1;
        end
    end

    %converted col vector to image
    tester=mag_col;
    tester=reshape(tester,size(mag));
    sq = strel('square',10);
    
    imerode(tester,sq);
    [row,col]=find(tester==1);
    %figure('Name','An Result'),imagesc(tester);
    disp('clotings');
    size(row,1)
    if(size(row,1)>30)
       limit=limit-.02;
    else
        adjested=1;
    end
end
    mag=reshape(mag_col,size(mag));
end

function im=preProcessing_fake_edge(im, thr)
    new_im=zeros(size(im)) ;
    im_avg=mean(im(:));
     
     new_im(im>thr*im_avg)=1;
     im=new_im;
end

function im= preProcessing_angle(im, angle)
    rows=[];
    cols=[];
    [row,col]=find(angle*180/pi>45-10 & angle*180/pi<45+10);
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>-45-10 & angle*180/pi<-45+10);
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>135-10 & angle*180/pi<135+10);
    
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>-135-10 & angle*180/pi<-135+10);
    
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>-60-10 & angle*180/pi<-60+10);
    
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>60-10 & angle*180/pi<60+10);
    
    rows=[rows;row];
    cols=[cols;col];
    [row,col]=find(angle*180/pi>120-10 & angle*180/pi<120+10);
    
    rows=[rows;row];
    cols=[cols;col];
    
    for counter=1:size(rows,1)
        im(rows(counter),cols(counter))=1;
    end
    %figure,imagesc(abs(angle));
    %[row,col]=find(im==0);
    %for counter=1:size(row,1)
    %    angle(row(counter),col(counter))=0;
    %end
    %angle=imgaussfilt(angle, 1);
    %deepak_corner=zeros(size(angle));
    %figure('Name','Edge Density'),imagesc(angle);
    %for i=3:size(angle,1)-3
    %    for j=3:size(angle,2)-3
    %        temp=[angle(i,j),angle(i-1,j),angle(i,j-1),angle(i-1,j-1),angle(i-1,j+1),angle(i+1,j-1),angle(i,j+1),angle(i+1,j),angle(i+1,j+1)];
    %        temp=temp(temp~=0);
    %        deepak_corner(i,j)=var(temp)/size(temp,2);
    %    end
    %end    
    %deepak_corner(deepak_corner >.3*(max(deepak_corner(:))))=1;
    %deepak_corner(deepak_corner~=1)=0;
    %figure('Name','Deepak Corner'),imagesc(deepak_corner);
    %im=im;
    
end
function [imgEdge,angles]=Sobel(img)
    %img=im2double(img);
    img=uint8(img);
    sobelA= [1 1 1;
             1 -2 1;
            -1 -1 -1]/10;
    sobelB= [1 1 1;
             1 -2 -1;
             1 -2 -1]/10;
    
    sobelC= [1 1 -1;
             1 -2 -1;
             1 2 -1]/10;
         
    sobelD= [1 -1 -1;
             1 -2 -1;
             1 1 1]/10;
     
    sobelE= [-1 -1 -1;
             1 -2 1;
             1 1 1]/10;
         
    sobelF= [-1 -1 1;
             -1 -2 1;
             1 1 1]/10;
    sobelG= [-1 1 1;
             -1 -2 1;
             -1 1 1]/10;
    sobelH= [-1 1 1;
             -1 -2 1;
             -1 -1 1]/10;
    imgEdgeA=imfilter(img,sobelA,'same');
    figure('Name','A'),imagesc(imgEdgeA);
    imgEdgeB=imfilter(img,sobelB,'same');
    figure('Name','A'),imagesc(imgEdgeB);
    imgEdgeC=imfilter(img,sobelC,'same');
    figure('Name','A'),imagesc(imgEdgeC);
    imgEdgeD=imfilter(img,sobelD,'same');
    figure('Name','A'),imagesc(imgEdgeD);
    imgEdgeE=imfilter(img,sobelE,'same');
    figure('Name','A'),imagesc(imgEdgeE);
    imgEdgeF=imfilter(img,sobelF,'same');
    figure('Name','A'),imagesc(imgEdgeF);
    
    imgEdgeG=imfilter(img,sobelG,'same');
    figure('Name','A'),imagesc(imgEdgeG);
    imgEdgeH=imfilter(img,sobelH,'same');
    figure('Name','A'),imagesc(imgEdgeH);
    %imgEdgeY=abs(imgEdgeY);
    %figure('Name','SobarX'),imshow(imgEdgeX);
    %figure('Name','SobarY'),imshow(imgEdgeY);
    %figure('Name','A'),imagesc(imgEdgeA);
    img=zeros(size(imgEdgeA));
    for i=1:size(imgEdgeA,1)
        for j=1:size(imgEdgeA,2)
            edgeRow=[imgEdgeA(i,j),imgEdgeB(i,j),imgEdgeC(i,j),imgEdgeD(i,j),imgEdgeE(i,j),imgEdgeF(i,j),imgEdgeG(i,j),imgEdgeH(i,j)];
            img(i,j)=max(edgeRow);
            
        if(i==230 && j==391)
            edgeRow
           
        end
        end
    end
    imgEdge=img;
    angles=imgEdge;
end
function im=preProcessing_corner(im)

C = corner(im,2000);
plot(C(:,1), C(:,2), 'r*');
for counter=1:size(C(:,1))
    im(C(counter,1), C(counter,2))=1;
    if C(counter,2)-2 >0
    im(C(counter,1), C(counter,2)-1)=1;
    im(C(counter,1), C(counter,2)-2)=1;
    end
    if C(counter,2)+2<size(im,2)
    im(C(counter,1), C(counter,2)+1)=1;
    im(C(counter,1), C(counter,2)+2)=1;
    end
end
    im = medfilt2(im,[2,2]);
  
end

function [im,angle]=Sobel1(img)
    %img=im2double(img);
    sobelX= [1 2 1;
             0 0 0;
            -1 -2 -1];
    sobelY= [1 0 -1;
             2 0 -2;
             1 0 -1];
     
    imgEdgeX=imfilter(img,sobelX,'same');
    %imgEdgeX= abs(imgEdgeX);
    imgEdgeY=imfilter(img,sobelY,'same');
    %imgEdgeY=abs(imgEdgeY);
    %figure('Name','SobarX'),imshow(imgEdgeX);
    %figure('Name','SobarY'),imshow(imgEdgeY);

    im = (imgEdgeX.^2+imgEdgeY.^2).^(1/2);
    angle=im;
end

function entopy=Entropy(im)
    im=im(:);
    im=im.*log(1./im);
    ind = find(isnan(im));
    im(ind)=0;
    entopy=sum(im);

end

function im=Greyscale_extension(im)
    im_row=im(:);
    a=-min(im_row);
    b=255/(max(im_row)-min(im_row));
    im=(im+a)*b;
end