function DEMO_05_Translate_PTS()
%  SOME POINTS:
% xy_pts = [ ...
%     0.86  1.28  1.85  2.52  1.81  2.87  4.11  5.68  6.97  8.05  8.42  7.32  6.51  6.12  5.43  5.03  4.32  3.58  4.64  5.26  5.96  6.67  7.55 ;
%     1.21  0.69  1.47  1.27  1.15  1.44  1.88  2.43  2.81  2.81  3.57  2.99  2.52  3.08  2.73  2.14  2.41  1.79  1.88  2.84  2.55  3.16  2.61 ;
% ];

load xy_pts;

%     x_values    = xy_pts(1,:);
%     y_values    = xy_pts(2,:);
%
%     % Form the XY  matrix:
%     X   = [ x_values  ;  ones(1,length( x_values )) ];
%     Y   = [ xy_pts(2,:) ];

    Scl     = eye(2);
    Trans   = [ 1.5 ; 4 ];
    
    fprintf('NOTE: TRANSLATION IS OBNOXIOUS, BECAUSE WE NEED TO STOP AND ADD SOMETHING TO EVERY POINT...\n ');
    uv_pts  = Scl * xy_pts   +   repmat( Trans, 1, length(xy_pts) );


    figure( 'Position', [4 4 1024 768] );
    plot( xy_pts(1,:), xy_pts(2,:), 'ks-', 'MarkerSize', 13, 'MarkerFaceColor', 'b' );
    grid on;
    axis equal;
    axis( [0 10 0 10]);
    xlabel( 'X Sample points ', 'FontSize', 22 );
    ylabel( 'Y Vaclue Computed ', 'FontSize', 22 );
    
    hold on;
    
    plot( uv_pts(1,:), uv_pts(2,:), 'ro-', 'MarkerSize', 13, 'MarkerFaceColor', 'r' );
    
    legend( { 'Original Points ', 'Transformed Points ' }, 'FontSize', 32, 'Location', 'North' );
    
end
