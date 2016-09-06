function HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_LAB
    clear all;
    close all;
    %adding path of test images so that scrip can access image files.
    addpath('../TEST_IMAGES');
    %list of images for which quantization has been performed
    a_list_of_files = { 'TBK_Kite.JPG', 'TBK_BRICKS.JPG', 'kod_parrots.png', 'TBK_Science_Frog.jpg' ,'TBK_CAMO_FAILURE.JPG','kod_kid.png', 'kod_ref_image_cheryl.jpg' };
    %a_list_of_files = {'kod_kid.png'};
    % Levels of quantization which will be performed on each image
    q_level=[ 256, 128, 64, 24, 16, 10, 7, 6, 5, 4, 3 ];
    q_length=size(q_level);
    
    %for loop for accessing image file one by one
    for idx = 1:length(a_list_of_files)
        filename = a_list_of_files{idx};
        %reading image file in im varibale
        im = imread( filename );
        figure('Name','Original(Left) , INDEXED COLOR IMAGE LAB(Right)');
        subplot(1,2,1)
        imagesc( im );
        axis image;
        drawnow;   
        %converting RGB image into CLab format
        im = rgb2lab(im);
        for level=1:q_length(2)
            %perfoming indexing for each image
            [ im_idx lab_cmap ] = rgb2ind( im, q_level(level), 'nodither' );
            %Again, display the image using this newly created colormap.
            rgb_cmap = lab2rgb( lab_cmap );
            %clf;
            subplot(1,2,2);
            %dispaying the indexed image on the right side of the
            %figure using new Color map
            imagesc( im_idx );
            %taking abs value of RGB_Cmap as value of colomap should be [0 1]
            colormap( abs(rgb_cmap) ); 
            axis image;
            colorbar;
            clear rgb_cmap;
            pause(2);
        end
        pause(4)
        close all;
        
        

        clear im_idx
        
        
    end
end