clc
clear all
close all
homedir =   cd;
cd ('C:\Documents and Settings\joris\Bureaublad')
[Data, Files, filterindex] = uigetfile('*.dat', 'Pick the MR23X datafile');
cd(Files)
Temp    =   open(Data);
Data    =   Temp.MR23X;
ii      =   find(Data(:,1)==121);
cd(homedir)
clear Temp Files filterindex homedir
    
Values.Minutes.Name   =['ID           ';'Day          ';'Time         ';...
                        'Thermistor_01';'Thermistor_02';'Thermistor_03';'Thermistor_04';...
                        'Thermistor_05';'Thermistor_06';'Thermistor_07';'Thermistor_08';...
                        'Thermistor_09';'Thermistor_10';'Thermistor_11';'Thermistor_12';...
                        'Fluxplates_01';'Fluxplates_02';'Fluxplates_03';'Fluxplates_04';...
                        'Pressure     ';...
                        'TDR_1        ';'TDR_2        ';'TDR_3        ';...
                        'Paneltemp    ';'Battery volt '];

Values.Minutes.ID                       =  Data(ii,01);
Values.Minutes.Time.Day.Nums            =  Data(ii,02);
Values.Minutes.Time.Day.Minutes         =  Values.Minutes.Time.Day.Nums*24*60;
Values.Minutes.Time.Nums                =  Data(ii,03);
Values.Minutes.Time.Hours               =  floor(Values.Minutes.Time.Nums/100);
Values.Minutes.Time.Minutes             =  Values.Minutes.Time.Nums - 100*Values.Minutes.Time.Hours + 60*Values.Minutes.Time.Hours + Values.Minutes.Time.Day.Minutes;

Values.Minutes.Resistance_NTC              =   zeros(size(Values.Minutes.Time.Minutes,1),12);
Values.Minutes.Resistance_NTC(:,1)         =  Data(ii,04);
Values.Minutes.Resistance_NTC(:,2)         =  Data(ii,05);
Values.Minutes.Resistance_NTC(:,3)         =  Data(ii,06);
Values.Minutes.Resistance_NTC(:,4)         =  Data(ii,07);
Values.Minutes.Resistance_NTC(:,5)         =  Data(ii,08);    
Values.Minutes.Resistance_NTC(:,6)         =  Data(ii,09);
Values.Minutes.Resistance_NTC(:,7)         =  Data(ii,10);
Values.Minutes.Resistance_NTC(:,8)         =  Data(ii,11);
Values.Minutes.Resistance_NTC(:,9)         =  Data(ii,12);
Values.Minutes.Resistance_NTC(:,10)        =  Data(ii,13);
Values.Minutes.Resistance_NTC(:,11)        =  Data(ii,14);
Values.Minutes.Resistance_NTC(:,12)        =  Data(ii,15);

Values.Minutes.Soil_Heat_Flux(:,1)      =  Data(ii,16);
Values.Minutes.Soil_Heat_Flux(:,2)      =  Data(ii,17);
Values.Minutes.Soil_Heat_Flux(:,3)      =  Data(ii,18);
Values.Minutes.Soil_Heat_Flux(:,4)      =  Data(ii,19);
Values.Minutes.Pressure                 =  Data(ii,20);
Values.Minutes.Volume_Water_Content(:,1)=  Data(ii,21);
Values.Minutes.Volume_Water_Content(:,2)=  Data(ii,22);
Values.Minutes.Volume_Water_Content(:,3)=  Data(ii,23);
Values.Minutes.Panel_Temperature        =  Data(ii,24);
Values.Minutes.Battery_volt             =  Data(ii,25);

%correcting spikes
Values.Minutes.Resistance_NTC(find(Values.Minutes.Resistance_NTC<10)) = NaN;
%Calibration
Values.Calibration.NTC.Temperature =    (-8:20)'*5;
Values.Calibration.NTC.Resistance  =    [2664 ; 1933 ; 1421 ; 1052 ; 788.5; 594.4; 453.0; 347.6; ...
                                         269.3; 209.7; 164.8; 130.1; 103.6; 83.00; 66.91; 54.19; ...
                                         44.18; 36.17; 29.80; 24.65; 20.51; 17.13; 14.37; 12.10; ...
                                         10.24; 8.700; 7.419; 6.351; 5.460];
