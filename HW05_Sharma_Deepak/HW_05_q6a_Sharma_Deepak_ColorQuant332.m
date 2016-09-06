function HW_05_q6a_Sharma_Deepak_ColorQuant332
    clear all;
    close all;
    addpath('../TEST_IMAGES');
    %We have been provided with a function gen_332_cmap( ).
    % list of input images for which quntization will be perfromed
    a_list_of_files = { 'TBK_Kite.JPG', 'TBK_BRICKS.JPG', 'kod_parrots.png', 'TBK_Science_Frog.jpg', 'TBK_CAMO_FAILURE.JPG','kod_kid.png', 'kod_ref_image_cheryl.jpg' };
    %generating color map using provide gen_332 method
    a_332_cmap = gen_332_cmap( );
    %For each image: Creating a 332 colormap:
    for idx = 1:length(a_list_of_files)
        filename = a_list_of_files{idx};
        %Reading/storing file in im varibale
        im = imread( filename );
        figure('Name','Original(L) , INDEXED COLOR IMAGE SHOWING ONLY 256 COLORS(R)');
        %showing original RGB image in left side of figure
        subplot(1,2,1)
        imagesc( im );
        axis image;
        drawnow;
        % CREATED AN INDEXED VERSION OF THAT IMAGE, USING THE 332 COLORMAP:
        im_idx = rgb2ind( im, a_332_cmap, 'nodither' );
        % Displaying the image, and switching the colormap to 332:
        subplot(1,2,2)
        %showing indexed/quntized image
        imagesc( im_idx );
        colormap( a_332_cmap );
        axis image;
        colorbar;
        pause(3);
        %xlabel(' INDEXED COLOR IMAGE -- SHOWING ONLY 256 COLORS ', 'FontSize', 22 );
    end
    close all;
end