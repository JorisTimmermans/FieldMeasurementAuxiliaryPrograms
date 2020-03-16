% function Routeplanner2
clear all
close all
fclose all
clc
Error=0;
%start parameters

theta0_sensor               =   pi;                                     %beginangle of train
phi0                        =   0;                                      %beginangle of rod
theta0                      =   theta0_sensor-1/2*pi;                     %beginangle of train
x0_train                    =   0;                                      %beginposition of train
y0_train                    =   1;                                      %beginposition of train
x0_sensor                   =   -1;                                     %beginposition of sensor
y0_sensor                   =   0;                                      %beginposition of sensor
z0_sensor                   =   0;                                      %beginposition of sensor
z0_train                    =   0;                                      %beginposition of sensor
N                           =   21;

gap                         =   160;                        %gap in rails in degrees
gap_radians                 =   gap/180*pi;                 %gap in rails in radians
rails_radians               =   2*pi-gap_radians;           %rails-length in radians
rails_steps                 =   10952;                      %number of steps to cover the complete rails
gap_steps                   =   gap_radians/rails_radians*rails_steps;  %virtual steps
rod_radians                 =   pi;                         %rod-length in radiance
rod_steps                   =   30251;                      %number of steps to cover the complete circle
rails_gap_steps             =   rails_steps + gap_steps;    %total amount of steps virtual

%gap coordinates for plotting
thetagap    =   linspace(-pi,-pi+gap_radians,20);
x_gap_sensor=   cos(thetagap);
y_gap_sensor=   sin(thetagap);
z_gap_sensor=   zeros(size(x_gap_sensor));
x_gap_train =   cos(thetagap-pi/2);
y_gap_train =   sin(thetagap-pi/2);
z_gap_train =   zeros(size(x_gap_sensor));

close all       
    question    =   questdlg('Do you want to specify the measuring-points by hand?','Manual','Yes','No','Yes');    
    switch question
        case 'Yes',
            choice  =   1;
        case 'No',
            choice  =   2;
    end
