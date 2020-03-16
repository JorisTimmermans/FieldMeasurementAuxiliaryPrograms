% function [Data]   =   Goniometer_main
 close all;
fclose all;
    Goniometer_Startup;
    if Data.Files.Directory_Indicator  ==   1
        Data            =   Goniometer_Position(Data);
        Data            =   Goniometer_SerialData(Data);                    %done
        Data            =   Goniometer_Scanroute(Data);                     %done
        Data            =   Goniometer_ThermalImagery(Data);                %done
        Data            =   Goniometer_Everest(Data);                       %done
        Data            =   Goniometer_ThermoTracer(Data);                  %done
        Data            =   Goniometer_ASD(Data);                           %done        
        Data            =   Goniometer_Cimel(Data);                         %done        
        Data            =   Goniometer_OrderingTimestamps(Data);            %done        
        Data            =   Goniometer_CalculateData(Data);                 %done
        Data            =   Goniometer_OutputData(Data);               %done
        %
        %pause(0.1)
        close all
    end
    cd(homedir)
    clear homedir
    
%     correct the orientation of the measurements with the pointing direction (304 N)
% combine streams
% Data            =   Goniometer_Imager_Region_of_Interest(Data);     %done