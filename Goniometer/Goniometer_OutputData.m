function [Data] = Goniometer_Outputdata(Data)
homedir = cd;
cd('D:\Data\SEN2FLEX2005\Data Output\Goniometer Output')
close all


if Data.Files.Serial_Indicator~=0
    subTitle   =   [Data.Serial.Time_Start_Day      ,'_'                    ,...
                    Data.Serial.Time_Start_Time(1:2),'-'                    ,...
                    Data.Serial.Time_Start_Time(4:5)];
    datetext    =  [Data.Serial.Time_Start_Day      ,' '                    ,...
                    Data.Serial.Time_Start_Time(1:2),':'                    ,...
                    Data.Serial.Time_Start_Time(4:5)];
elseif Data.Files.ThermoTracer_Indicator==1
    subTitle    =   [datestr(Data.ThermoTracer.Date(1),'dd-mm-yyyy'),'_'    ,...
                     datestr(Data.ThermoTracer.Time(1),'HH-MM')];
    datetext    =   [datestr(Data.ThermoTracer.Date(1),'dd-mm-yyyy'),' '    ,...
                     datestr(Data.ThermoTracer.Time(1),'HH:MM')];
else
    subTitle    =   [];
end


if Data.Files.Position_Indicator~=0 & Data.Files.Serial_Indicator~=0
    Text                    =   [{ Data.Position.Crop}                                                          ;...
                                 {datetext}                                                                     ;...
                                 {Data.Position.Coordinates_LatLon}];
elseif Data.Files.Position_Indicator==0 & Data.Files.Serial_Indicator~=0
    Text                    =   datetext;
elseif Data.Files.Position_Indicator~=0 & Data.Files.Serial_Indicator==0
    Text                    =   [{ Data.Position.Crop}                                                          ;...
                                 {datetext}                                                                     ;...
                                 {Data.Position.Coordinates_LatLon}];
else
    Text                    =   [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Everest and Cimel Data Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Preparing Data
if Data.Files.Everest_Indicator ==3 & Data.Files.Cimel_Indicator ==1
    zz      =   [Data.Cimel.Data_Temperature,Data.Everest.Raw_Data/10;zeros(4,7)];
    loop    =   size(Data.Cimel.Data_Temperature,2) + 1;
    filterpass  =   [Data.Cimel.Data_Filter-Data.Cimel.Data_Band_Pass/2,8       ;...
                     Data.Cimel.Data_Filter+Data.Cimel.Data_Band_Pass/2,14]';                     
    files   =   [{['Cimel 312']};{['Cimel 312']};{['Cimel 312']};               ...
                 {['Cimel 312']};{['Cimel 312']};{['Cimel 312']};{['Everest']}];
elseif Data.Files.Everest_Indicator ~=3 & Data.Files.Cimel_Indicator ==1
    zz      =   [Data.Cimel.Data_Temperature;zeros(4,6)];
    loop    =   size(Data.Cimel.Data_Temperature,2);    
    filterpass  =   [Data.Cimel.Data_Filter-Data.Cimel.Data_Band_Pass/2;...
                     Data.Cimel.Data_Filter+Data.Cimel.Data_Band_Pass/2]';
    files   =   [{['Cimel 312']};{['Cimel 312']};{['Cimel 312']};               ...
                 {['Cimel 312']};{['Cimel 312']};{['Cimel 312']}];
elseif Data.Files.Everest_Indicator ==3 & Data.Files.Cimel_Indicator ~=1
    zz      =   [Data.Everest.Raw_Data;0;0;0;0]/10;
    loop    =   1;
    filterpass  =   [8,14];
    files   =   {['Everest']};
else
    loop=0;
end
% 
% if Data.Files.ASD_Indicator ==3
%     loop        =   1;
%     zz          =   [Data.ASD.NDVI';0;0;0;0];
%     filterpass  =   [0.5 0.9]
%     files       =   {['NDVI by ASD spectrometer']};
% end

%plotting Data
for j=1:loop
    z       =   zz(:,j);
    filename=   [cell2mat(files(j)),'(bandpass filter of ',num2str(filterpass(j,1)),'-',num2str(filterpass(j,2)),')'];
    titles  =   ['Goniometric Measurement with ',filename(1:end-1),'\mum)'];   
    
    try
        %measurements
        x   =   [Data.Scanroute.Coordinates_north_extra(:,1)];
        y   =   [Data.Scanroute.Coordinates_north_extra(:,2)];

        phaseplot.figure   =   figure(j);
        hold on
        [v, c] = voronoin([x,y]);
        for jj = 1:length(c) 
            if all(c{jj}~=1)   % If at least one of the indices is 1, 
                              % then it is an open region and we can't 
                              % patch that.
                patch(v(c{jj},1),v(c{jj},2),z(jj)); % use color i.
            end
        end
        colormap(autumn)
        set (phaseplot.figure,'Position',[50 100 800 600])
        caxis([19 46])
        phaseplot.colorbar                      =   colorbar;        
        markers_position        =   20:5:45;
        markers_label           =   [num2str(markers_position'), char(67*ones(size(markers_position')))];        
        markers_position_x      =   unique(Data.Scanroute.Coordinates(:,1));                        %Axis are hidden
        markers_position_y      =   unique(Data.Scanroute.Coordinates(:,2));                        %Axis are hidden
        markers_label_x         =   (acos(unique(Data.Scanroute.Coordinates(:,1)))-1/2*pi)/pi*180;  %Axis are hidden
        markers_label_y         =   (acos(unique(Data.Scanroute.Coordinates(:,2)))-1/2*pi)/pi*180;  %Axis are hidden
        phaseplot.datapoints    =   plot3(x(1:end-4),y(1:end-4),z(1:end-4)/10,'o');                 %Axis are hidden
        phaseplot.currentaxis   =   gca;
        
        phaseplot.xlabel        =   xlabel('Angle \theta ( ^0 )');                                  %Axis are hidden
        phaseplot.ylabel        =   ylabel('Angle \psi ( ^0 )');                                    %Axis are hidden
        phaseplot.text          =   text(0.3,-0.9,Text);
        phaseplot.title         =   title(titles);
        axis tight, axis off

        %angle difference between the figure en real life%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        angle_rad               =   angle(x+i*y);
        start_angle_fig_rad     =   angle_rad(1);                                  %angle as it makes in the figure
        start_angle_fld_rad     =   str2num(Data.Position.Orientation(1:3))/180*pi;%angle as it makes in the field to N
        diff_angle_rad          =   start_angle_fld_rad-start_angle_fig_rad;

        %plant orientation
        crop_angle_deg          =   str2num(Data.Position.Crop_Orientation(1:3));   
        crop_angle_rad          =   crop_angle_deg/180*pi;
        crop_angle_rad_north    =   pi/2 - crop_angle_rad;           %northangle is pi/2
        [cx,cy]                 =   pol2cart(crop_angle_rad_north,1);
        h10                     =   line([-cx cx],[-cy cy],[2 2]);
        set(h10,'LineWidth',[2.0],'Color',[0.2 0.4 0.3]);

        %North Orientation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        n0x                     =   0.78;
        n0y                     =   0.70;
        north_angle_rad         =   pi/2;
        [nvx,nvy]               =   pol2cart(north_angle_rad,1);
        phaseplot.northarrow                      =   annotation('textarrow',[0,nvx]*.1+n0x,[0,nvy]*.1+n0y);  
        %Sun%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [sx,sy,sz]              =   sph2cart(Data.Solar.Azimuth + pi/2  ,...
                                             Data.Solar.Altitude ,...
                                             1);
        phaseplot.sunposition                      =   plot3(sx,sy,sz,'whiteh');
        %set font for ppt/latex/word/output
        set(phaseplot.colorbar      ,'YTick',markers_position,'YTickLabel',markers_label,'Fontsize',14);
        set(phaseplot.xlabel        ,'Fontsize',14);
        set(phaseplot.ylabel        ,'Fontsize',14);    
        set(phaseplot.text          ,'Fontweight','bold');
        set(phaseplot.title         ,'Fontsize',14);
        set(phaseplot.currentaxis   ,'XTick',markers_position_x,'XTickLabel',markers_label_x);                           %Axis are hidden
        set(phaseplot.currentaxis   ,'YTick',markers_position_y,'YTickLabel',markers_label_y);                           %Axis are hidden
        set(phaseplot.datapoints    ,'Markersize',12,'MarkerFaceColor','blue','MarkerEdgeColor','blue')
        set(phaseplot.northarrow    ,'Headstyle','cback2','HeadWidth',20,'HeadLength',15,'LineWidth',3,'String',...
                                     'N','Fontsize',25,'FontWeight','Bold')    
        set(phaseplot.sunposition   ,'Markersize',25,'MarkerFaceColor','white','MarkerEdgeColor','white')
        saveas(gcf,[filename,' on ',subTitle,'.jpg'], 'jpg')
        saveas(gcf,[filename,',',subTitle,'.eps'], 'psc2')
    catch
    end
end
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ASD               Data Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Preparing Data
% keyboard
if Data.Files.ASD_Indicator==3 
pause(0.1)
h = waitbar(0,'Calculating the Final data...');
% markers_position            =   linspace(10,45,8);
% markers_label               =   [num2str(markers_position'), char(75*ones(size(markers_position')))];
for j=1:15    
    Texts                   =   [Text;{['Angular Position(',num2str(j),')']}];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    ASDimages.figure        =   figure(j);
    ASDimages.axes          =   axes;
    ASDimages.plot          =   plot(Data.ASD.Wavelength,Data.ASD.Measurements(:,j));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    ASDimages.title         =   title(['Goniometric measurement with ASD Spectrometer, at angle ', num2str(j)]);
    ASDimages.xlabel        =   xlabel('Wavelength ( nm )');
    ASDimages.ylabel        =   ylabel('DN Values ( )');
    ASDimages.text          =   text(1,1,Texts);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     axis off;
%     axis equal;
%     set(ASDimages.axes_figure    ,'Clim',[10 45])
%     set(ASDimages.colorbar       ,'Ylim',[10 45])
%     set(ASDimages.colorbar       ,'YTick',markers_position,'YTickLabel',markers_label,'Fontsize',14);

    set(ASDimages.figure        ,'Position' ,[50 100 800 600])
    set(ASDimages.axes          ,'Xlim'     ,[0 max(Data.ASD.Wavelength)]                                       ,...
                                 'Ylim'     ,[0 max(max(Data.ASD.Measurements))]                                ,...
                                 'Fontsize' ,14)
    set(ASDimages.text          ,'Units'    ,'pixels','Position',[10 40],'Fontweight','bold');
    set(ASDimages.xlabel        ,'Fontsize' ,14);
    set(ASDimages.ylabel        ,'Fontsize' ,14);
    set(ASDimages.title         ,'Fontsize' ,14);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    pause(0.3)
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    saveas(ASDimages.figure,['ASD_Spectrometer_',subTitle,' position ',num2str(j),'.tiff'], 'tiff') 
    saveas(ASDimages.figure,['ASD_Spectrometer_',subTitle,' position ',num2str(j),'.eps'], 'psc2')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    waitbar(j/size(Data.Scanroute.Coordinates,1),h) ;    
end
close(h)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Irysis and Thermo Tracer Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%preparing Data
if Data.Files.ThermoTracer_Indicator ==1 & Data.Files.Thermal_Imager_Indicator ==3
    zz      =   [Data.ThermoTracer.Raw,Data.Thermal_Imager.Raw_Data/10;zeros(4,7)]
    loop1   =   size(Data.ThermoTracer.Raw,3);
    loop2   =   size(Data.Thermal_Imager.Raw,3);
    loop    =   loop1 + loop2;
    files   =   [{['Irisys 1011']};{['Thermo Tracer TH9100 PRO']}]
    [files((1:loop1)      ,:)]  =   deal([{['Thermo Tracer TH9100 PRO']}]);
    [files((1:loop2)+loop1,:)]  =   deal([{['Irisys 1011']}]);
elseif Data.Files.ThermoTracer_Indicator ~=1 & Data.Files.Thermal_Imager_Indicator ==3
    zz                      =   Data.Thermal.Interpolated;
    zz                      =   zz(1:end-8,1:end-8,:);
    loop                    =   size(Data.Thermal.Interpolated,3);    
    [files(1:loop,:)]       =   deal([{['Irisys 1011']}]);
elseif Data.Files.ThermoTracer_Indicator ==1 & Data.Files.Thermal_Imager_Indicator ~=3
    zz                      =   Data.ThermoTracer.Raw;
    zz(zz<10)               =   10;
    loop                    =   size(Data.ThermoTracer.Raw,3);
    [files(1:loop,:)]       =   deal([{['Thermo Tracer TH9100']}]);
else
    loop                    =   0;
end

%plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Imager Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(0.1)
h = waitbar(0,'Calculating the Final data...');
markers_position            =   linspace(10,45,8);
markers_label               =   [num2str(markers_position'), char(67*ones(size(markers_position')))];
for j=1:loop    
    Texts                   =   [Text;{['Angular Position(',num2str(j),')']}];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    tracerimages.figure     =   figure(j);
    tracerimages.axes_figure=   axes('Visible','off');
    tracerimages.image      =   image(zz(:,:,j),'CDataMapping','scaled');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    tracerimages.colorbar   =   colorbar;
    tracerimages.title      =   title(['Goniometric measurement with ', cell2mat(files(j)),' at angle ', num2str(j)]);
    tracerimages.text       =   text(1,1,Texts);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    colormap autumn
    axis off;
    axis equal;
%     set(tracerimages.axes_figure    ,'Clim',[10 45])
%     set(tracerimages.colorbar       ,'Ylim',[10 45])
    set(tracerimages.figure         ,'Position',[50 100 800 600])
    set(tracerimages.colorbar       ,'YTick',markers_position,'YTickLabel',markers_label,'Fontsize',14);
    set(tracerimages.text           ,'Units','pixels','Position',[349 36],'Fontweight','bold');
    set(tracerimages.title          ,'Fontsize',14);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    pause(0.3)
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    saveas(tracerimages.figure,[cell2mat(files(j)),'_',subTitle,' position ',num2str(j),'.tiff'], 'tiff') 
    saveas(tracerimages.figure,[cell2mat(files(j)),'_',subTitle,' position ',num2str(j),'.eps'], 'psc2')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    waitbar(j/size(Data.Scanroute.Coordinates,1),h) ;    
end
close(h)

save(['Goniometric Measurements of ',subTitle],'Data')
close all
cd(homedir)

