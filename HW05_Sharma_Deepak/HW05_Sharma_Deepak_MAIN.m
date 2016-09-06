function HW05_Sharma_Deepak_MAIN
    clear all;
    close all;
    addpath('../TEST_IMAGES');
    HW05a_find_Convenient_Angles
    clear all;
    close all;
    HW_05_q6a_Sharma_Deepak_ColorQuant332
    pause(2)
    clear all;
    close all;
    HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_RGB
    clear all;
    close all;
    HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_HSV
    clear all;
    close all;
    HW_05_q6b_Sharma_Deepak_ColorQuant_NLEVELS_LAB
    
    
end

function HW05a_find_Convenient_Angles
    max_dist = 9;
    %Working of MashGrid funtion in Matlab
    %M = [0:L1] N=[0:L2]
    % [A B]=MashGrid(M,N):
    %Provides two matrixis A and B or size size(N)*size(M)
    %where A =[A;A;A;A..size(N)] and B =[B' B' B' ...size(M)]
    %Hence A =
    %0	1	2	.   .  . L1
 	%0	1	2	.   .  . L1
 	%0	1	2	.   .  . L1
 	%.  .   .   .   .  . .
 	%size(M) Rows 
 	%Hence B =
    %0 0 . . . size(N)Cols
    %1 1 . . . size(N)Cols
    %2 2 . . . size(N)Cols
    %. . . . . size(N)Cols
    %L2 L2 . . size(N)Cols
    [dx dy] = meshgrid( 0:max_dist, 0:max_dist ); 
    %find all the associated angles for changes in y vs x using atan2.
    %atan2 calculates tan inverse
    angles = atan2(dy,dx); 
    % Converted angles from rad to deg using radtodeg cmd
    angles=radtodeg(angles)
    % removed duplicate values from vector using unique( ) command,
    uniq_angles = unique(angles);
    %displaying the number of uniq angles 
    disp('number of uniq angles ');
    disp(size(uniq_angles));
    figure('Name','Distribution of angles','Position', [10 10 1024 768]);
    subplot(1,2,1)
    plot( uniq_angles, uniq_angles, 'bs' );
    %sorting the uniq angle vector to determine max difference between
    %any two angle in all uniqe angles.
    uniq_angles=sort(uniq_angles);
    diff=[ uniq_angles ;0] - [0;uniq_angles];
    
    maxval=max(sort(diff));
    disp('Maximum Difference between two Angle:')
    %finding maximum value of angle in all unique angles
    disp(maxval);
    disp('Maximum Value of Angle:')
    disp(max(uniq_angles));
    disp('Minmum Value of Angle:')
     %finding minimum value of angle in all unique angles
    disp(min(uniq_angles));
    y=angles(:)';
    subplot(1,2,2);
    xlabel('Range of angles:');
    ylabel('Number of Pixels');
    %ploting the frequnacy of each angle present in angle matrix
    %using histogram
    hist(y,90);

end

