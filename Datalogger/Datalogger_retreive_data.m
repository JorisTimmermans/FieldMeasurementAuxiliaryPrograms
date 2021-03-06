function [Values] = Retreive_data(Values,Values2)

open(Values.Files.File);
while not(exist('C23x'))        
    pause(0.1)
end
cd(Values.Files.Startdir)

Data    =   C23x;
ii      =   find(Data(:,1)==153);
jj      =   find(Data(:,1)==111);
ii      =   ii(find(Data(ii(1:end-1)-1,1)==111));                               %correction for sensor values of 111 
jj      =   jj(find(Data(jj(1:end-1)+1,1)==111 | Data(jj(1:end-1)+1,1)==153));   %or 153, which could mess up the numbering

Values.Seconds.Names   ={'ID';...
                        'UCN2';'Demod';...
                        'Day'};

Values.Minutes.Names   ={'ID';...
                        'Time_Day_Nums';'Time_Day_Minutes';'Time_Nums';'Time_Hours';'Time_Minutes';...
                        'UCN2_av';'Demod_av';'Var_UCN2';'Var_demo';'PUCN21000';'N';...
                        'Radiation_Short_inc'; 'Radiation_Short_out';'Radiation_Long_inc';'Radiation_Long_out';...
                        'PT100';...
                        'Temperature_high';'Temperature_low';'Relative_Humidity_high';'Relative_Humidity_low';...
                        'Wind_direction';'Wind_speed_high';'Wind_speed_low';....
                        'Soil_Heat_Flux';...
                        'Thermistor';...
                        'Panel_temperature';'Battery_volt'};
                    
% Declare all entries beforehand, safes memory (i think)
for j=1:size(Values.Minutes.Names)
    Values.Minutes.(cell2mat(Values.Minutes.Names(j)))=[];
end

Values.Files.SizeDatablock_Seconds  =   [];
Values.Files.SizeDatablock_Minutes  =   [];

for j=1:size(Values.Seconds.Names)
    Values.Seconds.(cell2mat(Values.Seconds.Names(j)))=[];
end


%if only daily measurements are investigated, Values2 is left empty! 
if isempty(Values2)
    Values2=Values;
end 

Values.Minutes.ID                       =  [Data(ii + 0 ,01)];
Values.Minutes.Time_Day_Nums            =  [Data(ii + 0 ,02)];
Values.Minutes.Time_Day_Minutes         =  [Values.Minutes.Time_Day_Nums*24*60];
Values.Minutes.Time_Nums                =  [Data(ii + 0 ,03)];
Values.Minutes.Time_Hours               =  [floor(Values.Minutes.Time_Nums/100)];
Values.Minutes.Time_Minutes             =  [Values.Minutes.Time_Nums - 100*Values.Minutes.Time_Hours + 60*Values.Minutes.Time_Hours + Values.Minutes.Time_Day_Minutes];

Values.Minutes.ID                       =  [Values2.Minutes.ID                      ;Values.Minutes.ID];
Values.Minutes.Time_Day_Nums            =  [Values2.Minutes.Time_Day_Nums           ;Values.Minutes.Time_Day_Nums];
Values.Minutes.Time_Day_Minutes         =  [Values2.Minutes.Time_Day_Minutes        ;Values.Minutes.Time_Day_Minutes];
Values.Minutes.Time_Nums                =  [Values2.Minutes.Time_Nums               ;Values.Minutes.Time_Nums];
Values.Minutes.Time_Hours               =  [Values2.Minutes.Time_Hours              ;Values.Minutes.Time_Hours];
Values.Minutes.Time_Minutes             =  [Values2.Minutes.Time_Minutes            ;Values.Minutes.Time_Minutes];

