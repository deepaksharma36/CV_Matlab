function HW02_Sharma_Deepak()
    images={'TBK_Kite.jpg' ; 'TBK_BRICKS.jpg'; 'football.jpg'; 'peppers.png'; 'finger_prints.jpg'; 'kod_kid.png';'kod_parrots.png'; 'Might_or_Might_NOT.jpg'};
    images=cellstr(images);
    for index=1:size(images)
        img=char(images(index));
        Check_Resizing_Nearest(img);
        Check_Resizing_Default(img);
        CHECK_QUANTIZATION_HW(img);
    end

    Contrast_Control_AdaptHistEq('Might_or_Might_NOT.jpg');
    Contrast_Control_AdJust('Might_or_Might_NOT.jpg');
    Contrast_Control_histEq('Might_or_Might_NOT.jpg');
end


function Check_Resizing_Nearest(fn)
    
    im=(imread(fn));
    imshow(im);
    %disp('Image Size')
    originalSize=size(im);
    originalSize=[originalSize(1),originalSize(2)];
    sub_sample=[ 1 2 4 8 16 24 32 48 50 52 56 64 128 ];
    %disp(size(sub_sample(:)))

    
    for index=1:size(sub_sample')
        %sub_sample_image=im(1:sub_sample(index):end,1:sub_sample(index):end);
        %size(sub_sample_image)
        newSize=round(size(im) ./ sub_sample(index));
        newSize=[newSize(1),newSize(2)];
        %disp(newSize);
        im_small = imresize( im, newSize, 'nearest' );
        im_restored = imresize(im_small, originalSize, 'nearest');
        imshow(im_restored);
        title(strcat('Sub-Sampling is',num2str(sub_sample(index))));
        pause(1.5);
    end
end

function Check_Resizing_Default(fn)
    
    im=(imread(fn));
    imshow(im);
    %disp('Image Size')
    originalSize=size(im);
    originalSize=[originalSize(1),originalSize(2)];
    sub_sample=[ 1 2 4 8 16 24 32 48 50 52 56 64 128 ];
    %disp(size(sub_sample(:)))

    
    for index=1:size(sub_sample')
        %sub_sample_image=im(1:sub_sample(index):end,1:sub_sample(index):end);
        %size(sub_sample_image)
        newSize=round(size(im) ./ sub_sample(index));
        newSize=[newSize(1),newSize(2)];
        %disp(newSize);
        im_small = imresize( im, newSize);
        im_restored = imresize(im_small, originalSize);
        imshow(im_restored);
        title(strcat('Sub-Sampling is (Default)',num2str(sub_sample(index))));
        pause(1.5);
    end
end

function CHECK_QUANTIZATION_HW(fn)
    original_image=(imread(fn));
    sub_sample=[ 1 2 4 8 16 32 40 50 60 70 80 90 100 128 ];
    %disp(size(sub_sample(:)))
    for index=1:size(sub_sample(:))
        %sub_sample_image=im(1:sub_sample(index):end,1:sub_sample(index):end);
        %size(sub_sample_image)
        quantization=sub_sample(index);
        new_im = round( original_image ./ quantization );
        im_restored = new_im * quantization;
        imshow(im_restored);
        title(strcat('Quantization Factor ', num2str(sub_sample(index))));
        pause(1.5);
    end
end

function Contrast_Control_histEq(img)
    img=imread(img);
    figure('Name','Histogram Equalization');
    subplot(2,2,1);
    imshow(img);
    subplot(2,2,3);
    imhist(img);
    img=histeq(img);
    %img=imadjust(img);
    %img=adapthisteq(img);
    subplot(2,2,2);
	imshow(img);
    subplot(2,2,4);
    imhist(img);
end

function Contrast_Control_AdJust(img)
    img=imread(img);
    figure('Name','Adjusted Image');
    subplot(2,2,1);
    imshow(img);
    subplot(2,2,3);
    imhist(img);
    %img=histeq(img);
    img=imadjust(img);
    %img=adapthisteq(img);
    subplot(2,2,2);
	imshow(img);
    subplot(2,2,4);
    imhist(img);
end

function Contrast_Control_AdaptHistEq(img)
    img=imread(img);
    figure('Name','Adaptive Histogram');
    subplot(2,2,1);
    imshow(img);
    subplot(2,2,3);
    imhist(img);
    %img=histeq(img);
    %img=imadjust(img);
    %img=adapthisteq(img);
    subplot(2,2,2);
	imshow(img);
    subplot(2,2,4);
    imhist(img);
end