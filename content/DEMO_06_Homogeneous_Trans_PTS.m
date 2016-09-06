function DEMO_06_Homogeneous_Trans_PTS()

load xy_pts;

    %
    %   MAKE HOMOGENEOUS POINTS:
    %
    xyh_pts     = [ xy_pts ; ... 
                    ones(1,size(xy_pts,2) ) ]

    Scl     = eye(2);
    Trans   = [ 1.5 ; 
                4   ];
    
    %
    %   BUILD THE TRANSLATION MATRIX WITH THE X and Y TRANSLATION AMOUNTS:
    %
    fprintf('BUILD THE TRANSLATION MATRIX WITH THE X and Y TRANSLATION AMOUNTS:\n');
    TranslationMatrix = [  Scl , Trans ; ...
                           0  0      1 ]
                       
    uv_pts  = TranslationMatrix * xyh_pts;

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


