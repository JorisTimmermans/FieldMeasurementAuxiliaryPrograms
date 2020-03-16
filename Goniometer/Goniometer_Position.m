function [Data]=Goniometer_Position(Data)
Data.Files.Position_File                =   dir('*Position*.txt');
try
    Data.Files.Position_Indicator       =   fopen(Data.Files.Position_File.name);
    textcrop                            =   fgetl(Data.Files.Position_Indicator);    
    textcoordinates                     =   fgetl(Data.Files.Position_Indicator);
    textcroporientation                 =   fgetl(Data.Files.Position_Indicator);
    textorientation                     =   fgetl(Data.Files.Position_Indicator);
    fclose(Data.Files.Position_Indicator);
    
%     keyboard
    Data.Position.Crop                  =   textcrop(13:end);
    Data.Position.Crop_Orientation      =   textcroporientation(20:end);
    Data.Position.Coordinates_LatLon    =   textcoordinates(16:end);
    Data.Position.Coordinates_Lat       =   Data.Position.Coordinates_LatLon(1:12);
    Data.Position.Coordinates_Lon       =   Data.Position.Coordinates_LatLon(15:end);
    
    Data.Position.Orientation           =   textorientation(19:end);        %(left hand turn)

catch
    Data.Files.Position_File            =   'No file selected';
    Data.Files.Position_Indicator       =   0;
    Data.Files.Position_Directory       =   'No file selected';
end