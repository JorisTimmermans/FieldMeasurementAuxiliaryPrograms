function Datalogger_writedata(Values)

question    =   questdlg(['Do you want to save the data to file?'],'Write Data','Yes','No','Yes');    
switch question
    case 'Yes'
                
        ValuesMinutes       =       [];
        ValuesMinutesNames  =       [];
        for j=[2,4:size(Values.Minutes.Names)]
            for jj=1:size(Values.Minutes.(cell2mat(Values.Minutes.Names(j))),2)
                ValuesMinutesNames  =   [ValuesMinutesNames ,   Values.Minutes.Names(j)];
                ValuesMinutes       =   [ValuesMinutes , Values.Minutes.(cell2mat(Values.Minutes.Names(j)))(:,jj)];
            end
        end
                        
        switch Values.Files.ID
            case 'Total'
                filename =   'C23X_total';
            case 'Daily'
                filename =   ['C23X_',Values.Files.Directory(18:31)];
        end        
        [filename, pathname] = uiputfile('.*','Save Data',filename);
        cd(pathname)
        save([filename,'.dat'],'ValuesMinutes','-ASCII','-TABS');        
        save([filename,'.mat'],'Values');
        fid = fopen([filename,'.txt'],'w');
        fprintf(fid,'%s\r\n'  ,'Metadata for the data of the CR23X on the basetower')
        fprintf(fid,'%s\r\n','==================================')
        fprintf(fid,'\r\n%s\r\n','Position of base tower')
            fprintf(fid,'%s\r\n',['  ','39-03-37.6 N']);
            fprintf(fid,'%s\r\n',['  ','02-06-09.5 W']);
        fprintf(fid,'%s\r\n','Position of transmitter tower')
            fprintf(fid,'%s\r\n',['  ','39-03-14.5 N']);
            fprintf(fid,'%s\r\n',['  ','02-05-59.5 W']);    
        fprintf(fid,'\r\n%s\r\n','Heights of sensors')
            fprintf(fid,'%s\r\n',['  ','Scintillometer :            5.060 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Net-radiometer :            4.880 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Wind direction :            4.880 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Windspeed high :            4.880 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Windspeed low :             2.600 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Relative Humidity high :    4.780 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Relative Humidity low :     2.600 m']);   %(old data)
            fprintf(fid,'%s\r\n',['  ','Thermistor 1 :              0.005 m @ 1.50 m from vines']);
            fprintf(fid,'%s\r\n',['  ','Thermistor 2 :              0.015 m @ 1.50 m from vines']);
            fprintf(fid,'%s\r\n',['  ','Thermistor 3 :              0.005 m @ 0    m from vines']);
            fprintf(fid,'%s\r\n',['  ','Thermistor 4 :              0.015 m @ 0    m from vines']);
            fprintf(fid,'%s\r\n',['  ','Soil Heat Flux Plate 1 :    0.005 m @ 1.50 m from vines']);
            fprintf(fid,'%s\r\n',['  ','Soil Heat Flux Plate 2 :    0.005 m @ 0.75 m from vines']);
            fprintf(fid,'%s\r\n',['  ','Soil Heat Flux Plate 3 :    0.005 m @ 0.00 m from vines']);
        fprintf(fid,'\r\n%s','==================================')    
        fprintf(fid,'\r\n%s\r\n','Name of Variables in the datafile')
        for j=[2,4:size(Values.Minutes.Names)]
            fprintf(fid,'%s\r\n',['  ',cell2mat(Values.Minutes.Names(j))]);
        end
        fclose(fid)
        
    case 'No'
end        