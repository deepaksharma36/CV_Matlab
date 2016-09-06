function HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_RGB
    clear all;
    close all;
    %list of images for which quantization has been performed
    a_list_of_files = { 'TBK_Kite.JPG', 'TBK_BRICKS.JPG', 'kod_parrots.png', 'TBK_Science_Frog.jpg', 'TBK_CAMO_FAILURE.JPG','kod_kid.png', 'kod_ref_image_cheryl.jpg' };
    %a_list_of_files = {'TBK_Science_Frog.jpg'};
    % Levels of quantization which will be performed on each image
    q_level=[ 256, 128, 64, 24, 16, 10, 7, 6, 5, 4, 3 ];
    q_length=size(q_level);
    for idx = 1:length(a_list_of_files)
        filename = a_list_of_files{idx};
        im = imread( filename );
        figure('Name','Original(L) , INDEXED COLOR IMAGE RGB(R)');
        %performing indexing for each quntization level 
        for level=1:q_length(2)
            drawnow;
            subplot(1,2,1)
            imagesc( im );
            axis image;
            % CREATE AN INDEXED VERSION OF IMAGE, USING THE RGB COLORMAP:
            [ im_idx cmap ] = rgb2ind( im, q_level(level), 'nodither' );
            %display the image using this newly created colormap.
            subplot(1,2,2);
            %diplaying indexed image on the right side of the figure
            imagesc( im_idx );
            %using new colormap 
            colormap( cmap ); 
            axis image;
            colorbar;
            pause(2);
        end
        pause(4)
        close all;
    end
end