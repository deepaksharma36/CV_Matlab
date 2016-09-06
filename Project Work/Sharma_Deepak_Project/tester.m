%method for performing logical testing of Geo Filtes
close all;
im=imread('171.jpg');

%if(size(im,1)>512 && size(im,2)>512);
im=imresize(im,[512,512]);
im=im2bw(im);
im=bwlabel(im);
figure,imagesc(im);
[im,unwanted]=geo_filter(im);

figure('Name','Final'),imagesc(im);
