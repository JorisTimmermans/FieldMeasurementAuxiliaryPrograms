function Datalogger2_plotdata(Values)
%plotting
% internal logger sensors
figure(1)
plot(Values.Calibration.NTC_Resistancelog, polyval(Values.Calibration.Polynomial            , ...
                                                   Values.Calibration.NTC_Resistancelog)    ,...
     Values.Calibration.NTC_Resistancelog,Values.Calibration.NTC_Temperature,'x')
title('Fit of the temperature-resistance curve for calculating NTC-temperature')
xlabel('Log(Resistance)')
ylabel('Temperature')

figure(2)
plot(Values.Minutes.Battery_volt)
title('Battery voltage')
axis([1 size(Values.Minutes.Battery_volt,1) 10 14])

figure(3)
plot(Values.Minutes.Panel_Temperature)
title('Panel Temperature')
axis([1 size(Values.Minutes.Panel_Temperature,1) 10 40])

%NTC
figure(4)
plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,01), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,02), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,03), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,04), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,05), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,06), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,07), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,08))
xlim([190*24*60 198*24*60])
set(gca,'XTick',[(190:198)*24*60])
set(gca,'XTickLabel',{'190','191','192','193','194','195','196','197','198'}) 
legend('Sun, Young, High'   ,...
       'Shade, Young, High' ,...
       'Shade, Old, High'   ,...
       'Sun, Old, High'     ,...
       'Sun, Old, High'     ,...
       'Shade, Old, Low,'   ,...
       'Sun, Young, Low'    ,...
       'Shade, Young, Low'  ,...
       'Location','Best')
xlabel('Time ( Days )')
ylabel('Temperature ( ^0C )')
title('Leaf Temperature Vineyard,  UTM coordinates (577836.4749E-4323786.0361N)')

figure(5)
plot(Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,09), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,10), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,11), ...
     Values.Minutes.Time_Minutes,Values.Minutes.NTC(:,12))
xlim([190*24*60 198*24*60])
set(gca,'XTick',[(190:198)*24*60])
set(gca,'XTickLabel',{'190','191','192','193','194','195','196','197','198'}) 
legend('Shade, Ground'      ,...
       'Shade, Ground'      ,...
       'Sun, Ground'        ,...
       'Sun, Ground'        ,...
       'Location','Best')
xlabel('Time ( Days )')
ylabel('Temperature ( ^0C )')
title('Soil Temperature Vineyard,  UTM coordinates (577836.4749E-4323786.0361N)')
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
keyboard