function HW06_Sharma_Deepak_MAIN
clear all;
close all;
addpath( '../TEST_IMAGES' );
HW06_Sharma_Deepak_FIND_RASPBERRIES('TBK_RASPBERRIES__smr.jpg' );
pause(5);
clear all;
close all;
HW06_Sharma_Deepak_FIND_GRAFFITI( 'IMG_Graffiti_249.jpg' );
pause(5);
clear all;
close all;
HW06_Sharma_Deepak_FIND_AIRPLANE( 'TBK_Airplane.png' );
end