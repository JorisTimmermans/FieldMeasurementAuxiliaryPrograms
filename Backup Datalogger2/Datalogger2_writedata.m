function Datalogger2_writedata(Values)

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
                filename =   'MR23X_total';
            case 'Daily'
                filename =   ['MR23X_',Values.Files.Directory(18:31)];
        end        
        [filename, pathname] = uiputfile('.*','Save Data',filename);
        cd(pathname)
        save([filename,'.dat'],'ValuesMinutes','-ASCII','-TABS');        
        save([filename,'.mat'],'Values');
        fid = fopen([filename,'.txt'],'w');
        fprintf(fid,'%s\r\n'  ,'Metadata for the data of the MR23X for the NTC measurements');
        fprintf(fid,'%s\r\n','==================================');
        fprintf(fid,'\r\n%s\r\n','Position of NTC`s');
            fprintf(fid,'%s\r\n',['  ','39-03-58.1 N']);
            fprintf(fid,'%s\r\n',['  ','02-06-01.7 W']);
        fprintf(fid,'\r\n%s\r\n','position of sensors');
            fprintf(fid,'%s\r\n',['  ','pressure : inside the box of logger, height (0.5 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 1 :  Sunny side of young leaves, height (1.2 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 2 :  Shady side of young leaves, height (1.2 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 3 :  Shady side of old   leaves, height (1.2 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 4 :  Sunny side of old   leaves, height (1.2 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 5 :  Sunny side of old   leaves, height (0.5 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 6 :  Shady side of old   leaves, height (0.5 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 7 :  Sunny side of young leaves, height (0.5 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 8 :  Shady side of young leaves, height (0.5 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 9 :  Shady side on the ground,   height (0.0 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 10 : Shady side on the ground,   height (0.0 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 11 : Sunny side on the ground,   height (0.0 m)']);
            fprintf(fid,'%s\r\n',['  ','NTC 12 : Sunny side on the ground,   height (0.0 m)']);
            fprintf(fid,'%s\r\n',['  ','SHF 1 : No measurements done with Soil Heat Flux plates']);
            fprintf(fid,'%s\r\n',['  ','SHF 2 : No measurements done with Soil Heat Flux plates']);
            fprintf(fid,'%s\r\n',['  ','SHF 3 : No measurements done with Soil Heat Flux plates']);
            fprintf(fid,'%s\r\n',['  ','SHF 4 : No measurements done with Soil Heat Flux plates']);
            fprintf(fid,'%s\r\n',['  ','VWC 1 : No measurements done with Volumetric Water Content']);
            fprintf(fid,'%s\r\n',['  ','VWC 2 : No measurements done with Volumetric Water Content']);
            fprintf(fid,'%s\r\n',['  ','VWC 3 : No measurements done with Volumetric Water Content']);
            fprintf(fid,'%s\r\n',['  ','VWC 4 : No measurements done with Volumetric Water Content']);
        fprintf(fid,'\r\n%s\r\n','Crop parameters');
            fprintf(fid,'%s\r\n',['  ','Top Height Vineyard Crops :             1.50 m']);
            fprintf(fid,'%s\r\n',['  ','Bottom Height Vineyard Crops :          0.40 m']);
            fprintf(fid,'%s\r\n',['  ','Separation of Vineyard Crops per row :  3.00 m']);
            fprintf(fid,'%s\r\n',['  ','Separation of Vineyard rows :           3.00 m']);
            fprintf(fid,'%s\r\n',['  ','Dripping Irrigation']);
            fprintf(fid,'%s\r\n',['  ','Distance Irrigation vs Vineyard Crops:  0.75 m']);
            fprintf(fid,'%s\r\n',['  ','Distance Irrigation vs Irrigation:      0.75 m']);
            
            
            fprintf(fid,'\r\n%s','==================================');
        fprintf(fid,'\r\n%s\r\n','Name of Variables in the datafile');
        for j=[2,4:size(Values.Minutes.Names)]
            fprintf(fid,'%s\r\n',['  ',cell2mat(Values.Minutes.Names(j))]);
        end
        fclose(fid)       
        
    case 'No'
end