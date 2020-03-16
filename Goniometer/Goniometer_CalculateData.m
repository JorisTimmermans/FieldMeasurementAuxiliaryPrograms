function [Data]  =   Goniometer_CalculateData(Data)
global j index
index               =   [];

if Data.Files.Thermal_Imager_Indicator== 3
    if Data.Files.Serial_Indicator== 3
        for j=1:size(Data.Serial.Time_Hours,1)
                I   =   (Data.Serial.Time_Hours(j)             ==  Data.Thermal.Time_Hours);
                J   =   (Data.Serial.Time_Minutes(j)           ==  Data.Thermal.Time_Minutes);
                K   =   (round(Data.Serial.Time_Seconds(j))    ==  round(Data.Thermal.Time_Seconds));
                M   =   I&J&K;
                index                       =   [index;find(M,1)];
        end        
        pause(0.1)
    elseif Data.Files.Serial_Indicator~= 3
        question    =   questdlg(['Serial file is missing, Do you want to input Time-markers manually?'],'Time-Markers','Yes','No','Yes');    
        pause(0.1)
        switch question
            case 'Yes',                     
                h = waitbar(0,'Calculating the Final data...');
                hh=figure('KeyPressFcn',@printfig);
                for j=1:size(Data.Thermal.Raw_Data,3)
                    waitbar(j/size(Data.Serial.Time.Hours,1),h);
                    refresh(hh)
                    image(Data.Thermal.Raw_Data(1:end-7,1:end-7,j))
                    drawnow
                    pause(0.1)
                end
                pause(0.5)
                close(hh)
                close(h)
            case 'No'
                %ok
        end          
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data Sorted op break points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Data.Thermal.Time_Sorted                =  [Data.Thermal.Time_Hours(index)     ,...
                                                Data.Thermal.Time_Minutes(index)   ,...
                                                Data.Thermal.Time_Seconds(index)];
    data                                    =   Data.Thermal.Raw_Data(:,:,index);

    question    =   questdlg('Do you want to check the time markers?','Checking','Yes','No','Yes');
    switch question
        case 'Yes'            
           for j=1:size(Data.Thermal.Raw_Data,3)
               image(Data.Thermal.Raw_Data(1:end-7,1:end-7,j))                
               colormap(hsv)
               drawnow               
               if any(j==index)
                   image(zeros(size(Data.Thermal.Raw_Data(1:end-7,1:end-7,j))))
                   drawnow
                   pause(0.01)
               end
           end
        case 'No'
     end
    %stretch 
    l_central_line                          =   1;                                          %m
    
%     if Data.Files.Scanroute_Indicator==3
%         phi_rad                             =   Data.Scanroute.Coordinates(:,5);
%         alpha_rad                           =   pi/2-phi_rad;
%         for j=1:length(alpha_rad)
%             [X,Y]                           =   Calculate_Stretch(alpha_rad(j),0);
%             Data.Thermal.Stretch_X(:,:,j)   =   X;
%             Data.Thermal.Stretch_Y(:,:,j)   =   Y;
%         end
%     else
%         n_pixels                            =   16;
%         [Data.Thermal.Stretch_X,...
%          Data.Thermal.Stretch_Y]            =   meshgrid(1:n_pixels,1:n_pixels);
%     end
%hoe schever de angle, hoe meer oppervlakte je ziet. 
%omdat je field of interest gelijk blijft maar je steeds meer oppervlakte ziet
%hoe schever de angle, hoe minder je field of interest is verspreid over je pixels, dus
%hoe schever de angle, hoe minder gedetailleerd je ziet
%kortom.. de field of interest wordt ingesloten door 2 uiterste hoeken voorbij welke je
%het object niet meer ziet
% 
%     l_object                        =   5;
%     gamma_break_off1                =   alpha-atan((sin(alpha)*l_central_line - l_object/2)/...
%                                               (cos(alpha)*l_central_line            )) ;     %correct for direction of the angle
%     gamma_break_off2                =   alpha-atan((sin(alpha)*l_central_line + l_object/2)/...
%                                               (cos(alpha)*l_central_line            ));     %correct for direction of the angle
% 
%     gamma1_cutoff                   =   gamma1_x_rad<gamma_break_off1 & gamma1_x_rad>gamma_break_off2;   
%     gamma2_cutoff                   =   gamma2_x_rad<gamma_break_off1 & gamma2_x_rad>gamma_break_off2;
%     deltax                          =   deltax.*(gamma1_cutoff & gamma2_cutoff);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data Interpolation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Data.Thermal.Interpolated       =   zeros(8*size(data,1),...
                                              8*size(data,2),...
                                                size(data,3));
    [x,y]                           =   meshgrid(1:8:128,1:8:128);
    [X,Y]                           =   meshgrid(1:1:128,1:1:128);
    h = waitbar(0,'Interpolating thermal imagery...');
    for j=1:size(data,3)
        Data.Thermal.Interpolated(:,:,j)   =   interp2(x,y,data(:,:,j),X,Y);
        waitbar(j/size(data,3),h)    
    end
    close(h)
end

%function for capturing the frames which should be taken
function printfig(src,evnt)
    global j index
    index = [index;j]

%function for stretching of the captured surface
% function [X,Y] = Calculate_Stretch(alpha_rad_x,alpha_rad_y)
%     l_central_line                  =   1;
%     fov_deg_x                       =   20;
%     fov_deg_y                       =   20;
%     n_pixels                        =   16;
%     fov_pixel_range_x_deg           =   linspace(+fov_deg_x/2,-fov_deg_x/2,n_pixels);
%     fov_pixel_range_y_deg           =   linspace(-fov_deg_y/2,+fov_deg_y/2,n_pixels);
%     gamma_x_rad                     =   fov_pixel_range_x_deg/180*pi;
%     gamma_y_rad                     =   fov_pixel_range_y_deg/180*pi;
%     xc                              =   l_central_line*(tan(alpha_rad_x-gamma_x_rad))*cos(alpha_rad_x);
%     yc                              =   l_central_line*(tan(alpha_rad_y-gamma_y_rad))*cos(alpha_rad_y);
%     [X,Y]                           =   meshgrid(xc,yc);
%     if abs(alpha_rad_x)==pi/2
%        X                            =   X*0;           
%     elseif any(alpha_rad_x-gamma_x_rad<-pi/2) | any(alpha_rad_x-gamma_x_rad>pi/2)
%         index                       =   alpha_rad_x-gamma_x_rad<-pi/2 | alpha_rad_x-gamma_x_rad>pi/2;
%         X(:,index)                  =   NaN;
%     end
%     if abs(alpha_rad_y)==pi/2
%        Y                            =   Y*0;
%     elseif any(alpha_rad_y-gamma_y_rad<-pi/2) | any(alpha_rad_y-gamma_y_rad>pi/2)
%         index                       =   alpha_rad_y-gamma_y_rad<-pi/2 | alpha_rad_y-gamma_y_rad>pi/2;
%         Y(index,:)                  =   NaN;
%     end