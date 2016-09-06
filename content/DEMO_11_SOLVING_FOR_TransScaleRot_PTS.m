function DEMO_11_SOLVING_FOR_TransScaleRot_PTS()
%  SOME POINTS:


load xy_pts;


    xyh_pts     = [ xy_pts ; ... 
                    ones(1,size(xy_pts,2) ) ];

    Scl     = eye(2) * 0.5;
    Trans   = [ 5 ; 4 ];
    
    Rxyz    = RotMatZ( 30 * pi / 180 );
    
    SclTrans = [  Scl , Trans ; ...
                  0  0      1 ]
              
    RotSclTrans = Rxyz * SclTrans 
    
    uv_pts      = RotSclTrans * xyh_pts; 


    figure( 'Position', [4 4 1024 768] );
    plot( xy_pts(1,:), xy_pts(2,:), 'ks-', 'MarkerSize', 13, 'MarkerFaceColor', 'b' );
    grid on;
    axis equal;
    axis( [0 10 0 10]);
    xlabel( 'X  ', 'FontSize', 22 );
    ylabel( 'Y  ', 'FontSize', 22 );
    
    hold on;
    
    plot( uv_pts(1,:), uv_pts(2,:), 'ro-', 'MarkerSize', 13, 'MarkerFaceColor', 'r' );
    

    %
    %  SOLVE FOR THE MATRIX TRANSFORMATION:
    %
    QRST = uv_pts / xyh_pts

    legend( { 'Original Points ', 'Transformed Points ' }, 'FontSize', 32, 'Location', 'NorthEast' );
    
end