Values.Calibration.NTC.Resistancelog=   log(Values.Calibration.NTC.Resistance);
plot(Values.Calibration.NTC.Resistancelog,Values.Calibration.NTC.Temperature,'x')
xlabel('Log(Resistance)')
ylabel('Temperature')
[Values.Calibration.Polynomial, error ] =polyfit(Values.Calibration.NTC.Resistancelog,Values.Calibration.NTC.Temperature,4);

hold on
plot(Values.Calibration.NTC.Resistancelog, polyval(Values.Calibration.Polynomial, Values.Calibration.NTC.Resistancelog))
hold off

Values.Minutes.NTC  =   polyval(Values.Calibration.Polynomial,log(Values.Minutes.Resistance_NTC))

%plotting
% internal logger sensors
figure(1)
plot(Values.Minutes.Battery_volt)
title('Battery voltage')
axis([1 size(Values.Minutes.Battery_volt,1) 10 14])

figure(2)
plot(Values.Minutes.Panel_Temperature)
title('Panel Temperature')
axis([1 size(Values.Minutes.Panel_Temperature,1) 10 40])

%NTC
 figure(3)
 plot([1:size(Values.Minutes.NTC(:,01),1)],Values.Minutes.NTC(:,01), ...
      [1:size(Values.Minutes.NTC(:,02),1)],Values.Minutes.NTC(:,02), ...
      [1:size(Values.Minutes.NTC(:,03),1)],Values.Minutes.NTC(:,03), ...
      [1:size(Values.Minutes.NTC(:,04),1)],Values.Minutes.NTC(:,04), ...
      [1:size(Values.Minutes.NTC(:,05),1)],Values.Minutes.NTC(:,05), ...
      [1:size(Values.Minutes.NTC(:,06),1)],Values.Minutes.NTC(:,06), ...
      [1:size(Values.Minutes.NTC(:,07),1)],Values.Minutes.NTC(:,07), ...
      [1:size(Values.Minutes.NTC(:,08),1)],Values.Minutes.NTC(:,08), ...
      [1:size(Values.Minutes.NTC(:,09),1)],Values.Minutes.NTC(:,09), ...
      [1:size(Values.Minutes.NTC(:,10),1)],Values.Minutes.NTC(:,10), ...
      [1:size(Values.Minutes.NTC(:,11),1)],Values.Minutes.NTC(:,11), ...
      [1:size(Values.Minutes.NTC(:,12),1)],Values.Minutes.NTC(:,12))
 title('Thermistors')
%  legend('Shadow high','Shadow low', 'Sun High', 'Sun low')
axis([1 size(Values.Minutes.Panel_Temperature,1) 10 60])

%Soil Heat Flux
% figure(3)
% plot([1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,1), ...
%      [1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,2), ...
%      [1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,3))
% title('Soil Heat Flux Plates')
% legend('Sun','Intermediate','Shadow')

%Volume Water Content
% figure(3)
% plot([1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,1), ...
%      [1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,2), ...
%      [1:size(Values.Minutes.Soil_Heat_Flux,1)],Values.Minutes.Soil_Heat_Flux(:,3))
% title('Soil Heat Flux Plates')
% legend('Sun','Intermediate','Shadow')



% %wind
% figure(10)
% plot(Values.Minutes.Wind.direction(100:end))
% title('Winddirection')
% axis([1 size(Values.Minutes.Wind.direction,1) 0 360])
% 
% figure(10)
% plot(1:size(Values.Minutes.Wind.speed.high,1),Values.Minutes.Wind.speed.high,...
%      1:size(Values.Minutes.Wind.speed.high,1),Values.Minutes.Wind.speed.low)
% title('Windspeed')
% legend('Windspeed High','Windspeed low')
% axis([1 size(Values.Minutes.Wind.speed.high,1) 0 10])
% %scintillometer output
% figure(11)
% plot(Values.Seconds.UCN2)
% title('Scintillometer Signal')
% axis([1 size(Values.Seconds.UCN2,1) -2 0])
% 
% figure(12)
% plot(Values.Seconds.Demod)
% title('Scintillometer Carrier')
% axis([1 size(Values.Seconds.Demod,1) -0.2 0])

% clear jj ii clear Data


