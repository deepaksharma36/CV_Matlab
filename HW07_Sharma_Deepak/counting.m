function n=counting(mellon)

  %working of bwlable has been explain into the write up  
  %Task can also be perfromed by bwconncomp.NumObjects 
  L = bwlabel(mellon);
  figure('Name','label'),imagesc(L);
  n=max(max(L));
  sprintf('There are %d pieces of melon', n)
  
  
  

end