function [Values] =   Datalogger_main
clc
close all

question    =   questdlg(['How do you want to study the data'],'Timedifference','Daily','Total','Total');    
pause(0.1)
Values.Files.Homedir     =   cd;
Values.Files.Startdir    =   'd:\data\sun2Flex\';
path(path,'C:\Program Files\Matlab\Barrax\Datalogger')
cd(Values.Files.Startdir)
Values2                 =   [];
        switch question
            case 'Daily',
                Values.Files.Directory = uigetdir('', 'Pick the Thermal imagery file');
                if min(Values.Files.Directory~=0)
                    Values.Files.File   =   'C23x.dat';
                    cd(Values.Files.Directory)
                    Values.Files.ID     =   'Daily';
                    Values              =   Datalogger_retreive_data(Values,Values2);
                end
                clear Values2 j
            case 'Total',
                Values.Files.ID         =   'Total';
                Values.Files.File       =   'C23x.dat';
                Values.Files.Directory  =   dir('*2005*');
                for j = 1:size(Values.Files.Directory,1)
                    cd([Values.Files.Directory(j).name,'/Logger'])                    
                    if min(Values.Files.File~=0)                        
                        Values  =   Datalogger_retreive_data(Values,Values2);
                        Values2 =   Values;
                    end
                    cd (Values.Files.Startdir);
                end
                clear Values2                
            case ''
                Values.Files.ID     =   'Error';
                Values.Files.File   =   'Error, no file chosen';          
                clear Values2 j
        end
        clear question
switch Values.Files.ID
    case 'Error'
        %no data so no function will be executed
    case {'Total' , 'Daily'}
        Values  =   Datalogger_correction(Values);
        Datalogger_plotdata(Values);
        Datalogger_writedata(Values);
end
cd (Values.Files.Homedir)
close all