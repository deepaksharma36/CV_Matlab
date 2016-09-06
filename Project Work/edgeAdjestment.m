function c= edgeAdjestment(edge_indicies,c)

[I,J] = ind2sub(size(c),edge_indicies);

for counter=1:size(I,1)
    if I(counter)-1>0 && J(counter)-1>0 && J(counter)+1<size(c,2) && I(counter)+1<size(c,1)
        N1=c(I(counter)-1,J(counter));
        N2=c(I(counter),J(counter)-1);
        N3= c(I(counter)-1,J(counter)-1);
        N4=c(I(counter)+1,J(counter));
        N5=c(I(counter),J(counter)+1);
        N6= c(I(counter)+1,J(counter)+1);
        N7= c(I(counter)+1,J(counter)+1);
        N8= c(I(counter)+1,J(counter)+1);
        options=[N1,N2,N3,N4,N5,N6,N7,N8];
        c(I(counter),J(counter))=max(options);   
    end
end
end
