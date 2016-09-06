function maximal_edges( input_image )
%This implements the part of the Canny edge detection that only finds the maximum edge in each direction.
input_image=imread(input_image);
%Filter the image using a Gaussian filter to remove small edges:
fltr = fspecial('Gauss', 43, 3 ); % Play with the values here to remove the unimportant edges.
im2 = imfilter( input_image, fltr, 'same', 'repl' ); % Takes a second or two…
%b. For each pixel in im2, use a Sobel filter as specified in the lecture, 
%to estimate the df/dx and df/dy of the gradient at each
%pixel, in each plane of the image. (For all colors given.) Use imfilter. Do not use edge( ).
im2_dif_x=Sobel(im2,'X');
im2_dif_y=Sobel(im2,'Y');

%c. Compute the edge magnitude at each pixel.
edge_magnitude=(im2_dif_x.^2+im2_dif_y.^2).^(1/2);
%d. Compute the edge direction at each pixel (the angle).
edge_angle=atan2(im2_dif_x./im2_dif_y).*(180/pi);
%e. Convert the edge angle to a multiple of 45 degrees. This means using the round( ) or floor( ) functions. The angle 0 should
%round to 0. The angle -20 should round to zero. This should give you a few angles to handle: 0, 45, 90, and 135.
edge_angle_45=round( edge_angle ./ 45 )*45
%f. For every pixel in the intermediate image, only keep edges if they have a larger edge magnitude than the pixel infront of them
%and behind them. So, if the edge is at 45 degrees, only keep that edge if it has a stronger edge gradient than the pixel up to the
%right and down to the left of it.



%g. Edges that are not maximum are set to zero in the output.
%h. The output image will be only those edges that are the maximum edges. However, they are not binary. They have the actual
%edge strength.
%In your write-up, show the input image, using imagesc( ), and the output image generated. This means you will need to run
%the code, and save the output using imwrite( ) to another file.
%Discuss the results that you get with different sized blurring amounts that were applied in part a. What impact does larger
%standard deviations cause? What do smaller standard deviations cause?
end

function imgEdge=Sobel(img , direction)
    img=im2double(img);
    sobel=[1,1,1;1,1,1;1,1,1]
    if direction =='Y'
    sobel= [1 2 1;
             0 0 0;
            -1 -2 -1];
    end
    if direction=='X'
    sobel= [1 0 -1;
             2 0 -2;
             1 0 -1];
    end
    imgEdge=imfilter(img,sobel/8,'same');
end