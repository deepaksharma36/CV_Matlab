function  mellon= Edge_Identification_for_Cutting(filename)

% adding path, if file will not found in PDW then it will check below dir
addpath( '../TEST_IMAGES' );
%reading file
im_rgb=imread(filename);
% converting image in HSV Space
im_hsv=rgb2hsv(im_rgb);
%converting image into LAB space
im_lab=rgb2lab(im_rgb);
im_rgb=im2double(im_rgb);

figure('Name','Compare')
subplot(2,2,1)
%showing hue Chanal
imagesc(im_hsv(:,:,3));
title('HUE', 'FontSize', 10, 'FontWeight', 'bold' );
subplot(2,2,2)
%showing A Channel
imagesc(im_lab(:,:,2));
title('a', 'FontSize', 10, 'FontWeight', 'bold' );
subplot(2,2,3)
%showing B Channel
imagesc(im_lab(:,:,3));

title('b', 'FontSize', 10, 'FontWeight', 'bold' );
subplot(2,2,4)
imagesc(im_rgb);
title('RGB', 'FontSize', 10, 'FontWeight', 'bold' );
INTERACTIVE = 0;
 
    if  INTERACTIVE
        disp('Please Provide input for Melon Body');
        [x_fg, y_fg] = ginput();
        disp('Please Provide input for Background');
        [x_bg, y_bg] = ginput();
        disp('Please Provide input for Skin');
        [x_sk, y_sk] = ginput();   
        im_a = im_lab(:,:,2);
        % storing indics of Melon Body 
        fg_indices  = sub2ind( size(im_lab), round(y_fg), round(x_fg) );
        % creating feature matrix of Melon Body 
        fg_a   = im_a( fg_indices );
       % storing indics of Background 
        bg_indices  = sub2ind( size(im_lab), round(y_bg), round(x_bg) );
        % creating feature matrix of Background 
        bg_a   = im_a( bg_indices );
        % storing indics of Melon Skin 
        sk_indices  = sub2ind( size(im_lab), round(y_sk), round(x_sk) );
         % creating feature matrix of Melon Skin 
        sk_a   = im_a( sk_indices );

        fg_ab       =  fg_a ;   
        bg_ab       =  bg_a ;
        sk_ab       = sk_a;
        % saving feature matrix for running application on test image 
        save( 'melon_data', 'x_fg','y_fg','x_bg','y_bg','x_sk','y_sk','fg_ab','bg_ab','sk_ab' );
    else
        load melon_data;
    end
    im_a = im_lab(:,:,2);
    im_ab       = im_a(:) ;
    %disp(size(im_ab));
    % claculating mahanlobious distance for background, melon body and skin
    %with respect to their feature matrix
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
    mahal_bg    = ( mahal( im_ab, bg_ab ) ) .^ (1/2);
    mahal_sk    = ( mahal( im_ab, sk_ab ) ) .^ (1/2);
    
    %  Use a distance to target variable as rules for inclusion:
    
    %collecting points of melon body
    class_0     = mahal_fg < mahal_bg & mahal_fg < mahal_sk;
    %collecting points of melon Skin
    class_sk_col    =  mahal_sk < mahal_fg & mahal_sk < mahal_bg ;
    %converting col vector into image 
    class_im    = reshape( class_0, size(im_a,1), size(im_a,2) );
    class_sk    = reshape( class_sk_col, size(im_a,1), size(im_a,2) );
    
    figure('Name','Results and Findings','Position',[10 10 1024 768]);
    subplot(3,2,1);
    imagesc(im_rgb);
    axis image;
    title('Test Image ', 'FontSize', 10, 'FontWeight', 'bold' );
    subplot(3,2,2);
    %showing melon body
    imagesc( class_im );
    axis image;
    colormap(gray);
    title('Class Body', 'FontSize', 10, 'FontWeight', 'bold' );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%foreGround%%%%%%%%%%%%%%%%%%%%%%%%%
    fg_dists        = mahal_fg;
    fg_dists_cls0   = fg_dists(class_0);
    dist_mean       = mean( fg_dists_cls0 );
    dist_std_01     = std(  fg_dists_cls0 );
    %beautiful work by professor Kinsman :)
    % Toss everything outside of two standard deviation, and re-adjust the mean value:
    b_inliers       = ( fg_dists_cls0 <= (dist_mean + 2*dist_std_01) ) & ( fg_dists_cls0 >= (dist_mean - 2*dist_std_01));
    the_inliers     = fg_dists_cls0( b_inliers );
    dist_mean       = mean( the_inliers );
    dist_std = std(the_inliers);
    
    % considering all points which are withen 3SD distance 
    distance_of_interest = fg_dists < dist_mean+3*dist_std ; 
    % converting col vec into image
    class_im = reshape( distance_of_interest, size(im_a,1), size(im_a,2));
    subplot(3,2,3);
    imagesc(class_im)
    title('class_body after unwanted points removel', 'FontSize', 10, 'FontWeight', 'bold' );
    se = strel('disk',10);
    class_im=imopen(class_im,se);
    se = strel('disk',12);
    class_im=imclose(class_im,se);
    subplot(3,2,4);
    imagesc(class_im)
    title('body class after morphological operations', 'FontSize', 10, 'FontWeight', 'bold' );
    mellon=class_im;
    % pefroming statistical enhancement on the skin of melon
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Skin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sk_dists        = mahal_sk;
    sk_dists_cls0   = sk_dists(class_sk_col);
    dist_mean       = mean( sk_dists_cls0 );
    dist_std     = std(  sk_dists_cls0 );
    %beautiful work by professor Kinsman :)
    % Toss everything outside of two standard deviation, and re-adjust the mean value:
    b_inliers_sk       = ( sk_dists_cls0 <= (dist_mean + 2*dist_std) ) & ( sk_dists_cls0 >= (dist_mean - 2*dist_std));
    the_inliers_sk     = sk_dists_cls0( b_inliers_sk );
    dist_mean       = mean( the_inliers_sk );
    dist_std =       std(the_inliers_sk);
    distance_of_interest = sk_dists < dist_mean+2*dist_std ; 
    %converting col vec in image
    class_sk = reshape( distance_of_interest, size(im_a,1), size(im_a,2));
    subplot(3,2,5);
    imagesc(class_sk);
    title('Skin Class after unwanted points removed', 'FontSize', 10, 'FontWeight', 'bold' );
    se = strel('disk',10);
    class_sk=imclose(class_sk,se);
    % edge detection in y direction only bright to dard transections
    filter=[2 0 -2 ];
    cut=imfilter(class_sk,filter,'same');
    cut=ceil(cut);
    %closing operation for enhancing edges
     se = strel('disk',12);
    cut=imclose(cut,se);
    subplot(3,2,6);
    imagesc(cut);
    title('Right Edge of the Skin', 'FontSize', 10, 'FontWeight', 'bold' );
    %%%%%%%%%%%%%%%%%%%%Curve fitting/not working%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x,y]=meshgrid(1:size(cut,1),1:size(cut,2));%size(cut,2)
    Z=ones(size(cut,1),size(cut,2));
    X=x(:);
    Y=y(:);
    Z=ones(size(X));
    %disp(size(Z));
    %disp(size(X));
    %disp(size(Y));
    
    for counter=1:size(X)
        Z(counter)=cut(X(counter),Y(counter));
    end
    z=reshape( Z, size(cut,2), size(cut,1) );
    %disp(size(Z));
    %disp(size(x));
    %disp(size(y));
    
    %surfout=surf(x,y,z);
    %set(surfout,'LineStyle','none');
    %cut=resize(cut,size(im_rgb));
    
    
    %manupulating image for creating magenta line
    for counter=1:3
        if counter~=2
            im_rgb(:,:,counter)=im_rgb(:,:,counter)+cut(:,:);
        else
            im_rgb(:,:,counter)=im_rgb(:,:,counter)-cut(:,:);    
        end
    end
    %counting the number of melon peices
    n=counting(mellon);
    figure('Name', 'Final Output'),imshow(im_rgb);
    str=sprintf('There are %d pieces of melon', n);
    title(str, 'FontSize', 20, 'FontWeight', 'bold' );
    

end