Values.Minutes.UCN2_av                  =  [Values2.Minutes.UCN2_av                 ;Data(ii + 1 ,01)];
Values.Minutes.Demod_av                 =  [Values2.Minutes.Demod_av                ;Data(ii + 1 ,02)];
Values.Minutes.Var_UCN2                 =  [Values2.Minutes.Var_UCN2                ;Data(ii + 1 ,03)];
Values.Minutes.Var_demo                 =  [Values2.Minutes.Var_demo                ;Data(ii + 2 ,01)];
Values.Minutes.PUCN21000                =  [Values2.Minutes.PUCN21000               ;Data(ii + 2 ,02)];    
Values.Minutes.Radiation_Short_inc      =  [Values2.Minutes.Radiation_Short_inc     ;Data(ii + 3 ,01)];
Values.Minutes.Radiation_Short_out      =  [Values2.Minutes.Radiation_Short_out     ;Data(ii + 3 ,02)];
Values.Minutes.Radiation_Long_inc       =  [Values2.Minutes.Radiation_Long_inc      ;Data(ii + 3 ,03)];   
Values.Minutes.Radiation_Long_out       =  [Values2.Minutes.Radiation_Long_out      ;Data(ii + 4 ,01)];
Values.Minutes.PT100                    =  [Values2.Minutes.PT100                   ;Data(ii + 4 ,02)];
Values.Minutes.Temperature_high         =  [Values2.Minutes.Temperature_high        ;Data(ii + 4 ,03)];
Values.Minutes.Temperature_low          =  [Values2.Minutes.Temperature_low         ;Data(ii + 5 ,01)];
Values.Minutes.Relative_Humidity_high   =  [Values2.Minutes.Relative_Humidity_high  ;Data(ii + 5 ,02)];
Values.Minutes.Relative_Humidity_low    =  [Values2.Minutes.Relative_Humidity_low   ;Data(ii + 5 ,03)];
Values.Minutes.Wind_direction           =  [Values2.Minutes.Wind_direction          ;Data(ii + 6 ,02)];
Values.Minutes.Soil_Heat_Flux           =  zeros(size(ii,1),3);
Values.Minutes.Soil_Heat_Flux(:,1)      =  Data(ii + 6 ,03);
Values.Minutes.Soil_Heat_Flux(:,2)      =  Data(ii + 7 ,01);
Values.Minutes.Soil_Heat_Flux(:,3)      =  Data(ii + 7 ,02);
Values.Minutes.Soil_Heat_Flux           =  [Values2.Minutes.Soil_Heat_Flux          ;Values.Minutes.Soil_Heat_Flux];
Values.Minutes.Thermistor               =  zeros(size(ii,1),4);
Values.Minutes.Thermistor(:,1)          =  Data(ii + 7 ,03);
Values.Minutes.Thermistor(:,2)          =  Data(ii + 8 ,01);
Values.Minutes.Thermistor(:,3)          =  Data(ii + 8 ,02);
Values.Minutes.Thermistor(:,4)          =  Data(ii + 8 ,03);
Values.Minutes.Thermistor               =  [Values2.Minutes.Thermistor              ;Values.Minutes.Thermistor];
Values.Minutes.Wind_speed_high          =  [Values2.Minutes.Wind_speed_high         ;Data(ii + 09 ,01)];
Values.Minutes.Wind_speed_low           =  [Values2.Minutes.Wind_speed_low          ;Data(ii + 09 ,02)];
Values.Minutes.Panel_temperature        =  [Values2.Minutes.Panel_temperature       ;Data(ii + 09 ,03)];
Values.Minutes.Battery_volt             =  [Values2.Minutes.Battery_volt            ;Data(ii + 10 ,01)];

% Correction for the Errors in the numbering of the 1Hz data
N                                       =   zeros(size(Data(ii + 2 ,03)));
N                                       =   [1;ii(2:end) - ii(1:end-1) - 11];

sum1                    =   0;
jj                      =   zeros(sum(N),1);
for j=1:size(N)
    index               =   1:N(j);
    jj(index + sum1)    =   index + sum1 + (j-1)*11;
    sum1                =   sum1 + max(index);
end

Values.Minutes.N                        =   [Values2.Minutes.N                       ;N];

Values.Seconds.ID                       =  [Values2.Seconds.ID                      ;Data(jj,1)];
Values.Seconds.UCN2                     =  [Values2.Seconds.UCN2                    ;Data(jj,2)];
Values.Seconds.Demod                    =  [Values2.Seconds.Demod                   ;Data(jj,3)];
% Values.Seconds.Day                      =  [Values2.Seconds.Day                     ;Data(jj,2)];

Values.Files.SizeDatablock_Minutes      =  [Values2.Files.SizeDatablock_Minutes     ;size(Data(ii,1),1)];
Values.Files.SizeDatablock_Seconds      =  [Values2.Files.SizeDatablock_Seconds     ;size(Data(jj,1),1)];
