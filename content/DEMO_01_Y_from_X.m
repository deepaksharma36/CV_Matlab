function DEMO_01_Y_from_X()
%  We know Y = mx + 1.
%
%  We can write this as a matrix as:
% 
% Y = [m b] * [ x1 1 ;
%               x2 1 ;
%               x3 1 ].... 

% x points to find y at:
x_values = [ ...
    0.86  1.28  1.85  2.52  1.81  2.87  4.11  5.68  6.97  8.05  8.42  7.32  ...
    6.51  6.12  5.43  5.03  4.32  3.58  4.64  5.26  5.96  6.67  7.55 ;
];

    % Here is the equation of my line:
    MB  = [ 1/4, 3 ]
    
    % Form the X matrix:
    X   = [ x_values  ;  ...
            ones(1,length(x_values)) ];



    Y = MB * X 
    
    figure( 'Position', [4 4 1024 768] );
    plot( x_values(:), Y(:), 'ks', 'MarkerSize', 15, 'MarkerFaceColor', 'b' );
    grid on;
    axis( [0 10 0 10]);
    xlabel( 'X Sample points ', 'FontSize', 22 );
    ylabel( 'Y Value Computed ', 'FontSize', 22 );

    %
    %  NOW -- SUPPOSE YOU DID NOT KNOW MB!!
    %
    %  WE KNOW THAT:
    %  
    %  Y = MB * X
    %
    %  BEING SILLY, WE WISH WE COULD WRITE:
    %
    %  Y / X = MB
    %
    
    GUESS_FOR_MB = Y / X

end


