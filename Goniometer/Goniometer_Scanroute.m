function [Data]=Goniometer_Scanroute(Data)
Data.Files.Scanroute_File    =   dir('*Scanroute*.log');
try    
    Data.Files.Scanroute_Indicator      =   fopen( Data.Files.Scanroute_File.name);
    Data.Scanroute.Coordinatesstring    =   fscanf(Data.Files.Scanroute_Indicator,'%s ',5);
    Data.Scanroute.Coordinatesstring    =   [{Data.Scanroute.Coordinatesstring(01:08)} , ...
                                             {Data.Scanroute.Coordinatesstring(09:16)} , ...
                                             {Data.Scanroute.Coordinatesstring(17:24)} , ...
                                             {Data.Scanroute.Coordinatesstring(25:35)} , ...
                                             {Data.Scanroute.Coordinatesstring(36:44)}];
    Data.Scanroute.Coordinates          =   fscanf(Data.Files.Scanroute_Indicator,'%15e %15e %15e %15e %15e\n');
    fclose(Data.Files.Scanroute_Indicator);
    Data.Scanroute.Coordinates          =   reshape(Data.Scanroute.Coordinates,5,size(Data.Scanroute.Coordinates,1)/5)';
    index                               =   find(abs(Data.Scanroute.Coordinates)<1e-10);
    Data.Scanroute.Coordinates(index)   =   0;
    
    %North Orientation
    try 
        angle_north_deg                 =   str2num(Data.Position.Orientation(1:3));
    catch
        answer                          =   inputdlg('Enter the Orientation to North in degrees',...
                                                     'North Orientation'                            ,...
                                                     1                                              ,...
                                                     {'0'});
        try

            angle_north_deg             =   str2num(str2mat(answer));
        catch
            angle_north_deg             =   0;
        end
    end
    matlab_angle                        =   90;     %Because matlab sets the zero angle to the x-axis, but we 
                                                      %want North to point upwards, we have to rotate 90 degrees
    angle_north_deg                     =   angle_north_deg -matlab_angle;    
    angle_north_rad                     =   angle_north_deg/180*pi;
    Data.Scanroute.Correction_Angle     =   angle_north_rad;
    [angle_rad,radius]                  =   cart2pol(Data.Scanroute.Coordinates(:,1),...
                                                     Data.Scanroute.Coordinates(:,2));
    angle_north_oriented_rad            =   angle_rad - angle_north_rad;
    [Data.Scanroute.Coordinates_north(:,1),...
     Data.Scanroute.Coordinates_north(:,2)] =   pol2cart(angle_north_oriented_rad,radius);
    [extrapoints(:,1),...
     extrapoints(:,2)]                      =   pol2cart(unique(angle_north_oriented_rad),1.1*ones(4,1));
    Data.Scanroute.Coordinates_north_extra  =   [Data.Scanroute.Coordinates_north;   extrapoints];
 
catch
    Data.Files.Scanroute_File           =   'No file selected';
    Data.Files.Scanroute_Indicator      =   0;    
end