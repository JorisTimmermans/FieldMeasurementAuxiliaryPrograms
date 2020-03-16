% plot(   Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,1)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,2)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,3)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,4)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,5)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,6)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,7)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,8)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,9)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,10)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,11)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,12)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,13)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,14)                  ,...    
%         Data.ASD.Wavelength,Data.ASD.Measurements(:,i)./Data.ASD.Measurements(:,15));

channel1_index    =   find(580<Data.ASD.Wavelength & Data.ASD.Wavelength<0680);    %Channel 1 (0.580 - 0.68 microns) (AVHHR)
channel2_index    =   find(725<Data.ASD.Wavelength & Data.ASD.Wavelength<1000);    %Channel 2 (0.725 - 1.00 microns) (AVHHR)

channel1_index    =   find(630<Data.ASD.Wavelength & Data.ASD.Wavelength<0690);    %Band 3 0.63-0.69 µm (Landsat)
channel2_index    =   find(760<Data.ASD.Wavelength & Data.ASD.Wavelength<0900);    %Band 4 0.76-0.90 µm (Landsat)
figure(100)
hold on;
for j=1:15    
    plot(Data.ASD.Wavelength                ,   Data.ASD.Measurements(:             ,j)     ,'y');
    plot(Data.ASD.Wavelength(channel1_index),   Data.ASD.Measurements(channel1_index,j)     ,'r');
    plot(Data.ASD.Wavelength(channel2_index),   Data.ASD.Measurements(channel2_index,j)     ,'g');

    Data.ASD.Bandwidth  =   Data.ASD.Wavelength(2)-Data.ASD.Wavelength(1);
    channel1            =   sum(Data.ASD.Measurements(channel1_index,j)*Data.ASD.Bandwidth);
    channel2            =   sum(Data.ASD.Measurements(channel2_index,j)*Data.ASD.Bandwidth);

    Data.ASD.Derived_NDVI(j) = (channel2-channel1)/(channel2+channel1);
    title(['NDVI = ', num2str(Data.ASD.Derived_NDVI(j))]);
end

if Data.Files.ASD_Indicator ==3
    loop        =   1;
    zz          =   [Data.ASD.NDVI';0;0;0;0];
    filterpass  =   [0.5 0.9]
    files       =   {['ASD spectrometer of NDVI']};
end

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
        caxis([0 1])
        phaseplot.colorbar                      =   colorbar;        
        markers_position        =   linspace(0,1,6);
        markers_label           =   [num2str(markers_position'), char(75*ones(size(markers_position')))];        
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
% close all

%per angle
figure
plot(Data.ASD.Derived_NDVI)

%per angle line
figure
ii      =   find(Data.Scanroute.Coordinates(:,1)==0)
angles  =   Data.Scanroute.Coordinates(ii,2);
[j,k]   =   sort(angles);
plot(Data.Scanroute.Coordinates(ii(k),2),Data.ASD.Derived_NDVI(ii(k)))
ylim([0 1])
title('per angle line1 ')


%per angle line
figure
ii       =   find(Data.Scanroute.Coordinates(:,2)==0)
angles  =   Data.Scanroute.Coordinates(ii,1);
[j,k]   =   sort(angles)
plot(Data.Scanroute.Coordinates(ii(k),1),Data.ASD.Derived_NDVI(ii(k)))
ylim([0 1])
title('per angle line 2')

%per height
figure
plot(Data.Scanroute.Coordinates(:,3),Data.ASD.Derived_NDVI,'x')
ylim([0 1])
title('per h')