if choice == 2
    question    =   questdlg('Do you want the points evenly spaced?','Spacing','Yes','No','Yes');
    switch question
        case 'Yes'
            choice2 = 1;
        case 'No'
            choice2 = 2;
    end
    prompt={'How many points in the horizontal direction?  : ', ...
            'How many points in the vertical direction? : '};
    name='Automatic input for scanning Points';
    numlines=1;
    defaultanswer={'4','3'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        Error   =   1;
        choice3 =   2;
        choice4 =   2;
    else        
        choice3 =  str2num(mat2str(cell2mat(answer(1))));
        choice4 = str2num(mat2str(cell2mat(answer(2))));
        uiwait(msgbox(['The total number of points will be approximately ~ ',num2str(choice3*choice4+1)],'Total measurement points','modal'));
    end
    if choice2 == 1
        theta_sensor    =   linspace(0,2*pi*(1-1/choice3),choice3)';
        theta_sensor    =   theta_sensor - 2*pi*fix(theta_sensor/pi);
        if choice4==1,
            phi         =   pi/4;
        else
            phi         =   linspace(0,pi/2*(1-1/choice4),choice4)';            
        end        
    else
        theta_sensor=   pi - 2*pi * rand(choice3,1);
        phi         =        pi/2 * rand(choice4,1);
        phi         =   [phi ; pi/2];
    end
        theta_sensor=   [reshape(theta_sensor(:,ones(1,choice4)) ,1,choice3*choice4)'];
        phi         =   [reshape(phi(:,ones(1,choice3))',1,choice3*choice4)'];
        theta_sensor=   [theta_sensor ; 0];                    %top of the iceberg captain
        phi         =   [phi          ; pi/2];                 %top of the iceberg captain
        
        x_sensor    =   cos(theta_sensor).*cos(phi);
        y_sensor    =   sin(theta_sensor).*cos(phi);
        z_sensor    =   sin(phi);
else
        figure(1)
        string      = {'Input the coordinates by pressing the mouse button'     ;   ...
                       'in the points you want to scan'                         ;   ...
                       'Press Enter if you are done inputting the coordinates'} ;  
        title(string);
        hold on
        plot(x0_train,y0_train,'blacko',1.05*x_gap_sensor,1.05*y_gap_sensor,'magenta',1.025*x_gap_train,1.025*y_gap_train,'yellow')
        legend('start','sensor track gap', 'train track gap','Location','BestOutside' )
        legend BOXOFF
        rectangle('Curvature',[1 1],'Position',[-1 -1 2 2]);
        line([0 0],[-1.05 1.05],'Linestyle','--','Color','black');
        line([-1.05 1.05],[0 0],'Linestyle','--','Color','black');
        axis([-1.05 1.05 -1.05 1.05]);
        set(gcf, 'MenuBar','none')
        drawnow
        axis off
        axis equal
        [x_sensor,y_sensor]       =   ginput;
%         close(1)

        radius      =   sqrt(x_sensor.^2 + y_sensor.^2);
        max_radius  =   ones(size(radius));        
        radius      =   min(radius,max_radius);
        theta_sensor=   angle(x_sensor+i*y_sensor);         %theta goes from -pi to pi
        z_sensor    =   sqrt(1-radius.^2);
        phi         =   atan(z_sensor./radius);             
        x_sensor    =   cos(theta_sensor).*cos(phi);        % make sure x and y have a radius of 1       
        y_sensor    =   sin(theta_sensor).*cos(phi);          % make sure x and y have a radius of 1
end     
    prompt={'How much offset (degrees) in your horizontal plane?  : '};
    name='Offset input for scanning Points';
    numlines=1;
    defaultanswer={'0'};
    offset  =   str2num(cell2mat(inputdlg(prompt,name,numlines,defaultanswer)));
    theta_sensor    =   theta_sensor + offset/180*pi;


%since the rail of the goniometer is not a full 2pi, the arm has to swing around to  a position 180degrees opposite
%the original position. 
if Error==0,
    index1                              =   theta_sensor<(gap_radians-pi);
    index2                              =   theta_sensor>pi;
    theta_sensor_gap_corrected          =   theta_sensor;
    theta_sensor_gap_corrected(index1)  =   theta_sensor(index1) + pi;
    theta_sensor_gap_corrected(index2)  =   theta_sensor(index2) - pi;
    phi_gap_corrected                   =   phi;
    phi_gap_corrected(index1)           =   pi  - phi(index1);
    phi_gap_corrected(index2)           =   pi  - phi(index2);
    phi                                 =   phi_gap_corrected;
    index3                              =   double(phi>pi/2) - double(phi<=pi/2);
    theta_train_gap_corrected           =   theta_sensor_gap_corrected - pi/2;
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[theta_sorted_ii,ii]    =   sort(theta_train_gap_corrected);
phi_sorted_ii           =   phi(ii);
phi_index               =   double(phi_sorted_ii>=pi/2) - double(phi_sorted_ii<pi/2);
theta_sensor_ii         =   theta_sorted_ii - pi/2*phi_index;
x_sorted_ii             =   abs(cos(phi_sorted_ii)).*cos(theta_sensor_ii);
y_sorted_ii             =   abs(cos(phi_sorted_ii)).*sin(theta_sensor_ii);
z_sorted_ii             =   abs(sin(phi_sorted_ii));

theta_sorted_ii         =   [theta0; theta_sorted_ii;theta0 ];      %theta start at zero point 
phi_sorted_ii           =   [phi0; phi_sorted_ii;phi0];             %phi start at zero point                
x_sorted_ii             =   [x0_sensor; x_sorted_ii;x0_sensor];     %x start at zero point
y_sorted_ii             =   [y0_sensor; y_sorted_ii;y0_sensor];     %y start at zero point
z_sorted_ii             =   [z0_sensor; z_sorted_ii;z0_sensor];     %z start at zero point

[phi_sorted_jj,jj]      =   sort(phi);
phi_index               =   double(phi_sorted_jj>=pi/2) - double(phi_sorted_jj<pi/2);
theta_sorted_jj         =   theta_train_gap_corrected(jj) ;
theta_sensor_jj         =   theta_sorted_jj - pi/2*phi_index;
x_sorted_jj             =   abs(cos(phi_sorted_jj)).*cos(theta_sensor_jj);
y_sorted_jj             =   abs(cos(phi_sorted_jj)).*sin(theta_sensor_jj);
z_sorted_jj             =   abs(sin(phi_sorted_jj)); 

theta_sorted_jj         =   [theta0; theta_sorted_jj;theta0];       %theta start at zero point
phi_sorted_jj           =   [phi0; phi_sorted_jj;phi0];             %phi start at zero point
x_sorted_jj             =   [x0_sensor; x_sorted_jj;x0_sensor];     %x start at zero point
y_sorted_jj             =   [y0_sensor; y_sorted_jj;y0_sensor];     %y start at zero point
z_sorted_jj             =   [z0_sensor; z_sorted_jj;z0_sensor];     %z start at zero point
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[spherex,spherey,spherez]   =   sphere(2*(N-1));
spherec     =   ones(size(spherex));
figure(2)
set(gcf, 'MenuBar','none')
    hold on
    plot3(1.000*[x0_train        ] ,1.000*[y0_train        ] ,1.000*[z0_train        ],'o'      , ...
          1.050*[0,x_gap_sensor,0] ,1.050*[0,y_gap_sensor,0] ,1.050*[0,z_gap_sensor,0],'magenta', ...
          1.025*[0,x_gap_train,0 ] ,1.025*[0,y_gap_train,0 ] ,1.025*[0,z_gap_train,0 ],'yellow');
    legend('start','sensor track gap', 'train track gap','Location','BestOutside' )
    legend BOXOFF
    mesh(spherex(N:end,:),spherey(N:end,:),spherez(N:end,:),spherec(N:end,:));    
    colormap(0.7*ones(64,3))
    hidden
    
    plot3(x_sensor,y_sensor,z_sensor,'xblue');
    view(45,30)
    zoom(1.5)
    axis off
    axis equal
    drawnow
        
 figure(3)
 set(gcf, 'MenuBar','none')
 subplot(2,2,1)
 title('ScanRoute 2')
    hold on
    h=plot3(1.000*[x0_train        ] ,1.000*[y0_train        ] ,1.000*[z0_train        ],'o'      , ...
          1.050*[0,x_gap_sensor,0] ,1.050*[0,y_gap_sensor,0] ,1.050*[0,z_gap_sensor,0],'magenta', ...
          1.025*[0,x_gap_train,0 ] ,1.025*[0,y_gap_train,0 ] ,1.025*[0,z_gap_train,0 ],'yellow');
    mesh(spherex(N:end,:),spherey(N:end,:),spherez(N:end,:),spherec(N:end,:))
    colormap(0.7*ones(64,3))
    hidden   
    plot3(x_sorted_jj,y_sorted_jj,z_sorted_jj,'red');
    plot3(x_sorted_jj(1),y_sorted_jj(1),z_sorted_jj(1),'x')
    view(45,30)
    zoom(2)
    axis off
    axis equal
    drawnow
    
subplot(2,2,3)
    hold on
    rectangle('Curvature',[1 1],'Position',[-1 -1 2 2]);
    line([0 0],[-1.05 1.05],'Linestyle','--','Color','black');
    line([-1.05 1.05],[0 0],'Linestyle','--','Color','black');
    plot( 1.000*[x0_train        ] ,1.000*[y0_train        ],'o'      , ...
          1.050*[0,x_gap_sensor,0] ,1.050*[0,y_gap_sensor,0],'magenta', ...
          1.025*[0,x_gap_train,0 ] ,1.025*[0,y_gap_train,0 ],'yellow' );
    plot(x_sorted_jj,y_sorted_jj)
    plot(x_sorted_jj(1),y_sorted_jj(1),'x')
    axis off
    axis equal
    axis([-1.05 1.05 -1.05 1.05]);    
    title('x versus y')
    drawnow
    
subplot(2,2,4)
    hold on
    rectangle('Curvature',[1 1],'Position',[-1 -1 2 2]);
    line([0 0],[-1.05 1.05],'Linestyle','--','Color','black');
    line([-1.05 1.05],[0 0],'Linestyle','--','Color','black');
    plot(1.000*[x0_train        ] ,1.000*[z0_train        ],'o'      , ...
         1.050*[0,x_gap_sensor,0] ,1.050*[0,z_gap_sensor,0],'magenta', ...
         1.025*[0,x_gap_train,0 ] ,1.025*[0,z_gap_train,0 ],'magenta');
    plot(x_sorted_jj,z_sorted_jj)
    plot(x_sorted_jj(1),z_sorted_jj(1),'x')
    axis off; 
    axis equal; 
    axis([-1.05 1.05 0 1.05]);    
    title('x versus z')
AX = subplot(2,2,2)
    text(0,0.8,'ScanRoute 2','FontSize',13)
    text(0,0.6,'minimal movement for the arm')
    text(0,0.4,'maximal movement for the train')
    legend(AX,h,'start','sensor track gap', 'train track gap','Location','SouthOutside' );
    axis off
    drawnow
    
 figure(4)
 set(gcf, 'MenuBar','none')
 subplot(2,2,1)
    title('ScanRoute 1')
    hold on
    plot3(1.000*[x0_train        ] ,1.000*[y0_train        ] ,1.000*[z0_train        ],'o'      , ...
          1.050*[0,x_gap_sensor,0] ,1.050*[0,y_gap_sensor,0] ,1.050*[0,z_gap_sensor,0],'magenta', ...
          1.025*[0,x_gap_train,0 ] ,1.025*[0,y_gap_train,0 ] ,1.025*[0,z_gap_train,0 ],'yellow');
    mesh(spherex(N:end,:),spherey(N:end,:),spherez(N:end,:),spherec(N:end,:))
    colormap(0.7*ones(64,3))
    hidden
   
    plot3(x_sorted_ii,y_sorted_ii,z_sorted_ii,'red');
    plot3(x_sorted_ii(1),y_sorted_ii(1),z_sorted_ii(1),'x')
    view(45,30)
    zoom(2)
    axis off
    axis equal
    drawnow
    
subplot(2,2,3)
    hold on
    rectangle('Curvature',[1 1],'Position',[-1 -1 2 2]);
    line([0 0],[-1.05 1.05],'Linestyle','--','Color','black');
    line([-1.05 1.05],[0 0],'Linestyle','--','Color','black');
    plot(1.000*[x0_train        ] ,1.000*[y0_train        ],'o'      , ...
         1.050*[0,x_gap_sensor,0] ,1.050*[0,y_gap_sensor,0],'magenta', ...
         1.025*[0,x_gap_train,0 ] ,1.025*[0,y_gap_train,0 ],'yellow');
    plot(x_sorted_ii,y_sorted_ii)
    plot(x_sorted_ii(1),y_sorted_ii(1),'x')
    axis off
    axis equal
    axis([-1.05 1.05 -1.05 1.05]);
    title('x versus y')
    drawnow
    
subplot(2,2,4)
    hold on
    rectangle('Curvature',[1 1],'Position',[-1 -1 2 2]);
    line([0 0],[-1.05 1.05],'Linestyle','--','Color','black');
    line([-1.05 1.05],[0 0],'Linestyle','--','Color','black');
    plot(1.000*[x0_train        ] ,1.000*[z0_train        ],'o'      , ...
         1.050*[0,x_gap_sensor,0] ,1.050*[0,z_gap_sensor,0],'magenta', ...
         1.025*[0,x_gap_train,0 ] ,1.025*[0,z_gap_train,0 ],'yellow');
    plot(x_sorted_ii,z_sorted_ii)
    plot(x_sorted_ii(1),z_sorted_ii(1),'x')
    axis off; 
    axis equal; 
    axis([-1.05 1.05 0 1.05]);
    title('x versus z')
    drawnow
    
AX=subplot(2,2,2);
    text(0,0.8,'ScanRoute 1','FontSize',13);
    text(0,0.6,'maximal movement for the arm')
    text(0,0.4,'minimal movement for the train')
    legend(AX,h,'start','sensor track gap', 'train track gap','Location','SouthOutside' );
    axis off
    drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theta_steps_sorted_ii       =   theta_sorted_ii(2:end)-theta_sorted_ii(1:end-1);    %theta angular steps radians
theta_steps_sorted_jj       =   theta_sorted_jj(2:end)-theta_sorted_jj(1:end-1);    %theta angular steps radians

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%position is ok, but for the steps, the movement of the train can offcouse
%not go through the gap!!!
sum_ii = 0;
sum_jj = 0;
for j=1: size(theta_steps_sorted_ii)
    sum_iii =   sum_ii + theta_steps_sorted_ii (j);
    sum_jjj =   sum_jj + theta_steps_sorted_jj (j);
    if sum_iii > 0
        theta_steps_sorted_ii(j) =  theta_steps_sorted_ii(j)-2*pi;
    elseif sum_iii < gap_radians - 2*pi
        theta_steps_sorted_ii(j) =  2*pi + theta_steps_sorted_ii(j);
    end    
    if sum_jjj > 0
        theta_steps_sorted_jj(j) =  theta_steps_sorted_jj(j)-2*pi;
    elseif sum_jjj < gap_radians - 2*pi
        theta_steps_sorted_jj(j) =  2*pi + theta_steps_sorted_jj(j);
    end    
    sum_jj =   sum_jj + theta_steps_sorted_jj (j);
    sum_ii =   sum_ii + theta_steps_sorted_ii (j);    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi_steps_sorted_ii         =   phi_sorted_ii(2:end)-phi_sorted_ii(1:end-1);        %phi angular steps radians
phi_steps_sorted_jj         =   phi_sorted_jj(2:end)-phi_sorted_jj(1:end-1);        %phi angular steps radians
direction_theta_sorted_ii   =   theta_steps_sorted_ii<0;                            %conversion to 1bit direction
direction_theta_sorted_jj   =   theta_steps_sorted_jj<0;                            %conversion to 1bit direction
direction_phi_sorted_ii     =   phi_steps_sorted_ii>0;                              %conversion to 1bit direction
direction_phi_sorted_jj     =   phi_steps_sorted_jj>0;                              %conversion to 1bit direction

theta_steps_sorted_ii       =   abs(theta_steps_sorted_ii/rails_radians*rails_steps);  %conversion to motor steps
theta_steps_sorted_jj       =   abs(theta_steps_sorted_jj/rails_radians*rails_steps);  %conversion to motor steps
phi_steps_sorted_ii         =   abs(phi_steps_sorted_ii/rod_radians*rod_steps);        %conversion to motor steps
phi_steps_sorted_jj         =   abs(phi_steps_sorted_jj/rod_radians*rod_steps);        %conversion to motor steps

%for the implementation in to the control box, the steps should have 6 digits, example: 001000, 
theta_ii_string             =   num2str(int16(theta_steps_sorted_ii));              %convert to strings
theta_jj_string             =   num2str(int16(theta_steps_sorted_jj));              
phi_ii_string               =   num2str(int16(phi_steps_sorted_ii));                
phi_jj_string               =   num2str(int16(phi_steps_sorted_jj));                

theta_ii_string(find(theta_ii_string==' ')) = '0';  %every row should have amount of digits
theta_jj_string(find(theta_jj_string==' ')) = '0';
phi_ii_string(find(phi_ii_string==' '))     = '0';
phi_jj_string(find(phi_jj_string==' '))     = '0';             

b1=[];for j=1:(6-size(theta_ii_string,2)), b1=[b1,'0'];end
b2=[];for j=1:(6-size(theta_jj_string,2)), b2=[b2,'0'];end
b3=[];for j=1:(6-size(phi_ii_string,2)), b3=[b3,'0'];end
b4=[];for j=1:(6-size(phi_jj_string,2)), b4=[b4,'0'];end

b11=[];b22=[];b33=[];b44=[];
for j=1:size(theta_ii_string,1)
    b11=[b11;b1];
    b22=[b22;b2];
    b33=[b33;b3];
    b44=[b44;b4];
end
theta_ii_string    =   [b11,theta_ii_string];
theta_jj_string    =   [b22,theta_jj_string];
phi_ii_string      =   [b33,phi_ii_string];
phi_jj_string      =   [b44,phi_jj_string];
homedir =   cd;
cd 'C:\'
[temp, pathname, filter] = uiputfile('*.xcf', 'Save As', 'Scan');
cd(pathname)
 fid         =   fopen('Scan.xcf','w');
 fprintf(fid,'3 \r\n');
 fprintf(fid,'"Initializing.txt\"\r\n');
 fprintf(fid,'"Scanroute1.txt"\r\n');
 fprintf(fid,'"Scanroute2.txt"\r\n');
 fclose(fid);

 fid =   fopen('Initializing.txt','w');
 fprintf(fid,'JJ 00 01 02 03 04 05 06 07');
 fclose(fid);

 fid     =   fopen('Scanroute1.txt','w');
 fprintf(fid,'GZ\r\n');                 %ensures that the starting point theta is at begin point
 fprintf(fid,'GC\r\n');                 %ensures that the starting point phi is at begin point
 fprintf(fid,'SO\r\n');                 %ensures that the starting point theta is begin point
 fprintf(fid,'SN\r\n');                 %ensures that the starting point phi is begin point
 fprintf(fid,'WT 01\r\n');
 fprintf(fid,'GI 0100 4000 003000 20 1\r\n');%warm up the motor for phi movement 
 fprintf(fid,'WT 01\r\n');                 %get ready for measuring.....
 fprintf(fid,'GI 0100 4000 003000 20 0\r\n');%warm up the motor for phi movement
 fprintf(fid,'WK\r\n');              %Lets Go
 fprintf(fid,'CC\r\n');                 %call OK for start of measurements
 for j=1:size(theta_ii_string,1),     
     fprintf(fid,'CC\r\n');             %call OK to com port for time index
     fprintf(fid,'WK\r\n');          %after each movement, wait 5 seconds to do measurement
%      fprintf(fid,'WT 05\r\n');          %after each movement, wait 5 seconds to do measurement
     
     if str2num(theta_ii_string(j,:))<2*(400/08) & str2num(theta_ii_string(j,:))>0;
         fprintf(fid,'GV 0050 %s %d\r\n', theta_ii_string(j,:), direction_theta_sorted_ii(j));       
     elseif str2num(theta_ii_string(j,:))>2*(400/08)
        fprintf(fid,'GQ 0100 0500 %s 08 %d\r\n', theta_ii_string(j,:), direction_theta_sorted_ii(j));       
     end
     
     if str2num(phi_ii_string(j,:))<2*(3900/20) & str2num(phi_ii_string(j,:))>0;    %value to be determined!!!!
         fprintf(fid,'GA 0050 %s %d\r\n', phi_ii_string(j,:), direction_phi_sorted_ii(j));
     elseif str2num(phi_ii_string(j,:))>2*(3900/20)
        fprintf(fid,'GI 0100 4000 %s 20 %d\r\n', phi_ii_string(j,:)  , direction_phi_sorted_ii(j)); 
     end
 end
 
 fprintf(fid,'WT 05\r\n');              %wait for 5 seconds before motor shut down, to ensure stable rod!!!
 fprintf(fid,'CC\r\n');                 %call OK to com port for time index
 fprintf(fid,'CC\r\n');                 %call OK to com port for time index 
 fprintf(fid,'F\r\n');                  %power down motors
 fclose(fid);

 fid     =   fopen('Scanroute2.txt','w');
 fprintf(fid,'GZ\r\n');                 %ensures that the starting point theta is at begin point
 fprintf(fid,'GC\r\n');                 %ensures that the starting point phi is at begin point
 fprintf(fid,'SO\r\n');                 %ensures that the starting point theta is begin point
 fprintf(fid,'SN\r\n');                 %ensures that the starting point phi is begin point
 fprintf(fid,'WT 01\r\n');
 fprintf(fid,'GI 0100 4000 003000 20 1\r\n');%warm up the motor for phi movement 
 fprintf(fid,'WT 01\r\n');   
 fprintf(fid,'GI 0100 4000 003000 20 0\r\n');%warm up the motor for phi movement
 fprintf(fid,'WK\r\n');                 %Lets Go
 fprintf(fid,'CC\r\n');                 %call OK for start of measurements
 for j=1:size(theta_jj_string,1),
     fprintf(fid,'CC\r\n');             %call OK to com port for time index
     fprintf(fid,'WK\r\n');          %after each movement, wait 5 seconds to do measurement
%      fprintf(fid,'WT 05\r\n');          %after each movement, wait 5 seconds to do measurement
     
     if str2num(theta_jj_string(j,:))<2*(400/08) & str2num(theta_jj_string(j,:))>0;
         fprintf(fid,'GV 0050 %s %d\r\n', theta_jj_string(j,:), direction_theta_sorted_jj(j));       
     elseif str2num(theta_jj_string(j,:))>2*(400/08)
        fprintf(fid,'GQ 0100 0500 %s 08 %d\r\n', theta_jj_string(j,:), direction_theta_sorted_jj(j));       
     end
     
     if str2num(phi_jj_string(j,:))<2*(3900/20) & str2num(phi_jj_string(j,:))>0;    %value to be determined!!!!
         fprintf(fid,'GA 0050 %s %d\r\n', phi_jj_string(j,:), direction_phi_sorted_jj(j));     
     elseif str2num(phi_jj_string(j,:))>2*(3900/20)
        fprintf(fid,'GI 0100 4000 %s 20 %d\r\n', phi_jj_string(j,:)  , direction_phi_sorted_jj(j));        
     end
 end
 fprintf(fid,'WT 05\r\n');              %wait for 5 seconds before motor shut down, to ensure stable rod!!!
 fprintf(fid,'CC\r\n');                 %call OK to com port for time index
 fprintf(fid,'CC\r\n');                 %call OK to com port for time index
 
 fprintf(fid,'F\r\n');                  %power down motors
 fclose(fid);
fid     =   fopen('Coordinates_Scanroute1.log','w');
fprintf(fid,[' x_sensor        ',' y_sensor       ',' z_sensor        ','theta_train     ', 'phi_train']);
fprintf(fid,'\r\n%15e %15e %15e %15e %15e',[x_sorted_ii, y_sorted_ii, z_sorted_ii, theta_sorted_ii, phi_sorted_ii]' );
fclose(fid);

fid     =   fopen('Coordinates_Scanroute2.log','w');
fprintf(fid,[' x_sensor        ',' y_sensor       ',' z_sensor        ','theta_train     ', 'phi_train']);
fprintf(fid,'\r\n%15e %15e %15e %15e %15e',[x_sorted_jj, y_sorted_jj, z_sorted_jj, theta_sorted_jj, phi_sorted_jj]' );
fclose(fid);
question    =   questdlg('Do you want to look at the SMC-control-programs?','Manual','Yes','No','No');    
    switch question
        case 'Yes',
            open Scanroute1.txt
            open Scanroute2.txt
        case 'No',
            uiwait(msgbox('Exiting?','Exiting','modal'));
    end
    cd ..
end
cd(homedir)
close all
