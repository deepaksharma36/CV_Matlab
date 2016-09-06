function HW08_Sharma_Deepak_MAIN(filename)

close all;
%adding path of directory for exporing images
addpath( '../TEST_IMAGES' );
%filename='HW08_9.jpg';
% reading input file
im=imread(filename);
im_original =im;
%taking red channel of the Image
im=im(:,:,1);
%applying sobel edge detector on the image
[mag,edge_angle]=Sobel(im);
%converting Edge anges to Degrees
edge_angle=edge_angle*(180/pi);

%keeping only top 20% magnitured
mag=preProcessing_mag(mag);
mag_org=mag;

vote_accumulator=zeros(size(mag));
ANGLE_TOLERANCE=20;
%counter for subplot images
counter=1;
%permorming voting algorithm for Interveled angles
angles      =  -135 : ANGLE_TOLERANCE : 150 ;  
    for angle = angles
        if mod(counter-1,4)==0
            figure('Name','intermidiate cumulative voting Result, Highligiting individual angle votes','Position',[0 0 1024 612]);
            counter=1;
        end
        
        %keeping only edges for angle range in 'Angle'+-tolerance
        mag_at_angle=preProcessing_angle(mag,edge_angle,angle);
        %subplot(2,2,counter);
        %imagesc(mag_at_angle)
        %counter=counter+1;
        %calculating hough transform of the image
        [H,theta,rho] = hough(mag_at_angle);
        %subplot(2,2,counter);
        %imagesc(H)
        %counter=counter+1;
        %str=strcat(int2str(angle),' Hough TransForm');
        %title(str, 'FontSize', 10 );
        %taking top 5(peaks) combinations of row and theta for which
        %maximum value recored 
        peaks = houghpeaks(H,5, 'threshold',ceil(0.3*max(H(:))));
        %Identifying lines for row and theta combination received from
        %houghpeaks
        lines = houghlines(mag_at_angle,theta,rho,peaks,'FillGap',35,'MinLength',20);
        subplot(2,2,counter);
        
        imagesc(vote_accumulator), hold on;
        str=strcat(int2str(angle),' Hough Lines(GREEN)Line Equation(RED)');
        title(str, 'FontSize', 10 );
        counter=counter+1;
        %updating cumulative voting accumulator after counting the vote for current angle 
        vote_accumulator=registerVOTES(lines,mag_at_angle,vote_accumulator);
        %subplot(2,2,counter)
        %counter=counter+1;
    end

figure('Name','Results','Position',[10 10 1312 612])    
%subplot(1,3,1)
%applying disk filter on acculated votes for overcome aliasing effect
gaussian=fspecial('disk',30);
vote_accumulator=imfilter(vote_accumulator,gaussian);
subplot(1,2,1)
imagesc(vote_accumulator), hold on;
%finding max count of vote
max_vote=max(max(vote_accumulator));
%finding location of maximum votes

[col,row]=find(vote_accumulator==max_vote);
%drawing vanishing point on image
    plot( row, col, 'mo', 'MarkerSize', 24, 'LineWidth', 2 );
    plot( row, col, 'm+', 'MarkerSize', 30, 'LineWidth', 2 );
    plot( row, col, 'gx', 'MarkerSize', 28, 'LineWidth', 2 );

subplot(1,2,2);    
imagesc(im_original),hold on;
    plot( row, col, 'mo', 'MarkerSize', 24, 'LineWidth', 2 );
    plot( row, col, 'm+', 'MarkerSize', 30, 'LineWidth', 2 );
    plot( row, col, 'gx', 'MarkerSize', 28, 'LineWidth', 2 );
%saving output as image
output=strcat(filename,'_output.fig') ;   
savefig(output);
outputJPG=strcat(filename,'_output.jpg') ;   
outputfig=openfig(output,'new','invisible');
saveas(outputfig,outputJPG,'jpg')
close(outputfig);
end

function vote_accumulator= registerVOTES(lines,mag,vote_accumulator)
    
    imagesc(vote_accumulator),hold on;
    %registring votes of each line one by one
    for counter = 1:length(lines)
       %extracting starting and end point of the line
       point = [lines(counter).point1; lines(counter).point2];
       %caculating equation of the line
       [m,c]=line_equation(point);
       %calculating length of the line received from hough transform
       line_length=ceil( CalcDistance(point(1,:),point(2,:))*10);
       for row=1:size(mag,1)
           for col=1:size(mag,2)
                if abs(row-m*col-c) <1.5
                    %updating votes of each coordinate based on distance
                    %form line
                    vote_accumulator(row,col)=vote_accumulator(row,col)+line_length;
                end
           end
       end
       %skeching the equation of line on the hough line
       plot(point(:,1),point(:,2),'LineWidth',5,'Color','green'), hold on;
       x=1:size(mag,2);
       y=m*x+c;
       plot(x,y,'LineWidth',2,'Color','red'),hold on;
    end
end
function dis= CalcDistance(p1,p2)
    %this function calculate distance between two points.
    dis=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
end
function [m,c]=line_equation(point)

firstPoint=point(1,:);
secondPoint=point(2,:);

m=(firstPoint(2)-secondPoint(2))/(firstPoint(1)-secondPoint(1));
c=firstPoint(2)- m*firstPoint(1);
end

function mag = preProcessing_mag(mag)
%this function remote magnitude which dont fall in top 20%
mag_col=mag(:);
%shorted the magnitude col vector
mag_col_sorted=sort(mag_col);
%find the index of top 5 for generating threshold
top_value_index=round(size(mag_col_sorted,1)*.2);
thrshold=mag_col_sorted(size(mag_col_sorted,1)-top_value_index);
%remoted the magnitudes below the threshold
for counter=1:size(mag_col,1)
    if mag_col(counter)<thrshold
        mag_col(counter)=0;
    end
end
%converted col vector to image
mag=reshape(mag_col,size(mag));
end
function mag_angle = preProcessing_angle(mag,edge_angle,engles)
    %this method set all the magnitude to 0 if the coresponding angle dont
    %fell in +- 20 Degree angle
    new_mag=zeros(size(mag));
    for row=1:size(edge_angle,1)
        for col=1:size(edge_angle,2)
            if (edge_angle(row,col)>=engles-20) && (edge_angle(row,col)<=engles+20)
                new_mag(row,col)=mag(row,col);
            end 

        end
    end

mag_angle=new_mag;


end

function [imgEdge,edgeAngle]=Sobel(img)
    %calculate direction and magnitude of the input image
    img=im2double(img);
    sobelX= [1 2 1;
             0 0 0;
            -1 -2 -1];
    sobelY= [1 0 -1;
             2 0 -2;
             1 0 -1];
     
    imgEdgeX=imfilter(img,sobelX,'same');
    imgEdgeY=imfilter(img,sobelY,'same');
    imgEdge = (imgEdgeX.^2+imgEdgeY.^2).^(1/2);
    edgeAngle=atan(imgEdgeY./imgEdgeX);
end