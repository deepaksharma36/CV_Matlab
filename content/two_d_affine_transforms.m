function two_d_affine_transforms()

    img         = rgb2gray(im2double(imread('Shapes_on_black_bkgrnd.tif')));
    dims        = size( img );
    %Original
    T_identity  = [ 1 0 0; 
                    0 1 0;
                    0 0 1 ];

    %Translation
    T_shift = [ 1 0 100; 
                0 1 100;
                0 0    1 ];

    %Scaling
    T_Scale = [ 0.5 0   0; 
                0   0.5 0;
                0   0   1];

    %Rotation
    T_Rot = [   0.5253  0.8509 0; 
                -0.8509 0.5253 0;
                0            0 1 ];

    %Shear
    T_Shear = [ 1    0.5  0 ; 
                0.5  1    0 ; 
                0    0    1 ];

    % Find the location of all the image values gt 0:
    [y,x]   = find(img > 0);
    x       = x';                           % Convert to a  row vector.
    y       = size(img,2) - y';             % Convert to RH coordinate system, and a row vector.
    h_coord = ones(1,length(y));            % Make a homogeneous coordinate system.
    
    S       = [ x; 
                y; 
                h_coord ];

    figure;
    subplot(3,3,1);
    S_new = round(T_identity * S);          % Do the identity multiplication  
                                            % and round to the nearest pixel location.

    scatter(S_new(1,:),S_new(2,:));         % Plot the points.
    
    
    %  Original
    set(gca, 'xlim', [0 dims(2)], 'ylim', [0 dims(1)]);
    title('Original Content');

    %  Translation
    subplot(3,3,2);
    S_new = round(T_shift * S);
    scatter(S_new(1,:),S_new(2,:));
    set(gca, 'xlim', [0 dims(2)], 'ylim', [0  dims(1)]);
    title('Tranlated Content');

    %  Scaled Content
    subplot(3,3,3);
    S_new = round(T_Scale * S);
    scatter(S_new(1,:),S_new(2,:));
    set(gca, 'xlim', [0 dims(2)], 'ylim', [0  dims(1)]);
    title('Scaled Content');

    %  Rotated Content
    subplot(3,3,4);
    S_new = round(T_Rot * S);
    scatter(S_new(1,:),S_new(2,:));
    set(gca, 'xlim', [0 dims(2)], 'ylim', [-dims(1)  dims(1)]);
    axis equal;
    title('Rotated Content');

    %  Shearing
    subplot(3,3,5);
    S_new = round(T_Shear * S);
    scatter(S_new(1,:),S_new(2,:));
    set(gca, 'xlim', [0 dims(2)], 'ylim', [0  dims(1)]);
    title('Shearing');
    
end

