b_image=imread('a.bmp');
figure('Name','Before'),imshow(b_image);
% I will not take complement before dilate
result=imdilate(b_image,[1 1 1 1;1 1 1 1]);
figure('Name','After' ),imshow(result);
%But I have succeed in dilatation because my background is black(0)