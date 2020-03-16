function Datalogger2_plotdata(Values)
close all
%plotting
% internal logger sensors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NTC
minutesntch.figure   =   figure(4);
minutesntch.axes     =   axes;
minutesntch.plot     =   plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,01)                               ,...
                              Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,02)                               ,...
                              Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,03)                               ,...
                              Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,04)                               ,...
                              Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,10)                               ,...
                              Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,12));
minutesntch.text     =   text(0,0,[{'Vineyard'};{'39-03-34.9N, 02-06-01.3'}]);                         
minutesntch.legend   =   legend('Sunlit Young Leaf'                                                                    ,...
                                'Shaded Young Leaf'                                                                  ,...
                                'Shaded Old Leaf'                                                                    ,...
                                'Sunlit Old Leaf'                                                                      ,...
                                'Shaded Soil'                                                                 ,...
                                'Sunlit Soil'                                                                   ,...
                                'Location','NorthWest');
minutesntch.xlabel   =   xlabel('Time ( Days )');
minutesntch.ylabel   =   ylabel('Temperature ( ^0C )');
minutesntch.title    =   title('Canopy Components Measurements. The soil and high Leaf Temperatures.');
minutesntch.text     =   text(0,0,[{'Vineyard'};{'Height of sensors: 1.0m'};{'39-03-34.9N, 02-06-01.3'}]);

% keyboard
set(minutesntch.figure   ,  'Units'     ,   'pixels', ...
                            'Position'  ,   [50 100 800 600]);
set(minutesntch.axes     ,  'XLim'      ,   [195*24*60 198*24*60]                                               ,...
                            'XTick'     ,   [(195:198)*24*60]                                                   ,...
                            'XTickLabel',   {'190','191','192','193','194','195','196','197','198'}             ,...
                            'Ylim'      ,   [10 70]                                                             ,...
                            'FontSize'  ,   14);
set(minutesntch.text     ,  'Units'     ,   'pixels'                                                            ,...
                            'Position'  ,   [10 30]                                                             ,...
                            'Fontweight',   'bold');
set(minutesntch.xlabel   ,  'Fontsize'  ,   14);
set(minutesntch.ylabel   ,  'Fontsize'  ,   14);
set(minutesntch.title    ,  'Fontsize'  ,   14);                        
set(minutesntch.legend   ,  'Fontsize'  ,   14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
homedir=cd;
cd ('d:/data/seN2FLEX2005/data Output/logger/')
saveas(minutesntch.figure  ,['Temperature measurements of the Canopy components (1.0m).tiff'], 'tiff') 
saveas(minutesntch.figure,['Temperature measurements of the Canopy components (1.0m).eps'], 'psc2')

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