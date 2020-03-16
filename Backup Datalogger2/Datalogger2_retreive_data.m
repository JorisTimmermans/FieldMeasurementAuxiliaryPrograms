function [Values] = Datalogger2_retreive_data(Values, Values2)
                    
Values.Minutes.Names  ={'ID'                                                                        ;...
                        'Time_Day_Nums';'Time_Day_Minutes';'Time_Nums';'Time_Hours';'Time_Minutes'  ;...
                        'Resistance_NTC';'NTC'                                                      ;...
                        'Soil_Heat_Flux'                                                            ;...
                        'Pressure'                                                                  ;...
                        'Volume_Water_Content'                                                      ;...
                        'Panel_Temperature';'Battery_volt'};
keyboard
open(Values.Files.File);
while not(exist('MR23X'))        
    pause(0.1)
end
Data = MR23X;
ii      =   find(Data(:,1)==121);
clear MR23X

for j=1:size(Values.Minutes.Names)
    Values.Minutes.(cell2mat(Values.Minutes.Names(j)))=[];
end
Values.Files.SizeDatablock_Minutes  =   [];

if isempty(Values2)
    Values2=Values;
end 


Values.Minutes.ID                       =   Data(ii,01);
Values.Minutes.Time_Day_Nums            =   Data(ii,02);
Values.Minutes.Time_Day_Minutes         =   Values.Minutes.Time_Day_Nums*24*60;
Values.Minutes.Time_Nums                =   Data(ii,03);
Values.Minutes.Time_Hours               =   floor(Values.Minutes.Time_Nums/100);
Values.Minutes.Time_Minutes             =   Values.Minutes.Time_Nums - 100*Values.Minutes.Time_Hours + ...
                                            Values.Minutes.Time_Hours*60 + Values.Minutes.Time_Day_Minutes;
 
Values.Minutes.Resistance_NTC           =   zeros(size(Values.Minutes.Time_Minutes,1),12);
Values.Minutes.Resistance_NTC(:,1)      =   Data(ii,04);
Values.Minutes.Resistance_NTC(:,2)      =   Data(ii,05);
Values.Minutes.Resistance_NTC(:,3)      =   Data(ii,06);
Values.Minutes.Resistance_NTC(:,4)      =   Data(ii,07);
Values.Minutes.Resistance_NTC(:,5)      =   Data(ii,08);    
Values.Minutes.Resistance_NTC(:,6)      =   Data(ii,09);
Values.Minutes.Resistance_NTC(:,7)      =   Data(ii,10);
Values.Minutes.Resistance_NTC(:,8)      =   Data(ii,11);
Values.Minutes.Resistance_NTC(:,9)      =   Data(ii,12);
Values.Minutes.Resistance_NTC(:,10)     =   Data(ii,13);
Values.Minutes.Resistance_NTC(:,11)     =   Data(ii,14);
Values.Minutes.Resistance_NTC(:,12)     =   Data(ii,15);

Values.Minutes.Soil_Heat_Flux(:,1)      =   Data(ii,16);
Values.Minutes.Soil_Heat_Flux(:,2)      =   Data(ii,17);
Values.Minutes.Soil_Heat_Flux(:,3)      =   Data(ii,18);
Values.Minutes.Soil_Heat_Flux(:,4)      =   Data(ii,19);
Values.Minutes.Pressure                 =   Data(ii,20);
Values.Minutes.Volume_Water_Content(:,1)=   Data(ii,21);
Values.Minutes.Volume_Water_Content(:,2)=   Data(ii,22);
Values.Minutes.Volume_Water_Content(:,3)=   Data(ii,23);
Values.Minutes.Panel_Temperature        =   Data(ii,24);
Values.Minutes.Battery_volt             =   Data(ii,25);

% keyboard
for j=1:size(Values.Minutes.Names,1)
    Values.Minutes.(cell2mat(Values.Minutes.Names(j)))  =   [Values2.Minutes.(cell2mat(Values.Minutes.Names(j))); ...
                                                              Values.Minutes.(cell2mat(Values.Minutes.Names(j)))];
end

Values.Files.SizeDatablock_Minutes      =   [Values2.Files.SizeDatablock_Minutes     ;size(Data(ii,1),1)];