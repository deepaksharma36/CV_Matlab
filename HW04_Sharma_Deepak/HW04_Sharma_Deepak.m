function HW04_Sharma_Deepak()
    close all;
    clear all;
    %input_image=imread('TBK_Buckle_Up_Next_Million_Miles_DSCF0372.jpg');
    %output_Image=local_block_smear(input_image);
    %figure('Name','Smeared Image'),imshow(output_Image);
    %pause(3);
    close all;
    clear all;
    maximal_edges('TBK_Buckle_Up_Next_Million_Miles_DSCF0372.jpg');
end

function maximal_edges( input_image )


%This implements the part of the Canny edge detection that only finds the maximum edge in each direction.
input_image=imread(input_image);
dimensions = size( input_image );
    if length( dimensions ) > 2
        % If input image is a RGB or 3 dimensional image than convert it to 2 
        % dimensional gray scale image.
        %input_image = rgb2gray( input_image );

    end
%Filter the image using a Gaussian filter to remove small edges:

figure('Name','Original'),imagesc(input_image);
colormap('gray');
fltr = fspecial('Gaussian', 5,.001 ); % Play with the values here to remove the unimportant edges.
im2 = imfilter( input_image, fltr, 'same', 'repl' ); 

figure('Name','Smoothed'),imshow(im2);
% Takes a second or two…
%b. For each pixel in im2, use a Sobel filter as specified in the lecture, 
%to estimate the df/dx and df/dy of the gradient at each
%pixel, in each plane of the image. (For all colors given.) Use imfilter. Do not use edge( ).
im2_dif_x=Sobel(im2,'X');
im2_dif_y=Sobel(im2,'Y');

%c. Compute the edge magnitude at each pixel.
edge_magnitude=(im2_dif_x.^2+im2_dif_y.^2).^(1/2);
%d. Compute the edge direction at each pixel (the angle).
edge_angle=atan2(im2_dif_y ,im2_dif_x).*(180/pi);
%e. Convert the edge angle to a multiple of 45 degrees. This means using the round( ) or floor( ) functions. The angle 0 should
%round to 0. The angle -20 should round to zero. This should give you a few angles to handle: 0, 45, 90, and 135.
edge_angle_45=round( edge_angle ./ 45 )*45;
%f. For every pixel in the intermediate image, only keep edges if they have a larger edge magnitude than the pixel infront of them
%and behind them. So, if the edge is at 45 degrees, only keep that edge if it has a stronger edge gradient than the pixel up to the
%right and down to the left of it.
dimensions=size(edge_angle_45);
edge_magnitude_Canny=edge_magnitude;
for row = 2 : (dimensions(1) - 2)
    for col = 2 : (dimensions(2) - 2 )
        angle=edge_angle_45(row,col);
        if(abs(angle)==0 || abs(angle)==180)
            if((edge_magnitude(row,col)<edge_magnitude(row,col-1) ) || (edge_magnitude(row,col)<edge_magnitude(row,col+1)))
                %g. Edges that are not maximum are set to zero in the output.
                edge_magnitude_Canny(row,col)=0;
                %edge_magnitude(row,col)=0;
            end
        end
        if((angle)==45 || angle==-135)
            if((edge_magnitude(row,col)<edge_magnitude(row-1,col+1) ) || (edge_magnitude(row,col)<edge_magnitude(row+1,col-1)))
                %g. Edges that are not maximum are set to zero in the output.
                edge_magnitude_Canny(row,col)=0;
                %edge_magnitude(row,col)=0;
            end
        end
        if(abs(angle)==90)
            
            if((edge_magnitude(row,col)<edge_magnitude(row-1,col) ) || (edge_magnitude(row,col)<edge_magnitude(row+1,col)))
                %g. Edges that are not maximum are set to zero in the output.
                edge_magnitude_Canny(row,col)=0;
                %edge_magnitude(row,col)=0;
            end
        end
        if((angle)==135 || angle == -45)
            if((edge_magnitude(row,col)<edge_magnitude(row-1,col-1) ) || (edge_magnitude(row,col)<edge_magnitude(row+1,col+1)))
                %g. Edges that are not maximum are set to zero in the output.
                edge_magnitude_Canny(row,col)=0;
                %edge_magnitude(row,col)=0;
            end
        end
    end
 end
%h. The output image will be only those edges that are the maximum edges. However, they are not binary. They have the actual
%edge strength.
edge_magnitude_Canny = im2double(edge_magnitude_Canny);
figure('Name','Canny');
imagesc(edge_magnitude_Canny);
colormap('gray');
figure('Name','Sobel');
imagesc(edge_magnitude);
colormap('gray');
%In your write-up, show the input image, using imagesc( ), and the output image generated. 
%This means you will need to run
%the code, and save the output using imwrite( ) to another file.
imwrite(edge_magnitude_Canny,'canny_output.jpg');

end

function imgEdge=Sobel(img , direction)
    img=im2double(img);
    sobel=[1,1,1;1,1,1;1,1,1];
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
    imgEdge=imfilter(img,sobel,'same');
end

function output_image = local_block_smear ( input_image )
    
    dimensions = size( input_image );
    if length( dimensions ) > 2
        % If input image is a RGB or 3 dimensional image than convert it to 2 
        % dimensional gray scale image.
        input_image = rgb2gray( input_image );
    end
    figure('Name','Original Image'),imshow(input_image);
    input_image=im2double(input_image);
    % Default return values …
    output_image = input_image;
    % Each pixel of the input image is access by outer nested for loops and 
    % for each pixel 24 neighboring pixel values were accessed using inner
    % nested for loops. Then the avrage of pixel intensity was caluated with
    % it neighboring 24 pixels. Then calculated average value was assigned to 
    % the pixel itself. 

    % Outer nested loops start from row number 3 , col number 3 and go upto 
    % row number= number of rows - 3 and col=number of col-3, because inner 
    % nested  loop while accessing negighboring pixels access the previous and 
    % next 2  rows and col for each pixel. Hance by running outer nested loop 
    % between  row number 3 , col number 3 and row number = number of row -3 and 
    % col number = number of col -3 we avoided array/matrix out of index run 
    % time exception. 
    for row = 3 : (dimensions(1) - 3)
        for col = 3 : (dimensions(2) - 3 )
            sum = 0;
            for ii = -2 : 2
                for kk = -2 : 2
                    sum = sum + input_image(  row + kk , col + ii); 
                    %accessing adjesent/neighbouring(in range (i-2,j-2) to (i+2,j+2)for (i,j))
                    %pixels and adding up the value of the intensity of each of these neighbour
                    %into a variable sum.
                end
            end
            output_image( row, col ) = sum / 25;
        end
    end
end