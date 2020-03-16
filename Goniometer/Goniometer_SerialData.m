function [Data]=Goniometer_SerialData(Data)
Data.Files.Serial_File    =   dir('*Serial*');
try
    if all(Data.Files.Serial_File.name(end-2:end)=='dat'| ...
           Data.Files.Serial_File.name(end-2:end)=='DAT')
        Data.Files.Serial_Indicator     =   fopen(Data.Files.Serial_File.name);
        Data.Serial.Raw_Data            =   char(fread(Data.Files.Serial_Indicator));
        fclose(Data.Files.Serial_Indicator);

        header                          =   Data.Serial.Raw_Data(2113:end);             % Header check every time!!
        delimited                       =   strread(header,'%s','delimiter','|;>');
        raw_delimited                   =   delimited(2:end);                           % data to be used check every time!!
        time_date                       =   cell2mat(raw_delimited(1:4:end));
        Data.Serial.Date                =   time_date(:,1:9);
        Data.Serial.Time_Unsorted       =   time_date(:,11:end);
        id                              =   raw_delimited(2:4:end);
        code_serial                     =   raw_delimited(3:4:end);

        Temp                            =   [];
        for j=1:size(code_serial,1)
            Temp=[Temp; cell2mat(strread(cell2mat(code_serial(j)),'%s','delimiter',' '))];    
        end
        Temp1                           =   [Temp(1:3:end,:), ...
                                             Temp(2:3:end,:), ...
                                             Temp(3:3:end,:)];
                                         
        Temp2                           =   ([Temp1(1,:)         ,Temp1(2,:)                          ;...
                                              Temp1(3:end-2,:)    ,char(32*ones(size(Temp1,1)-4,6))   ;...
                                              Temp1(end-1,:)      ,Temp1(end,:)]);
        Data.Serial.Code_Sorted         =   cell(size(Temp2,1),1);

        h   =   waitbar(0,'Computing Datacode...'); 
        for j=1:size(Temp2,1)
            Data.Serial.Code_Sorted(j)  =   {Temp2(j,:)};
            waitbar(j/length(Temp2),h);
        end
        pause(0.1)
        close(h);   

        
        Data.Serial.Time_Sorted         =   Data.Serial.Time_Unsorted(4:3:end-3,:);
        time                            =   datenum(Data.Serial.Time_Unsorted,'HH:MM:SS');
        [temp1,ordering]                =   unique(time);
        Data.Serial.Time_Sorted         =   Data.Serial.Time_Unsorted(ordering,:);
        Data.Serial.Time_Start_Time     =   Data.Serial.Time_Sorted(1,:);
        Data.Serial.Time_Start_Day      =   Data.Serial.Date(1,:);       

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Time index%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Data.Serial.Time_Hours          =   str2num(Data.Serial.Time_Sorted(:,[1,2]));
        Data.Serial.Time_Minutes        =   str2num(Data.Serial.Time_Sorted(:,[4,5]));
        Data.Serial.Time_Seconds        =   str2num(Data.Serial.Time_Sorted(:,[7,8]));
    else
        Data.Files.Serial_Indicator     =   fopen(Data.Files.Serial_File.name);               
        Text= cell(1);
        index   =   1;
        while ~feof(Data.Files.Serial_Indicator)
            text = fgetl(Data.Files.Serial_Indicator);
            Text(index,1)               =   {text(1:6)};
            Text(index,2)               =   {text(8:15)};
            Text(index,3)               =   {text(22:38)};
            Text(index,4)               =   {text(70:end)};
            index                       =   index + 1;
        end
        fclose(Data.Files.Serial_Indicator);
        Data.Serial.Time_Sorted         =   cell2mat(Text(:,2));
        Data.Serial.Code_Sorted         =   Text(:,3);
        Data.Serial.Time_Start_Time     =   Data.Serial.Time_Sorted(1,:);
        Data.Serial.Time_Start_Day      =   cell2mat(inputdlg('Date is missing, please insert the date ',...
                                                              'Date',1,{'16-7-2005'}));
        Data.Serial.Time_Hours          =   str2num(Data.Serial.Time_Sorted(:,[1,2]));
        Data.Serial.Time_Minutes        =   str2num(Data.Serial.Time_Sorted(:,[4,5]));
        Data.Serial.Time_Seconds        =   str2num(Data.Serial.Time_Sorted(:,[7,8]));                                                          
    end
    %         Data.Solar                    
        temp1                           =   datenum(Data.Serial.Time_Start_Day,'dd-mm-yyyy');
        temp2                           =   datenum(['01-01',Data.Serial.Time_Start_Day(5:end)],'dd-mm-yyyy');
        dn                              =   temp1-temp2+1;
        da_rad                          =   (dn-1)*2*pi/365;        
        delta_rad                       =   23.45*sin(360/365*(dn + 284))/180*pi;
        
        delta_degrees                   =   (6.918e-3    -   3.99912e-1*cos(da_rad)  +  7.0257e-2*sin(da_rad)   -...
                                                             6.75800e-3*cos(2*da_rad)+  9.0700e-4*sin(2*da_rad) -...
                                                             2.69700e-3*cos(3*da_rad)+  1.4800e-3*sin(3*da_rad))*...
                                                             180/pi;
        delta_rad                       =   delta_degrees/180*pi;

        Et_rad                          =   7.5e-5 + (1.8680e-3)*cos(da_rad)   - (3.2077e-2)*sin(da_rad)- ...
                                                     (1.4615e-2)*cos(2*da_rad) - (4.0890e-2)*sin(2*da_rad);
        Et_minutes                      =   Et_rad*24*60/(2*pi);
        if Data.Files.Position_Indicator==3
            Lc_degrees                  =   str2num(Data.Position.Coordinates_Lon(1:2)) + ...
                                            str2num(Data.Position.Coordinates_Lon(4:5))/60;
            Lt_degrees                  =   str2num(Data.Position.Coordinates_Lat(1:2)) + ...
                                            str2num(Data.Position.Coordinates_Lat(4:5))/60;
        else
            Lc_degrees                  =   02.1;
            Lt_degrees                  =   39.05;
        end
                
        Lstand_degrees                  =   15*ceil(Lc_degrees/15);
        Lcor_minutes                    =   4*(Lstand_degrees -Lc_degrees);

        Lst_hours                       =   str2num(Data.Serial.Time_Start_Time(1:2))       + ...
                                            str2num(Data.Serial.Time_Start_Time(4:5))/60    + ...
                                            str2num(Data.Serial.Time_Start_Time(7:8))/360;
        
        Lat_hours                       =   Lst_hours - Lcor_minutes/60 + Et_minutes/60;     
        omega_rad                       =   15*(Lat_hours-12)*pi/180;
        phi_rad                         =   Lt_degrees/180*pi;
        zenith_rad                      =   acos(sin(phi_rad)*sin(delta_rad) +...
                                                 cos(phi_rad)*cos(delta_rad)*cos(omega_rad));        
        zenith_degrees                  =   zenith_rad/pi*180;
        altitude_degrees                =   90-zenith_degrees;
        altitude_rad                    =   altitude_degrees/180*pi;
        
        azimuth_degrees                 =   acos((sin(altitude_rad)*sin(Lt_degrees/180*pi)-sin(delta_rad))/...
                                                 (cos(altitude_rad)*cos(Lt_degrees/180*pi)))              *...
                                                 180/pi;
        if omega_rad<0
            azimuth_degrees =   180+azimuth_degrees;         
        else
            azimuth_degrees =   180-azimuth_degrees;
        end
        azimuth_rad         =   azimuth_degrees/180*pi;
        
        Data.Solar.Altitude      =   altitude_rad;
        Data.Solar.Azimuth       =   azimuth_rad;
catch
    Data.Files.Serial_File          =   'No file selected';
    Data.Files.Serial_Indicator     =   0;
    Data.Files.Serial_Directory     =   'No file selected';
end