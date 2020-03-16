function Datalogger2_plotdata(Values)
close all
%plotting
% internal logger sensors
calibration.figure  =   figure(1);
calibration.axes    =   axes;
calibration.plot    =   plot(        Values.Calibration.NTC_Resistancelog                                       ,...
                             polyval(Values.Calibration.Polynomial,Values.Calibration.NTC_Resistancelog)        ,...
                                     Values.Calibration.NTC_Resistancelog                                       ,...
                                     Values.Calibration.NTC_Temperature,'x');
calibration.title   =   title('Fit of the temperature-resistance curve for calculating NTC-temperature');
calibration.xlabel  =   xlabel('Ln(R)');
calibration.ylabel  =   ylabel('Temperature (^0C)');

set(calibration.axes    ,   'FontSize'  ,   14)
set(calibration.figure  ,   'Units'     ,   'pixels'                                                           ,...
                            'Position'  ,   [50 100 800 600]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minutesbat.figure   =   figure(2);
minutesbat.axes     =   axes;
minutesbat.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.Battery_volt);
minutesbat.title    =   title('Canopy Components Measurements. Battery voltage of Logger');
minutesbat.xlabel   =   xlabel('Time ( Days )');
minutesbat.ylabel   =   ylabel('Battery Voltage ( V )');
minutesbat.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);

set(minutesbat.figure  ,    'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [50 100 800 600]);
set(minutesbat.axes     ,   'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'YLim'      ,   [10 14]                                                             ,...
                            'FontSize'  ,   14);

set(minutesbat.text     ,   'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');
set(minutesbat.xlabel   ,   'Fontsize'  ,   14);
set(minutesbat.ylabel   ,   'Fontsize'  ,   14);
set(minutesbat.title    ,   'Fontsize'  ,   14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minutespan.figure   =   figure(3);
minutespan.axes     =   axes;
minutespan.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.Panel_Temperature);
minutespan.title    =   title('Canopy Components Measurements. Internal Logger Temperature');
minutespan.xlabel   =   xlabel('Time ( Days )');
minutespan.ylabel   =   ylabel('Temperature ( ^0C )');
minutespan.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);

set(minutespan.figure  ,    'Units'     ,   'pixels', ...
                            'Position'  ,   [50 100 800 600]);                      
set(minutespan.axes     ,   'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'YLim'      ,   [10 40]                                                             ,...
                            'FontSize'  ,   14);
set(minutespan.text     ,   'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');
set(minutespan.xlabel   ,   'Fontsize'  ,   14);
set(minutespan.ylabel   ,   'Fontsize'  ,   14);
set(minutespan.title    ,   'Fontsize'  ,   14);                        
% keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NTC
minutesntch.figure   =   figure(4);
minutesntch.axes     =   axes;
minutesntch.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,01)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,02)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,03)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,04));
minutesntch.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);                         
minutesntch.legend   =   legend('Sun, Young'                                                               ,...
                                'Shade, Young'                                                             ,...
                                'Shade, Old'                                                               ,...
                                'Sun, Old'                                                                 ,...
                                'Location','NorthWest');
minutesntch.xlabel   =   xlabel('Time ( Days )');
minutesntch.ylabel   =   ylabel('Temperature ( ^0C )');
minutesntch.title    =   title('Canopy Components Measurements. The Leaf Temperature.');
minutesntch.text     =   text(0,0,[{'Vineyard'};{'Height of sensors: 1.0m'};{'39-03-34.9N, 02-06-01.3'}]);

% keyboard
set(minutesntch.figure   ,  'Units'     ,   'pixels', ...
                            'Position'  ,   [50 100 800 600]);
set(minutesntch.axes     ,  'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'FontSize'  ,   14);
set(minutesntch.text     ,  'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');
set(minutesntch.xlabel   ,  'Fontsize'  ,   14);
set(minutesntch.ylabel   ,  'Fontsize'  ,   14);
set(minutesntch.title    ,  'Fontsize'  ,   14);                        
set(minutesntch.legend   ,  'Fontsize'  ,   14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NTC
minutesntcl.figure   =   figure(5);
minutesntcl.axes     =   axes;
minutesntcl.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,05)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,06)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,07)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,08));
minutesntcl.text     =   text(0,0,[{'Vineyard'};{'Height of sensors: 0.5m'};{'39-03-34.9N, 02-06-01.3'}]);
minutesntcl.legend   =   legend('Sun, Old'                                                                 ,...
                                'Shade, Old'                                                               ,...
                                'Sun, Young'                                                                ,...
                                'Shade, Young'                                                              ,...
                                'Location','NorthWest');
