function cm = gen_332_cmap( )
% Create the famous 332 colormap.
% Programmed for teaching, not for efficiency.
% Thomas Kinsman
%

    cm = zeros( 256, 3 );           % Pre-allocate 256 rows, and 3 columns
    idx = 1;
    for red_level = 0 : 1/(8-1) : 1
        for green_level = 0 : 1/(8-1) : 1    
            for blue_level = 0 : 1/(4-1) : 1 %less number of levels 4(0 .33 .66 1)
                cm(idx,1)   = red_level;
                cm(idx,2)   = green_level;
                cm(idx,3)   = blue_level;
                idx         = idx + 1;
            end
        end
    end

end