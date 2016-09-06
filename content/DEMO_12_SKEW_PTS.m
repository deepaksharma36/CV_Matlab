function DEMO_12_SKEW_PTS()
%  SOME POINTS:

load xy_pts;

    xyh_pts     = [ xy_pts ; ... 
                    ones(1,size(xy_pts,2) ) ];

    Scl         = eye(2) * 0.5;
    Trans       = [ 1.5 ;  
                    4 ];
    SKEW        = [ -0.1   0.1 ];
    
    Rxyz        = RotMatZ( 30 * pi / 180 );
    
    SclTrans    = [  Scl  , Trans ; ...
                     SKEW ,    1 ]
              
    RotSclTrans = Rxyz * SclTrans 
    
    uv_pts      = RotSclTrans * xyh_pts; 


    figure( 'Position', [4 4 1024 768] );
    plot( xy_pts(1,:), xy_pts(2,:), 'ks-', 'MarkerSize', 13, 'MarkerFaceColor', 'b' );
    grid on;
    axis equal;
    axis( [0 10 0 10]);
    xlabel( 'X Sample points ',   'FontSize', 22 );
    ylabel( 'Y Value Computed ', 'FontSize', 22 );
    
    hold on;
    

    %
    %  COMPENSATE FOR THE MAGNITUDE OF THE COORDINATE:
    %
%     uv_pts  = uv_pts ./ repmat( uv_pts(3,:), 3, 1 );
    
    plot( uv_pts(1,:), uv_pts(2,:), 'ro-', 'MarkerSize', 13, 'MarkerFaceColor', 'r' );
    
    QRST = uv_pts / xyh_pts
    
    legend( { 'Original Points ', 'Transformed Points ' }, 'FontSize', 32, 'Location', 'East' );
    
end


