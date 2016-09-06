function HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_HSV
    clear all;
    close all;
    %list of images for which quantization has been performed
    a_list_of_files = { 'TBK_Kite.JPG', 'TBK_BRICKS.JPG', 'kod_parrots.png', 'TBK_Science_Frog.jpg', 'TBK_CAMO_FAILURE.JPG','kod_kid.png', 'kod_ref_image_cheryl.jpg' };
    %a_list_of_files = {'TBK_CAMO_FAILURE.JPG'};
    % Levels of quantization which will be performed on each image
    q_level=[ 256, 128, 64, 24, 16, 10, 7, 6, 5, 4, 3 ];
    q_length=size(q_level);
    
    
    for idx = 1:length(a_list_of_files)
        filename = a_list_of_files{idx};
        im = imread( filename );
        figure('Name','Original(L) , INDEXED COLOR IMAGE HSV(R)');
 
        %Showing the orginal RGB image on the left side of the figure
        subplot(1,2,1)
        imagesc( im );
        axis image;
        drawnow;   
        %Converting RGB image into HSV image
        im = rgb2hsv(im);
        %perfroming indexing for each qutization level
        for level=1:q_length(2)
        % CREATE AN INDEXED VERSION OF IMAGE, USING THE RGB COLORMAP:
        [ im_idx hsv_cmap ] = rgb2ind( im, q_level(level), 'nodither' );
        %display the image using this newly created colormap.
        %on the right side of the figure
        %converting the HSV colormap into RGB
        rgb_cmap = hsv2rgb( hsv_cmap );
        %clf;
        subplot(1,2,2);
        %displaying the indexed image using new colormap
        imagesc( im_idx );
        colormap( rgb_cmap ); 
        axis image;
        colorbar;
        pause(2);
        end
        pause(4)
        %del varibales for avoiding low memory
        close all;
        clear im
        clear rgb_cmap
        clear hsv_cmap
        clear im_idx
        
    end
end