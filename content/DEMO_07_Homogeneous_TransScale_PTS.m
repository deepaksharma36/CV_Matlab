function DEMO_07_Homogeneous_TransScale_PTS()
%  SOME POINTS:
% xy_pts = [ ...
%     0.86  1.28  1.85  2.52  1.81  2.87  4.11  5.68   8.05   7.32  6.12  5.43   4.32  3.58  4.64  5.26  5.96  6.67  7.55 ;
%     1.21  0.69  1.47  1.27  1.15  1.44  1.88  2.43   2.81   2.99  3.08  2.14  2.41  1.79  1.88  2.84  2.55  3.16  2.61 ;
% ];

load xy_pts;

    xyh_pts     = [ xy_pts ; ... 
                    ones(1,size(xy_pts,2) ) ];

    Scl     = eye(2) * 0.5;
    Trans   = [ 1.5 ; ...
                4.0 ];
    
    SclTrans = [  Scl , Trans ; ...
                  0  0      1 ]
    
    uv_pts  = SclTrans * xyh_pts; 


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
