function [Data]=Goniometer_ThermalImagery(Data)
Data.Files.Thermal_Imager_File    =   dir('*Thermal*Imager*.csv');

try
    Data.Files.Thermal_Imager_Indicator =   fopen(Data.Files.Thermal_Imager_File.name);
    textdata                            =   fgetl(Data.Files.Thermal_Imager_Indicator);
    fclose(Data.Files.Thermal_Imager_Indicator);
    data                                =   csvread(Data.Files.Thermal_Imager_File.name,1);
    
    duration                            =   data(1:2:end,1);
    Data.Thermal.Raw_Data               =   data(2:2:end-1,:);    
    
   [month                               ,...
    day                                 ,...
    year                                ,...
    timestr(1)  ,...
    timestr(2)  ,...
    timestr(3)] =   strread(textdata,'%*s%s%d%d%d%d%d','delimiter',' :,');
    month       =   datestr(datenum(month,'mmmm'),'mm');
    Data.Thermal.Time_Start_Day     =   [num2str(day),'-',month,'-',num2str(year)];
   
    shifted_seconds                 =   timestr(3) + duration;
    Data.Thermal.Time_Seconds       =   shifted_seconds - 60 * floor(shifted_seconds/60);
    shifted_minutes                 =   timestr(2) + floor(shifted_seconds/60);
    Data.Thermal.Time_Minutes       =   shifted_minutes - 60 * floor(shifted_minutes/60);
    shifted_hours                   =   timestr(1) + floor(shifted_minutes/60);
    Data.Thermal.Time_Hours         =   shifted_hours - 24 * floor (shifted_hours/24);
    
    time_start_hours                =   Data.Thermal.Time_Hours  (1);
    time_start_minutes              =   Data.Thermal.Time_Minutes(1);
    time_start_seconds              =   Data.Thermal.Time_Seconds(1);

    Data.Thermal.Time_Start_Time    =   [num2str(Data.Thermal.Time_Hours  (1)) ,':'  , ...
                                         num2str(Data.Thermal.Time_Minutes(1)) ,':'  , ...
                                         num2str(Data.Thermal.Time_Seconds(1)) ];
    Data.Thermal.Time_Start_Time    =   Data.Thermal.Time_Start_Time(1:end-4); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Convert data to images format and interpolate%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Data.Thermal.Raw_Data           =   reshape(Data.Thermal.Raw_Data,size(Data.Thermal.Raw_Data,1),16,16);
    Data.Thermal.Raw_Data           =   permute(Data.Thermal.Raw_Data,[3 2 1]);
    
catch
    Data.Files.Thermal_Imager_File         =   'No file selected';
    Data.Files.Thermal_Imager_Indicator    =   0;
end