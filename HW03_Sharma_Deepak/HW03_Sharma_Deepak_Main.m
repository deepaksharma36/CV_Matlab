function HW03_Sharma_Deepak_Main()

 Assignment2
 pause(5)
 Assignment3
 pause(5)
 Assignment4
 pause(5)
 Assignment5
 pause(5)
 Assignment6
 pause(5)
 Assignment7
 pause(5)
 Assignment8
 pause(5)
 %Assignment8
clear all;
close all;
    
end

function Assignment2()
%a. Read in the SHOPPING_LIST image supplied.
%b. Convert it to one color.
%c. Use the graythresh( ) routine to find the best method for converting the image into black and white.
%d. Using this threshold, quantize the image into <= the threshold and > the threshold.
%e. Graythresh( ) uses an underlying clustering method. What is the name of this method? What was it initially designed for?
%f. Display the resulting quantized image. Put the resulting image in your write-up, and discuss the results. How well
%did this work, and why.
 clear all;
 close all;
 img=imread('SHOPPING_LIST.jpg');
 figure('Name','Input'),imshow(img);
 pause(1);
 img=img(:,:,2);
 figure('Name','GreenCh'),imshow(img);
 pause(1)
 %img=histeq(img);
 %imshow(img);
 %img=img.^3;
 img=im2double(img);
 thresh=graythresh(img);
 disp(thresh);
 imgNew=img>(thresh);
 figure('Name','Binarized'),imshow(imgNew);
 pause(1)
end
function Assignment3()
    clear all;
    close all;
    img=imread('SHOPPING_LIST.jpg');
    img=img(:,:,2);
    %real=im2double(img);
    figure('Name','Original'),imshow(img);
    pause(1);
    img=im2double(img);
    img1 = adapthisteq(img,'clipLimit',0.02,'Distribution','exponential');
    figure('Name','Adaptive histo'),imshow(img1);
    pause(1);
    img2=img1.^(1/3);
    figure('Name','After Contrast Enhancement'),imshow(img2);
    pause(1);
    %smoth=[1 2 1;2 4 2;1 2 1]/16;
    %img=imfilter(img,smoth,'same');
     %figure('Name','Testing'),imshow(img1);
    %smoth=[1 2 1;2 4 2;1 2 1]/16;
    %img=imfilter(img,smoth,'same');
    %imSize=size(img);
    %imgNew=img;
    %for i=1:imSize(1)
    %   for j=1:imSize(2)
    %       imgNew(i,j)= .1.*log10(img(i,j)*255);
    %   end
    %end
    %colormap(gray);
    %imgtest=img.^(3);
    %figure('Name','Test'),imshow(imgtest);
    %img2=(1-img.^(3)).^(3);
    %figure('Name','3'),imshow(img2);
    %img3=(img1-img2);
    %figure('Name','addition'),imshow(img3);
    %img1=img1.^(1/3);
    %disp(thresh);
    %figure('Name','Final'),imshow(1-imgNew/2-real/2);
    %NoiseRemoval=[1 1 1;1 0 1;1 1 1]/8;
    %img=imfilter(imgNew,NoiseRemoval,'same');
    %figure('Name','BinaryWithoutNoise'),imshow(img);
    %imge=Sobel(img);
    %figure('Name','Edge'),imshow(1-imge)

end
function Assignment4()
    close all;
    clear all;
    img=imread('THERMOMETER_20160213_1110.jpg');
    figure('Name','Original'),imshow(img);
    img=rgb2gray(img);
    img1 = adapthisteq(img,'clipLimit',0.005,'Distribution','exponential');
    img1=im2double(img1);
    smooth=[1 2 1;2 4 2;1 2 1]/16;
    img2=imfilter(img1,smooth,'same');

    %img2=1-img1;
    %img2=img2.^3;
    img3=img2.^(1/3);
    thrus=graythresh(img3);
    img4=img3>thrus;
    figure('Name','Adaptive Histogram Equalized'),imshow(img1);
    pause(1);
    figure('Name','Smoothed'),imshow(img2);
    pause(1);
    figure('Name','Contrast Enhancement using Cublic Root'),imshow(img3);
    pause(1);
    figure('Name','Binarized'),imshow(img4);
    pause(1);

end
function Assignment5()
    close all;
    clear all;
    img=imread('Parent_Drop_off.jpg');
    img=img(:,:,3);
    figure('Name','Original'),imshow(img);
    pause(1);
    img=im2double(img);
    sobelY= [-1 -2 -1;
             0 0 0;
            1 2 1];
        
    sobelX= [-1 0 1;
             -2 0 2;
             -1 0 1];
     
    imgEdgeX=imfilter(img,sobelX,'same');
    %imgEdgeX= abs(imgEdgeX);
    imgEdgeY=imfilter(img,sobelY,'same');
    %imgEdgeY=abs(imgEdgeY);
    imgEdgeFinal = (imgEdgeX.^2+imgEdgeY.^2).^(1/2);
    %imgEdgeFinal = imgEdgeFinal;
    %imgEdgeReverse = (1-imgEdgeFinal).^3;
    %smoth=[1 1 1;1 2 1;1 1 1]/10;
    %imgSmoth=imfilter(imgEdgeReverse,smoth,'same');
    %imgSmoth=imfilter(imgSmoth,smoth,'same');
    %imgHist=histeq(imgSmoth);
    figure('Name','SobalX'),imshow(imgEdgeX);
    pause(1);
    figure('Name','SobalY'),imshow(imgEdgeY);
    pause(1);
    figure('Name','TotalEdges'),imshow(imgEdgeFinal);
    
    %figure('Name','imgReverse'),imshow(imgEdgeReverse);
    %figure('Name','smoth'),imshow(imgSmoth);
    
