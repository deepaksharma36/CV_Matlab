function DEMO__GET_RASPBERY_COLORS_released( fn )
%
%  Look up the documentation of any functions you have not seen before.
%
close all;
INTERACTIVE = 0;

    fprintf('%% Look up the documentation of any functions you have not seen before.\n');
        im_rgb = imread( fn ); 
    if nargin < 1
        % This is a default filename.
        % It works for me, in my directory, but won't work for you...
    
       
    end

    if  INTERACTIVE
   
        
        H = fspecial('gaussian');
        im_rgb = imfilter(im_rgb,H);
        figure('Position',[10 10 1024 768]);
        imshow( im_rgb  );

        fprintf('SELECT FOREGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        [x_fg, y_fg] = ginput();

        
        fprintf('SELECT BACKGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        [x_bg, y_bg] = ginput();

        save ('my_temporary_data', 'x_fg','y_fg','x_bg','y_bg' );
    else
         load my_temporary_data;
    end
    
    
    im_hsv      = rgb2hsv( im_rgb );
    
    im_hue      = im_hsv(:,:,1);
    im_value    = im_hsv(:,:,3);
    disp(size(y_fg))
    disp(size(x_fg))
    fg_indices  = sub2ind( size(im_hue), round(y_fg), round(x_fg) );
    
    fg_hues     = im_hue( fg_indices );
    fg_values   = im_value( fg_indices );
    
    bg_indices  = sub2ind( size(im_hue), round(y_bg), round(x_bg) );
    bg_hues     = im_hue( bg_indices );
    bg_values   = im_value( bg_indices );
    disp('Variance Of Hue and Values');
    disp(var(bg_hues))
    disp(var(bg_values))
    figure('Position',[10 10 1024 768]);
    plot( fg_hues, fg_values, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 16  );
    hold on;
    plot( bg_hues, bg_values, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 16  );
    xlabel( 'HUE ', 'FontSize', 22 );
    ylabel( 'Value ', 'FontSize', 22 );
    title(' you should add a title here to be sure you know what it is... ', 'FontSize', 32 );
    
%     
%     disp('paused.  Hit return to continue: ' );
 pause( );
%    
    
    
    %
    %  REPEAT THE ANALYSIS FOR LAB SPACE
    %
    im_lab      = rgb2lab( im_rgb );
    
    im_a        = im_lab(:,:,2);
    im_b        = im_lab(:,:,3);
%     
%     Already have these values:
%     fg_indices  = sub2ind( size(im_lab), round(y_fg), round(x_fg) );
    fg_a        = im_a( fg_indices );
    fg_b        = im_b( fg_indices );
    
%     Already have these values:
%     bg_indices  = sub2ind( size(im_klab), round(y_bg), round(x_bg) );
    bg_a        = im_a( bg_indices );
    bg_b        = im_b( bg_indices );
    disp('variance')
    disp(var(bg_a/(max(bg_a(:))-min(bg_a(:)))));
    disp(var(bg_b/(max(bg_b(:))-min(bg_b(:)))));
    figure('Position',[10 10 1024 768]);
    plot( fg_a, fg_b, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 16 );
    hold on;                        % Why do I use this?  What does it do??

    plot( bg_a, bg_b, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 16  );
    
    xlabel( 'a* ', 'FontSize', 24, 'FontWeight', 'bold' );
    ylabel( 'b* ', 'FontSize', 24, 'FontWeight', 'bold' );
    title(' you should add a title here to be sure you know what it is... ', 'FontSize', 32 );

    

    
    % COMPUTE COVARIANCE FOR FG POINTS IN ab SPACE:
    fg_ab       = [ fg_a fg_b ];                    % This forms a matrix of the two features of the 
                                                    % foreground object.
    mean_fg     = mean( fg_ab );                    % Their mean
    cov_fg      = cov( fg_ab );
    
    
    bg_ab       = [ bg_a bg_b ];            % What does this do?
    mean_bg     = mean( bg_ab );            % What does this do?
    cov_bg      = cov( bg_ab );             % What does this do?
    
    im_ab       = [ im_a(:) im_b(:) ];
    
    %
    %  Look up the documentation of any functions you have not seen before.
    %
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
    mahal_bg    = ( mahal( im_ab, bg_ab ) ) .^ (1/2);
    
    %
    %  Classify as Class 0 (foreground object) if distance to FG is < distance to BG.
    %
    %  You will want to add a tolerance factor for your work to improve your accuracy.
    %
    class_0     = mahal_fg < mahal_bg;
    
    class_im    = reshape( class_0, size(im_a,1), size(im_a,2) );
    
    figure('Position',[10 10 1024 768]);
    subplot(2,2,1);
    imagesc(im_rgb);
    axis image;
    title('you should add a title here ', 'FontSize', 20, 'FontWeight', 'bold' );
    
    subplot(2,2,2);
    imagesc( class_im );
    axis image;
    colormap(gray);
    title('you should add a title here ', 'FontSize', 20, 'FontWeight', 'bold' );
    
    subplot(2,2,3);
    fg_dists        = mahal_fg;
    fg_dists_cls0   = fg_dists( class_0 );  
    mmax            = max( fg_dists_cls0 );
    mmin            = min( fg_dists_cls0 );
    edges           = mmin : (mmax-mmin)/100 : mmax;
    [freqs bins]    = histc( fg_dists, edges );
    bar( edges, freqs );
    aa = axis();
    title('you should add a title here ', 'FontSize', 20, 'FontWeight', 'bold' );
    
    %
    %  Form a model of the foreground Mahalanobis distance:
    %
    fg_dists        = mahal_fg;
    fg_dists_cls0   = fg_dists(class_0);
    dist_mean       = mean( fg_dists_cls0 );
    dist_std_01     = std(  fg_dists_cls0 );
    
    %beautiful work by professor Kinsman :)
    % Toss everything outside of one standard deviation, and re-adjust the mean value:
    b_inliers       = ( fg_dists_cls0 <= (dist_mean + dist_std_01) ) & ( fg_dists_cls0 >= (dist_mean - dist_std_01));
    the_inliers     = fg_dists_cls0( b_inliers );
    dist_mean       = mean( the_inliers );
    dist_std = std(the_inliers);
    %
    %  Use a distance to target variable as rules for inclusion:
    %  We could do better than this by adding some additional tolerance.
    %
    %threshold       = dist_mean;
    distance_of_interest = fg_dists < dist_mean ; 
    % Change the shape of the classification to look like an image:
    class_im = reshape( distance_of_interest, size(im_a,1), size(im_a,2));
    subplot(2,2,4);
    imagesc( class_im );
    title('Adjested ', 'FontSize', 20, 'FontWeight', 'bold' );
    
end

