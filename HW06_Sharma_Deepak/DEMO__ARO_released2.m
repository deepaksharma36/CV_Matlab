function DEMO__ARO_released2( fn )
%
%  Look up the documentation of any functions you have not seen before.
%
clear all;
close all;
INTERACTIVE = 1;

    fprintf('%% Look up the documentation of any functions you have not seen before.\n');
    
    if nargin < 1
        % This is a default filename.
        % It works for me, in my directory, but won't work for you...
        %fn = 'Image_of_Raspberries.JPG';
        fn = 'CS_631_Airplane_img1535.JPG';
       
    end

    if  INTERACTIVE
        im_rgb = imread( fn );
        
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

        save my_temporary_data;
    else
        load my_temporary_data;
    end
    pause()
    
    im_hsv      = rgb2hsv( im_rgb );
    %im_rgb= im2double(im_rgb);
    im_hue      = im_hsv(:,:,1);
    im_value    = im_hsv(:,:,3);
    
    for x=1:size(im_hue,1)
        for y=1:size(im_hue,2)
            if(im_hue(x,y)>abs(1-im_hue(x,y)))
                im_hue(x,y)=abs(1-im_hue(x,y));
            end
        end
    end
    disp(size(y_fg))
    disp(size(x_fg))
    fg_indices  = sub2ind( size(im_hue), round(y_fg), round(x_fg) );
    
    fg_hues     = im_hue( fg_indices );
    fg_values   = im_value( fg_indices );
    %fg_sat = im_sat(fg_indices);
    
    bg_indices  = sub2ind( size(im_hue), round(y_bg), round(x_bg) );
    bg_hues     = im_hue( bg_indices );
    bg_values   = im_value( bg_indices );
    %bg_sat = im_sat(bg_indices );
    %disp('Variance Of Hue and Values');
    %disp(var(bg_hues))
    %disp(var(bg_values))
    figure('Position',[10 10 1024 768]);
    plot( fg_hues, fg_values, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 16  );
    hold on;
    plot( bg_hues, bg_values, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 16  );
    xlabel( 'HUE ', 'FontSize', 22 );
    ylabel( 'Value ', 'FontSize', 22 );
    title(' you should add a title here to be sure you know what it is... ', 'FontSize', 32 );
    
    %     
    %     disp('paused.  Hit return to continue: ' );
%    pause( );
    center_Y=(max(y_fg)+min(y_fg))/2
    center_X=(max(x_fg)+min(x_fg))/2
    
    distance_from_center=x_fg;
    for x=1:size(x_fg)
        temp=[center_X center_Y;x_fg(x),y_fg(x)];
        distance_from_center(x)=pdist(temp,'euclidean');
    end    
    distance_from_center
    fg_ab       = [ fg_hues distance_from_center ];   % This forms a matrix of the two features of the 
                                                    % foreground object.
    mean_fg     = mean( fg_ab );                    % Their mean
%    cov_fg      = cov( fg_ab );
 %   disp(cov_fg)
    distance_from_center=x_bg;
    for x=1:size(x_bg)
        temp=[center_X center_Y;x_bg(x),y_bg(x)];
        distance_from_center(x)=pdist(temp,'euclidean');
    end    
    bg_ab       =  [bg_hues distance_from_center]  ;            % What does this do?
    %mean_bg     = mean( bg_ab );            % What does this do?
  %  cov_bg      = cov( bg_ab );             % What does this do?
    %disp(cov_bg)
    distance_from_center
   [x_coordinate,y_coordinate]= meshgrid(1:size(im_hue,1),1:size(im_hue,2));
   distance_from_center=im_hue(:);
   x_coordinate=x_coordinate(:);
   y_coordinate=y_coordinate(:);
   for x=1:size(im_hue(:))
        temp=[center_X center_Y;x_coordinate(x),y_coordinate(x)];
        distance_from_center(x)=pdist(temp,'euclidean');
    end    

    im_ab       = [ im_hue(:) distance_from_center  ];
    
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
    
    class_im    = reshape( class_0, size(im_hue,1), size(im_hue,2) );
    
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
    b_inliers       = ( fg_dists_cls0 <= (dist_mean + dist_std_01) ) & ( fg_dists_cls0 >= (dist_mean -dist_std_01));
    the_inliers     = fg_dists_cls0( b_inliers );
      dist_mean       = mean( the_inliers );
    dist_std = std(the_inliers);
    %
    %  Use a distance to target variable as rules for inclusion:
    %  We could do better than this by adding some additional tolerance.
    %
    %threshold       = dist_mean;
    distance_of_interest = fg_dists < dist_mean ; 
 
    %distance_of_interest = fg_dists > mean(distance_of_interest);
    class_im = reshape( distance_of_interest, size(im_hue,1), size(im_hue,2));
    subplot(2,2,4);
    imagesc( class_im );
    title('Adjested ', 'FontSize', 20, 'FontWeight', 'bold' );
    
end

