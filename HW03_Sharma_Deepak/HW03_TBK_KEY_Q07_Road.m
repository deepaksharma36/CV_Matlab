function HW03_TBK_KEY_Q07_Road()
%
% 
%  HW03_TBK_KEY_Q07
%
% Consider the image named TEST_IMAGES/TBK_Road_Home_frm_CVPR_2012?
%
% Create an imaging chain to show the edges of the white line on the road. 
%
% Again, show the image before and after, and explain
% your imaging chain and what each step of your imaging chain does.
%
developing_this_code = true;

    %
    %  Fix the shopping list, so that the text is visible, but do it using
    %  a histogram analysis,and computations.
    %

    % Read in the input image:
    im01    = imread( 'TBK_Road_Home_frm_CVPR_2012.jpg');
    
    % Convert to double, because --
    % for consistency, I always work and think in double values.
    % Double values are also faster for Matlab to process.
    im02    = im2double( im01 );

    % I'm looking for a grayscale image, so go to gray:
    im03    = rgb2gray( im02 );
    

    %% Noise Cleaning:
    %  I don't have time to figure out if median filtering
    %  or Gaussian filtering is better, so try both to start:
    %
    % Remove some high and low values using median filtering:
    im04    = medfilt2( im03, [5 5]);
    
    % And, smooth some extreme values using 
    im05    = imfilter( im04, fspecial('gauss'), 'same', 'repl' );
    
    %% Edge Strength:
    % Find the horizontal and vertical edge gradients,
    % and the edge magnitudes,
    % and the edge angles.
    sobel_hz = [ 1 0 -1 ;
                 2 0 -2 ;
                 1 0 -1 ] / 8;
    sobel_vt = sobel_hz.';

    im_hz_edge_gradient     = imfilter( im05, sobel_hz, 'same', 'repl' );
    im_vt_edge_gradient     = imfilter( im05, sobel_vt, 'same', 'repl' );
    im_magnitude            = ( im_hz_edge_gradient.^2 + im_vt_edge_gradient.^2 ).^(1/2);
    im_angle                = atan2( im_vt_edge_gradient, im_hz_edge_gradient );

    %% Dimensions:
    % Get the image dimensions:
    dims                    = size( im05 );
    
    
    %% DEVELOPMENT:  TRY THEM ALL
    %
    % During development, the "try them all" approach helps clarify what is going on,
    % and how your feature selection might help:
    if developing_this_code
        min_angle   = -pi;      % or   min( im_angle(:) ) if you want
        max_angle   =  pi;      % max( im_angle(:) );
        
        angle_delta     = pi / 8;
        for bot_angle = min_angle : angle_delta : (max_angle - angle_delta)

            
            % Create a new figure to display the development images in:
            % This is normally done outside the loop, but here it is done
            % inside the loop when publishing the code to a PDF.
            figure('Position',[400 40 1024 768]);

            top_angle           = bot_angle + angle_delta;
            b_selected_edges    = im_angle >= bot_angle & im_angle <= top_angle;

            % Copy the edge image, and THEN
            % set the edges that are not at the correct angles to zero:
            temporary_im                        = im_magnitude;
            temporary_im( ~b_selected_edges )   = 0; 
            
            
            text_msg_rads = sprintf('Edges with angles between %6.3f and %6.3f radians ', bot_angle, top_angle);
            
            text_msg_degs = sprintf('Edges with angles between %6.3f and %6.3f degs. ', ...
                                        bot_angle*180/pi, ...
                                        top_angle*180/pi );

            imagesc( temporary_im.^(1/2) );
            colormap( gray );
            title( text_msg_degs, 'FontSize', 14, 'FontWeight', 'bold' );
            
            fprintf( '%s\n',   text_msg_rads );
            fprintf( '%s\n\n', text_msg_degs );

            pause(2);
        end

        % Clear the development information from the workspace:
        clear min_angle max_angle bot_angle top_angle angle_delta b_selected_edges temporary_im;
    end  % development code
    
    
    %% Feature Selection:
    %
    %  Limit the edges by features of magnitude and gradient direction.
    %
    thresh_str_xx_percent                   = threshold_top_percent( im_magnitude, 0.075 ); 
    b_correct_edge_strength                 = im_magnitude >= thresh_str_xx_percent;
    
    % Use the range of angles that was experimentally determined to be good angles.
    % Add tolerance to include some angles outside the range.
    b_correct_angles                        = im_angle > (5*pi/8) & (im_angle < 7*pi/8);             
    
    edge_image                              = im_magnitude;     % Copy the magnitudes
    
    %
    %  Isolate those edges that have the correct angles:
    %
    im_correct_strengths                            = edge_image;
    im_correct_strengths(~b_correct_edge_strength ) = 0;    % Eliminate edges at the wrong angles
    
    %
    %  Isolate those edges that have the correct angles:
    %
    im_correct_angles                               = edge_image;
    im_correct_angles( ~b_correct_angles )          = 0;    % Eliminate edges at the wrong angles
    
    
    %
    %   We could have done these two steps using the following code:
    %
    edge_image( ~b_correct_angles )         = 0;    % Eliminate edges at the wrong angles
    edge_image( ~b_correct_edge_strength )  = 0;    % Eliminate edges at the wrong strengths
    
    
    %
    %   A further combination might have been this:
    % 
    edge_image( ~b_correct_angles |  ~b_correct_edge_strength )  = 0; 
    
    %
    % Plot the before and after histograms:
    %
    figure('Position',[10 10 1024 768]);
    subplot(2,2,1);
    imagesc( im03 ); 
    colormap(gray);
    axis image;
    title('Original Image in grayscale ', 'FontSize', 16 );
    
    subplot(2,2,2);
    imagesc( im_correct_strengths.^(0.5) ); 
    colormap(gray);
    axis image;
    title('Strongest Edges, brightened ', 'FontSize', 16 );
    
    subplot(2,2,3);
    imagesc( im_correct_angles.^(0.5) ); 
    colormap(gray);
    axis image;
    title('Edges with correct Angles, brightened ', 'FontSize', 16 );
    
    
    subplot(2,2,4);
    imagesc( edge_image.^(0.5) );
    colormap( gray );
    axis image;
    title('Jointly Selected Edges, brightened ', 'FontSize', 16 );

end



function thresh = threshold_top_percent( im, fraction_of_top )
%function thresh = threshold_top_percent( input_image, fraction_of_top_values_to_keep )
%
% function to find threshold of top percent, given a single image of values.
% Given 0.1, this returns a threshold amount to isolate 10 percent of the pixels that are the brightest.
%

    [all_values, sort_key] = sort( im(:), 'ascend' );
    
    % Find cut-off for the TOP percent:
    cut_off                 = round( numel( im ) * (1-fraction_of_top) );
    
    thresh                  = all_values( cut_off );
end
   