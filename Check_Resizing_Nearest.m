function Check_Resizing_Nearest(fn)
    im=rgb2gray(imread(fn));
    imshow(im)
    disp('Image Size')
    originalSize=(size(im));
    sub_sample=[ 1 2 4 8 16 24 32 48 50 52 56 64 128 ];
    disp(size(sub_sample(:)))

    
    for index=1:size(sub_sample')
        %sub_sample_image=im(1:sub_sample(index):end,1:sub_sample(index):end);
        %size(sub_sample_image)
        newSize=round(size(im) ./ sub_sample(index));
        im_small = imresize( im, newSize, 'nearest' );
        im_restored = imresize(im_small, originalSize, 'nearest');
        imshow(im_restored);
        title(strcat('Sub-Sampling is',num2str(sub_sample(index))));
        pause(2);
    end
end
