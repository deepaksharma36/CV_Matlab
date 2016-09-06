% HW01 Instructions…
%
% Create a file called “HW01_<your last name w/o spaces>_<your first
%name…>.m
% In it put the commands from the following, and add your answers.
% You can add your answer using the display command:
disp('Answer 0: Put your answers to the questions here, so that when the');
disp('Command is run, they will print out.');
% Compare element-wise versus array-wise operations on matrices:
m4 = magic( 4 );
% Q1: What does this operation do?
% Does it work on the entire matrix or on each element?
m4.^2;
disp('Ans 1: ^ is power operation, will do power opration on each element of M4');
% Q2: What does this operation do?
% Does it work on the entire matrix or on each element?

m4^2
disp('Ans 2: ^ is power operation, . will do power opration on entire matrix M4,');
disp('matrix will be mulipiled with itself after M4 ');

%
% Notice when there are, or are-not, semicolons on the end of the lines.
%
% Q3: Can you generate a 7x7 magic square?
disp('Ans 3: yes using magic(7)')
% (This defines the variable m7?)
%
m7 = magic( 7 )


% Q4: Print out one element:
disp('Ans 4: an element from first row first coloum of m7 can be accessed')
disp('using m7(5,5)')
ltuae = m7( 5, 5 )
% Q5: Extract a sub-matrix from rows 1 to 4, and columns 1 to 2:
disp('Ans 5: sub-matrix can be accessed using m7(1:4,1:2), row number 1 to 4')
disp('inclusive and col number 1 to 2 will be accessed')
submat = m7( 1:4, 1:2 )
% Q6: Treat the entire matrix as one long vector, and print the 34th
disp('Ans 6: m(34) will 34th element by coverting entire matrix a row matrix')
disp('where each col will be placed one after other ')
disp('example: [1 2 3 ; 4 5 6] will be treated as [1 4 2 5 3 6]')
element=m7(34)
% Q7: If we wanted to print element #34 using (row,col) notation, what notation would we use?
% Demonstrate that here:
disp('Ans 7: 34= 4*7 + 6 = so 5th col 6th row')
m7( 6, 5 ) % This is wrong, fix it…
% Q8: Extract the last row:
disp('Ans 8: m7(end,:) will show last row"s all elements')

% Remember that you can use “end” as the last element of a dimension.
% This will be on a quiz later.
%
m7( end, : )
% Q9: What command would I use to get this row of the matrix, m7:

% 38 47 7 9 18 27 29
% ANS: write the command and execute it.
disp('Ans 9: m7(2,:) will show 2nd row"s all elements')
m7(2,:)
% Q10: Extract the 4th column, and transpose it using the .' operator:
disp('Ans 10: m7(:,4) will show 4nd cols all elements')
% REM:
% The .' works on the values.
% The ' operator alone converts imaginary values.
%
% Does it print as a row or a column?
disp(' m7(:,4) will return col vector after tacking transpose m7(:,4) will')
disp('be converted to a ROW verctor')
m7( :, 4 ).'
% Q11: Read in the cameraman image, from the Matlab image example repository:
disp('Ans 11: image can be read/stored in matrix using imread function')
im_cam = imread( 'cameraman.tif' );
imshow( im_cam );
%pause
% Q12: Get a sub-section of the cameraman, and show just the heads of the man and the tripod:
disp('Ans 12 can extract using im_cam( 85:end, 74:end -48)')
im_cam_head = im_cam( 80:end, 74:end -48);
imshow( im_cam_head );
pause(2)
% Q13: What command would you use to isolate the part of the image that is the
% faint building in the back right side?

im_subset = imshow(im_cam(130:160,218:end-23));
disp('Ans 13: im_subset = imshow(im_cam(130:160,218:end-23));')
%imshow(im_subset)
imagesc( im_subset );
pause( 3 ); % This waits 3 seconds.
% Q14: Read in the peppers.png image:
im_peppers = imread( 'peppers.png' );
imshow( im_peppers );
pause(2);
% Q15:
% Get a sub-section of the peppers image, and display it:
%
% WHY DO I NEED THE THIRD PARAMETER HERE?? 
% I DIDN'T USE THAT FOR THE CAMERA MAN?
%
% ANS:
sub_im = im_peppers( 164:255 , 200:312 , : );
disp('Ans 15: sub_im is a 3D vector/aaray/matrix, 3rd vector is required for')
disp('showing Composition of Red Green and Blue color for each 24 bit pixel ');
disp('Camera Man image was a gray scale image and it only have row and col')
disp('vectors and each pixel shows intensity of pixel between 0 and 255');
imshow( sub_im );
% Q16:
% Go back to the camera man:
%
% Let's multiply the values, to see the dark regions better.
% Does this help us see the dark regions?
% Does it hide any regions?
%
% ANS ALL QUESTIONS:
im_cam_mult = im_cam * 4;

