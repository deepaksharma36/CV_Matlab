function HW03_TBK_KEY_Q03()
%% 
% 
%  HW03_TBK_KEY_Q03 
%
%  One method for solving the shopping list problem is to try many different possibilities, and try many thresholds.
%  The result of this is a black-and-white binary image.
%
%  Another method is to use imadjust( ) with the correct range of values to stretch the pixel
%  values in the middle to the top and bottom.
%

    %% 
    %  Fix the shopping list, so that the text is visible, but do it using
    %  a histogram analysis,and computations.
    %

    % Read in the input image:
    im01    = imread( 'SHOPPING_LIST.jpg');
    
    % Convert to double, because I always work in double:
    im02    = im2double( im01 );
        
    % Throw out the color information, because there isn't much color
    % information that is useful:
    im03    = rgb2gray( im02 );
    
    %% Find the histogram of the grayscape image:
    [ hist_frequencies, hist_bin_value ]    = imhist( im03, 256 );


    %% 
    % Plot the histogram to see the distribution:
    % 
    % Set up the axis to be the full size:
    axis( [ 0 1.0 0 max(hist_frequencies) ] );
    bar( hist_bin_value, hist_frequencies, 0.5, 'FaceColor', 'b' );
    hold on;    
    title('Histogram of pixel Values ', 'FontSize', 22);


    % Assume that 75% of the paper is white, so find the first quartile, and use the 
    % bin that it occurs at as the threshold between white and black:
    hist_bin_sums               = cumsum( hist_frequencies );
    num_pixels                  = hist_bin_sums( end );
    num_pix_in_first_quartile   = num_pixels * 0.25;
    
    idx = 1;
    while  ( idx < length( hist_bin_sums ) )
        if ( hist_bin_sums(idx) >= num_pix_in_first_quartile )
           break; 
        end
        idx = idx + 1;
    end

    thresh_idx  = idx;
    thresh      = hist_bin_value( thresh_idx );

    %%
    %
    % We already plotted the histogram to see the distribution:
    % bar( hist_bin_value, hist_frequencies, 0.5, 'FaceColor', 'b' );
    % hold on;
    %
    plot( [1 1] * thresh, [0 max(hist_frequencies) ], 'r-', 'LineWidth', 1 );

    %
    % Threshold the image at this value:
    im04    = im2bw( im03, thresh );
    
    %% 
    %  Show the results:
    %
    figure('Position',[10 10 1024 768]);
    imagesc( im04 );
    colormap( gray );
end