minutesntcl.xlabel   =   xlabel('Time ( Days )');
minutesntcl.ylabel   =   ylabel('Temperature ( ^0C )');
minutesntcl.title    =   title('Canopy Components Measurements. The Leaf Temperature');
minutesntcl.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);

% keyboard
set(minutesntcl.figure   ,  'Units'     ,   'pixels', ...
                            'Position'  ,   [50 100 800 600]);
set(minutesntcl.axes     ,  'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'FontSize'  ,   14);
set(minutesntcl.text     ,  'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');
set(minutesntcl.xlabel   ,  'Fontsize'  ,   14);
set(minutesntcl.ylabel   ,  'Fontsize'  ,   14);
set(minutesntcl.title    ,  'Fontsize'  ,   14);                        
set(minutesntcl.legend   ,  'Fontsize'  ,   14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minutesntcs.figure   =   figure(6);
minutesntcs.axes     =   axes;
minutesntcs.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,09)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,10)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,11)                               ,...
                             Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,12));
minutesntcs.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);                      
minutesntcs.legend   =   legend('Shade, Ground'                                                                  ,...
                               'Shade, Ground'                                                                  ,...
                               'Sun, Ground'                                                                    ,...
                               'Sun, Ground'                                                                    ,...
                               'Location','NorthWest');
minutesntcs.xlabel   =   xlabel('Time ( Days )');
minutesntcs.ylabel   =   ylabel('Temperature ( ^0C )');
minutesntcs.title    =   title('Canopy Components Measurements. The Soil Temperature');

set(minutesntcs.figure   ,   'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [50 100 800 600]);
set(minutesntcs.text     ,   'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');                        
set(minutesntcs.axes     ,   'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'FontSize'  ,   14);
set(minutesntcs.xlabel   ,   'Fontsize'  ,   14);
set(minutesntcs.ylabel   ,   'Fontsize'  ,   14);
set(minutesntcs.title    ,   'Fontsize'  ,   14);
set(minutesntcs.legend   ,   'Fontsize'  ,   14);


homedir=cd;
cd ('d:/data/seN2FLEX2005/data Output/logger/')
saveas(minutesntch.figure  ,['Temperature measurements of the Canopy components (1.0m).tiff'], 'tiff') 
saveas(minutesntch.figure,['Temperature measurements of the Canopy components (1.0m).eps'], 'psc2')
saveas(minutesntcl.figure  ,['Temperature measurements of the Canopy components (0.5m).tiff'], 'tiff') 
saveas(minutesntcl.figure,['Temperature measurements of the Canopy components (0.5m).eps'], 'psc2')
saveas(minutesntcs.figure  ,['Temperature measurements of the Canopy components (Soil).tiff'], 'tiff') 
saveas(minutesntcs.figure,['Temperature measurements of the Canopy components (Soil).eps'], 'psc2')
cd(homedir)
% keyboard
%           goniometer vineyard  39-03-349N, 2-06-013W (UTM 577836.4749E-4323786.0361N)
                                                            
%           goniometer grassland 39-03-362N, 2-06-006W
%           base transmitter     39-03-145N, 2-05-595W
%           base scintillometer  39-03-376N, 2-06-095W
%           old heights    
%                 Rn  4.80
%                 soil    1.5 0.75 0 @ 0.5cm        Highte
%                 Tsoil   1.5      0 @ 0.5cm & 10cm hoogte
%                 RH_t    4.78;2.50
%                 u   4.88;2.60
%                 u-> 4.88
%                 las 5.06
%           goniometer-setup
%               arm 1.25
%               frame 119
%               box (on which it stood on for the vineyard: 40)
%               vineyard height: 150
%               9th row
% keyboard