%figure('Name','without im2double'),imshow(im_cam_mult)
imagesc( im_cam_mult );
disp('Ans 16: all the less dark pixel(gray) pixels after muliplying with 4')
disp('got higher values near 255')
disp('while pixel with less intensity stay near the black range (say 0 to 20)')
disp('so dark regions can be seen properly')
disp('but at the same time gray intensity pixel will become white because')
disp('100*4 = 255(memory space is only 8 bit)')
% Q17: Try this version, what is different?
% ANS:
disp('Ans 17: im2double function changed the unit8 bit represnetation of')
disp('pixel intensity to 0-1 double precision pixel intensity. ')
disp('now after muliply with 4 values 1 or grater than 1 will be perceived White')
%figure('Name','Before'),imshow(im_cam);
im_cam_mult = im2double( im_cam ) * 4;
%figure('Name','After'), imshow(im_cam_mult);
pause(2)
imagesc( im_cam_mult );
disp('Ans 18 This operation has up lifted the gray color to while.')
disp('We should do this if we want to diferentiate ')
disp('between less dark and completly dark, because then this operation can')
disp('show contrast in btween dark and less dark region and subtle diferences')
disp('between similar looking areas(dark) can be percived easly')
disp('pocket are visible after this operation ')
% Q18: When we do this what does it do? Does it help us see his pockets?
% Why or why not? What did we do to the image? What can you not see?
%
% Now I am going to clip the current im_cam_mult image to a maximum
% value of 1, and re-display it.
im_cam_mult( im_cam_mult > 1.0 ) = 1.0;
imagesc( im_cam_mult );
%figure('Name','im_cam_mult'),imshow(im_cam_mult);
% That operation selects only the values of the image that are over 1.0,
% and those are set to 1.0
% It does this by creating a temporary boolean variable "im_cam_mult >1.0",
% and using it to impact only those pixels.
% Lets get a clean copy of the cameraman, and mess up the values:
im_uint8 = imread('cameraman.tif');
%clear im_double;
im_double = im2double( im_uint8 );
% Q19: What do the following commands emphasize about the image?
% How do they differ?
%
% ANS:
disp('Ans 19: .^3 operation on values in range [0-1] will reduced the') 
disp('intensity level each pixel in resultant image')
disp('but the pixel with intensity 1 and 0 will be intact so we can identify')
disp('pure white space in Image by creating contrast')
im_new = im_double.^3 ;
imagesc( im_new );

%figure('Name', '.^3'),imshow(im_new)
im_new = im_double.^(1/2.8);
disp(' .^(1/2.8) operation on values in range [0-1] will increase the')
disp('intensity level of each pixel but pixel')
disp('but pixel with intensity 0 and 1 will be intact so we can identify')
disp('pure black color/space in image by creating contrast')
%imagesc( im_new );
imshow(im_new)
pause(2)
% Q20:
%RGBYM=imread(RED_GREEN_BLUE_YELLOW_MEMORY_COLORS.jpg);
%RGBYM_double=im2double(RGBYM)
% Read in the image, RED_GREEN_BLUE_YELLOW_MEMORY_COLORS.jpg
% Convert the image to a double format.
 im = im2double( imread('RED_GREEN_BLUE_YELLOW_MEMORY_COLORS.jpg') );
% And display the following versions of the image
% 20a: The image itself.
imshow(im);
pause(2);
% Then pause for two seconds. pause(2).
%
% 20b: Just the red channel (the red color plane).
imshow(im(:,:,1))
% Then pause for two seconds.
pause(2);
% 20c: Just the green channel (the green color plane).
imshow(im(:,:,2))
% Then pause for two seconds.
pause(2)
% 20d: Just the blue channel (the blue color plane).
imshow(im(:,:,3))
% Then pause for three seconds.
pause(2)
%
% 20e: The inverse of the image.
imshow((im.*(-1))+1)
% calculated inverse using 1-pixel intensity
% Then pause for two seconds.
pause(2)
% 20f: Just the first channel. What color is this?
imshow(im(:,:,1))
% Then pause for two seconds.
% What color is this? ANS:Red
disp('Red')
pause(2)
% 20g: Just the second channel. What color is this?
imshow(im(:,:,2))
% Then pause for two seconds.
% What color is this? ANS:
disp('Green')
% 20h: Just the third channel.
% Then pause for three seconds.
pause(2)
imshow(im(:,:,3))
disp('Blue')
% What color is this? ANS: