function    plotdata(Values)

if min(Values.Files.File~=0)
    close all
    x_start_m =   Values.Minutes.Time_Start;
    x_end_m   =   Values.Minutes.Time_End;
    x_start_s =   Values.Seconds.Time_Start;
    x_end_s   =   Values.Seconds.Time_End;
    
    switch Values.Files.ID
        case 'Daily'
            [Hours_m,index_m]   =   unique(Values.Minutes.Time_Hours);
            [Hours_s,index_s]   =   unique(Values.Seconds.Time_Hours);
            [I_m,J_m]           =   sort(index_m);
            [I_s,J_s]           =   sort(index_s);
            I_m                 =   [1;I_m(1:end-1)+1];
            I_s                 =   [1;I_s(1:end-1)+1];
            markers_position_m  =   Values.Minutes.Time_Minutes(I_m);
            markers_position_s  =   Values.Seconds.Time_Seconds(I_s);
            markers_label_s_m   =   num2str(Hours_m(J_m));
            markers_label_s_s   =   num2str(Hours_s(J_s));
            for j=1:size(markers_label_s_m,1)
                markers_label_c_m(j) =  {[markers_label_s_m(j,:),':00']};
            end
            for j=1:size(markers_label_s_s,1)
                markers_label_c_s(j) =  {[markers_label_s_s(j,:),':00']};
            end
            markers_label_c_m   =   markers_label_c_m(1:2:end);
            markers_label_c_s   =   markers_label_c_s(1:2:end);
            markers_position_m  =   markers_position_m(1:2:end);
            markers_position_s  =   markers_position_s(1:2:end);
        case 'Total'
            [Days_m,index_m]    =   unique(Values.Minutes.Time_Day_Nums);
            [Days_s,index_s]    =   unique(Values.Seconds.Time_Day_Nums);
            index_m             =   index_m(~isnan(Days_m));
            index_s             =   index_s(~isnan(Days_s));
            Days_m              =   Days_m( ~isnan(Days_m));
            Days_s              =   Days_s( ~isnan(Days_s));
            index_m             =   [1  ;   index_m(1:end-1)+1];
            index_s             =   [1  ;   index_s(1:end-1)+1];
            markers_position_m  =   Values.Minutes.Time_Minutes(index_m);
            markers_position_s  =   Values.Seconds.Time_Seconds(index_s);
            markers_label_s_m   =   datestr(Days_m);
            markers_label_s_s   =   datestr(Days_s);
            for j=1:size(markers_label_s_m,1)
                markers_label_c_m(j) =  {markers_label_s_m(j,1:2)};
            end
            for j=1:size(markers_label_s_s,1)
                markers_label_c_s(j) =  {markers_label_s_s(j,1:2)};
            end
    end
    %internal logger sensors
        figure(1)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.Battery_volt)
        title('Battery voltage')
        axis([x_start_m x_end_m 10 14])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on

        figure(2)
        plot(Values.Minutes.Time_Minutes, Values.Minutes.Panel_temperature)
        title('Panel Temperature')
        axis([x_start_m x_end_m 10 60])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
    %net radiation sensors
        figure(3)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.Radiation_Short_inc)
        title('Short wave incoming Radiation')
        axis([x_start_m x_end_m 0 1400])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
        figure(4)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.Radiation_Short_out)
        title('Short wave outgoing Radiation')
        axis([x_start_m x_end_m 0 1400])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
            
        figure(5)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.Radiation_Long_inc)
        title('Long wave incoming Radiation')
        axis([x_start_m x_end_m 0 800])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
        figure(6)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.Radiation_Long_out)
        title('Long wave outgoing Radiation')
        axis([x_start_m x_end_m 0 800])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
        figure(7)
        plot(Values.Minutes.Time_Minutes,Values.Minutes.PT100)
        title('PT100')
        axis([x_start_m x_end_m 10 60])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
    %Soil Heat Flux Plates
        figure(9)
        plot(Values.Minutes.Time_Minutes    ,Values.Minutes.Soil_Heat_Flux(:,1), ...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Soil_Heat_Flux(:,2), ...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Soil_Heat_Flux(:,3))
        title('Soil Heat Flux Plates')
        axis([x_start_m x_end_m -200 200])
        legend('Sun','Intermediate','Shadow','Location','Best')
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
    %Thermistors
        figure(10)
        plot(Values.Minutes.Time_Minutes    ,Values.Minutes.Thermistor(:,1), ...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Thermistor(:,2), ...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Thermistor(:,3), ...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Thermistor(:,4))
        title('Thermistors')
        legend('Shadow high','Shadow low', 'Sun High', 'Sun low','Location','Best');
        axis([x_start_m x_end_m 10 60])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
    %wind
        figure(11)
        subplot(2,1,1)
            plot(Values.Minutes.Time_Minutes    ,Values.Minutes.Wind_direction)
            title('Winddirection')
            axis([x_start_m x_end_m 0 360])
            set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
            grid on
        subplot(2,2,3)
            [x1,y1]                             = pol2cart(Values.Minutes.Wind_direction/180*pi,100,...
                                                           Values.Minutes.Wind_speed_high);

            title('Winddirection and Windspeed high')
            polar(2*pi-Values.Minutes.Wind_direction/180*pi,Values.Minutes.Wind_speed_high,'x')
            view(-90,90)    
        subplot(2,2,4)
            rose(2*pi-Values.Minutes.Wind_direction/180*pi,20)
            
        figure(12)
        plot(Values.Minutes.Time_Minutes    ,Values.Minutes.Wind_speed_high,...
             Values.Minutes.Time_Minutes    ,Values.Minutes.Wind_speed_low)
        title('Windspeed')
        legend('Windspeed High','Windspeed low','Location','Best')
        axis([x_start_m x_end_m 0 10])
        set(gca,'XTick',markers_position_m,'XTickLabel',markers_label_c_m)
        grid on
        
    %scintillometer output
        figure(13)
        plot(Values.Seconds.Time_Seconds   , Values.Seconds.UCN2   ,'b' , ...
             Values.Minutes.Time_Minutes*60, Values.Minutes.UCN2_av,'r')
        title('Scintillometer Signal')
        axis([x_start_s x_end_s -4 0])
        legend('1 Hz Scintilations','1 Minute Average of 1 Hz Scintilations','Location','Best')
        set(gca,'XTick',markers_position_s,'XTickLabel',markers_label_c_s)
        grid on
        
        figure(14)
        plot(Values.Seconds.Time_Seconds    ,Values.Seconds.Demod     ,'b' , ...
             Values.Minutes.Time_Minutes*60 ,Values.Minutes.Demod_av  ,'r')
        title('Scintillometer Carrier')
        axis([x_start_s x_end_s -0.3 0])
        legend('1 Hz Scintilations','1 Minute Average of 1 Hz Scintilations','Location','Best')
        set(gca,'XTick',markers_position_s,'XTickLabel',markers_label_c_s)
        grid on
end