function HW03_TBK_KEY_Q04_Thermometer()
%% 
% 
%  HW03_TBK_KEY_Q04
%
% Consider the image THERMOMETER_20160213_1110.jpg. Create an imaging chain to make it easier
% to read the temperature on the thermometer. Describe what contrast your imaging chain is
% trying to enhance. Describe your approach to this. 
% Show the results before and after your enhancement.

    %% 
    %  Fix the shopping list, so that the text is visible, but do it using
    %  a histogram analysis,and computations.
    %

    % Read in the input image:
    im01    = imread( 'THERMOMETER_20160213_1110.jpg');
    
    % Convert to double, because I always work in double:
    im02    = im2double( im01 );

    % The contrast between red and white, happens in the blue and green channels:
    % Find the sum of those two channels as a signal to use.
    im03    = ( im02(:,:,2) + im02(:,:,3) ) / 2;
    
    % Histogram equalize the image :
    im04    = histeq( im03 );
    
    %% 
    % Find the histogram of the input monochrome image
    [ hist_freqs_in, hist_bin_values_in ]    = imhist( im03, 256 );
    
    % Find the histogram of the resulting image:
    [ hist_freqs_out, hist_bin_values_out ]  = imhist( im04, 256 );
    
    %%
    % Plot the before and after histograms:
    figure('Position',[10 10 1024 768]);
    subplot(1,2,1);
    bar( hist_bin_values_in, hist_freqs_in, 0.4, 'FaceColor', 'b' );
    title('Histogram Distribution of Green + Blue in ', 'FontSize', 20 );
    
    subplot(1,2,2);
    bar( hist_bin_values_out, hist_freqs_out, 0.4, 'FaceColor', 'r' );
    title('Histogram Distribution of Green + Blue out ', 'FontSize', 20 );
    
    
    %% 
    %  Show the resulting image:
    %
    figure('Position',[10 10 1024 768]);
    imagesc( im04 );
    colormap( gray );
end