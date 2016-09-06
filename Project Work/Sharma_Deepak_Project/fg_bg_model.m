function  mahal_fg= fg_bg_model(filename,fg_indices)

    im_lab=rgb2lab(filename);
    im_a = im_lab(:,:,2);
    im_b=im_lab(:,:,3);
    fg_a  = im_a( fg_indices );
    fg_b  = im_b(fg_indices);
    fg_ab=[fg_a fg_b];
    im_ab       = [im_a(:) im_b(:) ];
    size(fg_ab)
    size(im_ab)
    %disp(size(im_ab));
    % claculating mahanlobious distance for background, melon body and skin
    %with respect to their feature matrix
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
 

end