end
function Assignment6()
    close all;
    clear all;
    img=imread('HEADs_UP__do_not_text_and_walk.jpg');
    figure('Name','Original'),imshow(img);
    pause(1);
    imgB=img(:,:,3);
    imgB=im2double(imgB);
    imgB=Sobel(imgB);
    imgR=img(:,:,1);
    imgR=im2double(imgR);
    imgR=Sobel(imgR);
    imgG=img(:,:,3);
    imgG=im2double(imgG);
    imgG=Sobel(imgG);
    imgEdgeFinal=(imgR+imgG+imgB)./3;
    %imgEdgeFinal = (imgEdgeX.^2+imgEdgeY.^2).^(1/2);
    %imgEdgeFinal = imgEdgeFinal;
    imgEdgeReverse = (1-imgEdgeFinal).^3;
    smooth=[1 1 1;1 2 1;1 1 1]/10;
    imgSmooth=imfilter(imgEdgeReverse,smooth,'same');
    %imgSmoth=imfilter(imgSmoth,smoth,'same');
    %imgHist=histeq(imgSmoth);
    figure('Name','imgTotalEdges'),imshow(imgEdgeFinal);
    pause(1);
    figure('Name','imgReverseEdges'),imshow(imgEdgeReverse);
    pause(1)
    figure('Name','smooth'),imshow(imgSmooth);
    pause(1)
    %figure('Name','histEq'),imshow(imgHist);
end
function Assignment7()
    clear all;
    close all;
    img=imread('TBK_Road_Home_frm_CVPR_2012.jpg');
    figure('Name','Original'),imshow(img);
    pause(1);
    imgR=img(:,:,1);
    imgG=img(:,:,2);
    imgB=img(:,:,3);
    imgR=Sobel(imgR);
    imgG=Sobel(imgG);
    imgB=Sobel(imgB);
    imgEdgeFinal=im2double((imgR+imgG+imgB/3));
    %imgEdgeFinal=imgEdgeFinal.^(3);
    imgEdgeReverse = (1-imgEdgeFinal);
    imgEdgeEnhanced=imgEdgeReverse.^(1/3);
    smooth=[1 1 1;1 2 1;1 1 1]/10;
    imgEdgeEnhanced=imfilter(imgEdgeEnhanced,smooth,'same');
    figure('Name','imgTotalEdges'),imshow(imgEdgeFinal);
    pause(1);
    figure('Name','imgEdgeReverse'),imshow(imgEdgeReverse);
    pause(1);
    figure('Name','imgEdgeEnhanced(Contrasted then Smoothed )'),imshow(imgEdgeEnhanced);
    pause(1);
end
function Assignment8()
    clear all;
    close all;
    img=imread('TBK_Kite.jpg');
    figure('Name','Original'),imshow(img);
    
    imgG=img(:,:,2);
    imgEdgeFinalGreen=1-Sobel(imgG);
    imgR=img(:,:,1);
    imgEdgeFinalRed=1-Sobel(imgR);
    imgB=img(:,:,3);
    imgEdgeFinalBlue=1-Sobel(imgB);
    pause(1);
    figure('Name','imgEdgeGreen'),imshow(imgEdgeFinalGreen);
    pause(1);
    figure('Name','imgEdgeRed'),imshow(imgEdgeFinalRed);
    pause(1);
    figure('Name','imgEdgeBlue'),imshow(imgEdgeFinalBlue);
    pause(1);
    imgFinal=(imgEdgeFinalRed+imgEdgeFinalGreen+imgEdgeFinalBlue)./3;
    figure('Name','imgEdgeEnhanced'),imshow(imgFinal);
    pause(1);
    %imgEdgeFinalRed=imgEdgeFinalRed.^(3);
    %imgEdgeReverseRed = (1-imgEdgeFinalRed).^(3);
    %imgEdgeEnhancedRed=imgEdgeReverseRed-imgEdgeFinalRed;
    %smoth=[1 1 1;1 2 1;1 1 1]/10;
    %imgEdgeEnhancedRed=imfilter(imgEdgeEnhancedRed,smoth,'same');
end
function Assignment3AlterNative()
    close all;
    clear all;
    img=imread('THERMOMETER_20160213_1110.jpg');
    img=rgb2gray(img);
    img1=histeq(img);
    img1=im2double(img1);
    img2=1-img1;
    img2=img2.^3;
    img3=img1-3.*img2;
    thrus=graythresh(img3);
    img4=img3>thrus;
    figure('Name','1'),imshow(img1);
    figure('Name','2'),imshow(img2);
    figure('Name','3'),imshow(img3);
    figure('Name','4'),imshow(img4);

end

function imgEdge=Sobel(img)
    img=im2double(img);
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

    imgEdge = (imgEdgeX.^2+imgEdgeY.^2).^(1/2);
end