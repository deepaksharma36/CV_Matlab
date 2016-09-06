function CHECK_QUANTIZATION_HW(fn)
    original_image=rgb2gray(imread(fn));
    sub_sample=[ 1 2 4 8 16 32 40 50 60 70 80 90 100 128 ];
    %disp(size(sub_sample(:)))
    for index=1:size(sub_sample(:))
        %sub_sample_image=im(1:sub_sample(index):end,1:sub_sample(index):end);
        %size(sub_sample_image)
        quantization=sub_sample(index);
        new_im = round( original_image / quantization );
        im_restored = new_im * quantization;
        imshow(im_restored);
        title(strcat('Quantization Factor ', num2str(sub_sample(index))));
        pause(2);
    end
end
