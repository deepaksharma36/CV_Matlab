function indicies=fg_coordinates(lbl,counter)
        
        
        [row,col] =find(lbl==counter);
        
        fg_indices  = sub2ind( size(lbl), round(row), round(col) );
        %indicies=datasample(fg_indices',ceil((size(fg_indices,1))));
        indicies=fg_indices;
    

end
