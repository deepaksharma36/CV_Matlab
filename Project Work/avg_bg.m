function avg=avg_bg(bg_indices,image)
   
  
    image_r=zeros(size(image(:,:,1)));
    image_g=zeros(size(image(:,:,1)));
    image_b=zeros(size(image(:,:,1)));
    [I,J] = ind2sub(size(image),bg_indices);
    for counter=1:size(I,1)
        
        image_r(I(counter,1),J(counter,1)) = image(I(counter,1),J(counter,1),1);
        image_g(I(counter,1),J(counter,1)) = image(I(counter,1),J(counter,1),2);
        image_b(I(counter,1),J(counter,1)) = image(I(counter,1),J(counter,1),3);
        
    end

    mean_r=sum(sum(image_r))/size(I,1);
    mean_g=sum(sum(image_g))/size(I,1);
    mean_b=sum(sum(image_b))/size(I,1);
    avg=[mean_r,mean_g,mean_b];
end