function [Data]=Goniometer_ASD(Data)
Data.Files.ASD_File                =   dir('*ASD*.txt');
try
    Data.ASD.Raw                    =   load ('ASD.txt');
    Data.ASD.Band_Number            =   Data.ASD.Raw(:,1);
    Data.ASD.Wavelength             =   Data.ASD.Raw(:,2);
    Data.ASD.White_Reference        =   Data.ASD.Raw(:,3:4);
    Data.ASD.Measurements           =   Data.ASD.Raw(:,5:end);
    Data.Files.ASD_Indicator        =   3;
catch
    Data.Files.ASD_Indicator        =   -1;
end


if Data.Files.Serial_Indicator~=0
    subTitle   =   [Data.Serial.Time_Start_Day      ,'_'                    ,...
                    Data.Serial.Time_Start_Time(1:2),'-'                    ,...
                    Data.Serial.Time_Start_Time(4:5)];
    datetext    =  [Data.Serial.Time_Start_Day      ,' '                    ,...
                    Data.Serial.Time_Start_Time(1:2),':'                    ,...
                    Data.Serial.Time_Start_Time(4:5)];
elseif Data.Files.ThermoTracer_Indicator==1
    subTitle    =   [datestr(Data.ThermoTracer.Date(1),'dd-mm-yyyy'),'_'    ,...
                     datestr(Data.ThermoTracer.Time(1),'HH-MM')];
    datetext    =   [datestr(Data.ThermoTracer.Date(1),'dd-mm-yyyy'),' '    ,...
                     datestr(Data.ThermoTracer.Time(1),'HH:MM')];
else
    subTitle    =   [];
end


if Data.Files.Position_Indicator~=0 & Data.Files.Serial_Indicator~=0
    Text                    =   [{ Data.Position.Crop}                                                          ;...
                                 {datetext}                                                                     ;...
                                 {Data.Position.Coordinates_LatLon}];
elseif Data.Files.Position_Indicator==0 & Data.Files.Serial_Indicator~=0
    Text                    =   datetext;
elseif Data.Files.Position_Indicator~=0 & Data.Files.Serial_Indicator==0
    Text                    =   [{ Data.Position.Crop}                                                          ;...
                                 {datetext}                                                                     ;...
                                 {Data.Position.Coordinates_LatLon}];
else
    Text                    =   [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Everest and Cimel Data Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Preparing Data


