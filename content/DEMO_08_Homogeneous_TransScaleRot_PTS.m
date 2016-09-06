function DEMO_08_Homogeneous_TransScaleRot_PTS()
%  SOME POINTS:

load xy_pts;

    xyh_pts     = [ xy_pts ; ... 
                    ones(1,size(xy_pts,2) ) ];

    Scl     = [ (1/3)   0    0 ;
                  0   (1/3)  0 ;
                  0     0    1 ];
              
    Trans   = [ 1  0   1.5 ; 
                0  1     4 ;
                0  0     1 ];
    
    Rxyz    = RotMatZ( 30 * pi / 180 );
    
    RotSclTrans = Rxyz * Scl * Trans
    uv_pts      = RotSclTrans * xyh_pts;  

    figure( 'Position', [4 4 1024 768] );
    plot( xy_pts(1,:), xy_pts(2,:), 'ks-', 'MarkerSize', 13, 'MarkerFaceColor', 'b' );
    grid on;
    axis equal;
    axis( [0 10 0 10]);
    xlabel( 'X Sample points ', 'FontSize', 22 );
    ylabel( 'Y Value Computed ', 'FontSize', 22 );
    
    hold on;
    
    plot( uv_pts(1,:), uv_pts(2,:), 'ro-', 'MarkerSize', 13, 'MarkerFaceColor', 'r' );    
    legend( { 'Original Points ', 'Transformed Points ' }, 'FontSize', 32, 'Location', 'North' );

end
