%author professor Kinsman, Deepak Sharma
function HW06_Sharma_Deepak_FIND_GRAFFITI( filename )

close all;
addpath( '../TEST_IMAGES' );
%set INtERACTIVE 0 for running classifer on test images
%set INtERACTIVE 1 for creating classifer
im_rgb = imread( filename );
       %applying gaussian filter for removing noise
        
        H = fspecial('gaussian');
        im_rgb = imfilter(im_rgb,H);
        figure('Position',[10 10 1024 768]);
        imshow( im_rgb );
    im_hsv      = rgb2hsv( im_rgb );
    im_rgb= im2double(im_rgb);
    INTERACTIVE = 0;
         %if number of input in funtion = 0 then   
        if nargin < 1
            %filename = 'IMG_Graffiti_240.JPG';
       
        end

    if  INTERACTIVE
 

        fprintf('SELECT FOREGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        [x_fg, y_fg] = ginput();

        
        fprintf('SELECT BACKGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        [x_bg, y_bg] = ginput();
    
    im_hue      = im_hsv(:,:,1);
    im_red    = im_rgb(:,:,1);
    %adjusting hue values as hue if angle < 0 than fliping it to other side
    for x=1:size(im_hue,1)
        for y=1:size(im_hue,2)
            if(im_hue(x,y)>abs(1-im_hue(x,y)))
                im_hue(x,y)=abs(1-im_hue(x,y));
            end
        end
    end
    %storing indices of the points in a linear vector 
    %sub2ind for coordinate (A,B) return A*numberofRows+B

    fg_indices  = sub2ind( size(im_hue), round(y_fg), round(x_fg) );
    
    fg_hues     = im_hue( fg_indices );
    fg_red   = im_red( fg_indices );
    bg_indices  = sub2ind( size(im_hue), round(y_bg), round(x_bg) );
    bg_hues     = im_hue( bg_indices );
    bg_red   = im_red( bg_indices );
    figure('Position',[10 10 1024 768]);
    plot( fg_hues, fg_red, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 16  );
    hold on;
    plot( bg_hues, bg_red, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 16  );
    xlabel( 'HUE ', 'FontSize', 22 );
    ylabel( 'Value ', 'FontSize', 22 );
    title(' Hue vs Red Channel(RGB)', 'FontSize', 32 );
    % This forms a matrix of the two features fg_hues and fg_red
    fg_ab       = [ fg_hues fg_red  ];   
    % This forms a matrix of the two features fg_hues and fg_red
    bg_ab       = [ bg_hues bg_red ];    

        save ('Graffiti_data', 'x_fg','y_fg','x_bg','y_bg','fg_ab','bg_ab');
      
    else
        load Graffiti_data;
        
        H = fspecial('gaussian');
        im_rgb = imfilter(im_rgb,H);
        figure('Position',[10 10 1024 768]);
        imshow( im_rgb  );

    end
    
    
    im_hue      = im_hsv(:,:,1);
    im_red    = im_rgb(:,:,1);
    %adjusting hue values as hue if angle < 0 than fliping it to other side
    for x=1:size(im_hue,1)
        for y=1:size(im_hue,2)
            if(im_hue(x,y)>abs(1-im_hue(x,y)))
                im_hue(x,y)=abs(1-im_hue(x,y));
            end
        end
    end

    im_ab       = [ im_hue(:) im_red(:)  ];
    %calculating mahanalobus feature distance of each pixel from
    % forground pixels
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
    %calculating mahanalobus feature distance of each pixel from
    % background pixels
    mahal_bg    = ( mahal( im_ab, bg_ab ) ) .^ (1/2);
    %  Classify as Class 0 (foreground object) if distance to FG is < distance to BG.
    class_0     = mahal_fg < mahal_bg;
    %converting col vector back to 2 D image Matrix    
    class_im    = reshape( class_0, size(im_hue,1), size(im_hue,2) );
    figure('Position',[10 10 1024 768]);
    subplot(2,2,1);
    imagesc(im_rgb);
    axis image;
    title('Test Image ', 'FontSize', 20, 'FontWeight', 'bold' );
    subplot(2,2,2);
    imagesc( class_im );
    axis image;
    colormap(gray);
    title('Class 0 representation ', 'FontSize', 20, 'FontWeight', 'bold' );
    
    subplot(2,2,3);
    fg_dists        = mahal_fg;
    fg_dists_cls0   = fg_dists( class_0 );  
    mmax            = max( fg_dists_cls0 );
    mmin            = min( fg_dists_cls0 );
    edges           = mmin : (mmax-mmin)/100 : mmax;
    [freqs bins]    = histc( fg_dists, edges );
    bar( edges, freqs );
    aa = axis();
    title('Histogram of Class 0 (mahanlobus distance vs number of pixel) ', 'FontSize', 8, 'FontWeight', 'bold' );
    
    %
    %  Form a model of the foreground Mahalanobis distance:
    %
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
    %threshold       = dist_mean;
    distance_of_interest = fg_dists < dist_mean+dist_std ; 
    % Change the shape of the classification to look like an image:
    class_im = reshape( distance_of_interest, size(im_hue,1), size(im_hue,2));
    subplot(2,2,4);
    imagesc( class_im );
    title('After Removing  points which are 2 SD away from mean  ', 'FontSize', 10, 'FontWeight', 'bold' );
    
end

