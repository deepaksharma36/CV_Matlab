function  HW06_Sharma_Deepak_FIND_RASPBERRIES( filename )

close all;
addpath( '../TEST_IMAGES' );
im_rgb=imread(filename);
im_rgb=im2double(im_rgb);
imagesc(im_rgb);
INTERACTIVE = 0;
 
    if  INTERACTIVE
        [x_fg, y_fg] = ginput();
        [x_bg, y_bg] = ginput();
           im_r = im_rgb(:,:,1);
        im_g = im_rgb(:,:,2);
        fg_indices  = sub2ind( size(im_rgb), round(y_fg), round(x_fg) );
        fg_r     = im_r( fg_indices );
        fg_g   = im_g( fg_indices );
        bg_indices  = sub2ind( size(im_rgb), round(y_bg), round(x_bg) );
        bg_r     = im_r( bg_indices );
        bg_g   = im_g( bg_indices );
        fg_ab       = [ fg_r fg_g ];   
        bg_ab       = [ bg_r bg_g ];
        save( 'Rasberries_data', 'x_fg','y_fg','x_bg','y_bg','fg_ab','bg_ab' );
    else
        load Rasberries_data;
    end
    im_r = im_rgb(:,:,1);
    im_g = im_rgb(:,:,2);
    im_ab       = [ im_r(:) im_g(:) ];
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
    mahal_bg    = ( mahal( im_ab, bg_ab ) ) .^ (1/2);
    class_0     = mahal_fg < mahal_bg;
    class_im    = reshape( class_0, size(im_r,1), size(im_r,2) );
    figure('Position',[10 10 1024 768]);
    subplot(2,2,1);
    imagesc(im_rgb);
    axis image;
    title('Test Image ', 'FontSize', 10, 'FontWeight', 'bold' );
    subplot(2,2,2);
    imagesc( class_im );
    axis image;
    colormap(gray);
    title('Class 0 representation', 'FontSize', 20, 'FontWeight', 'bold' );
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
    %
    %  Use a distance to target variable as rules for inclusion:
    %  We could do better than this by adding some additional tolerance.
    %
    threshold       = dist_mean;
    distance_of_interest = fg_dists < dist_mean ; 
    % Change the shape of the classification to look like an image:
    class_im = reshape( distance_of_interest, size(im_r,1), size(im_r,2));
    subplot(2,2,4);
    imagesc( class_im );
    title('After Removing  points which are 2 SD away from mean  ', 'FontSize', 10, 'FontWeight', 'bold' );
    
end

