function [Values] =   Datalogger2_main
clc
close all
clear all

question    =   questdlg(['How do you want to study the data'],'Time','Daily','Total','Total');    
pause(0.1)
Values.Files.Homedir     =   cd;
Values.Files.Startdir    =   'd:\data\SEN2FLEX2005\\';
path(path,'C:\Program Files\Matlab\Barrax\Datalogger2')
cd(Values.Files.Startdir)
Values2                 =   [];
Values.Files.ID         =   question;
switch question
    case 'Daily',
            Values.Files.Directory = uigetdir('', 'Pick the directory where the file is located');
            if min(Values.Files.Directory~=0)
                cd(Values.Files.Directory)
                if size(dir ('*.dat'),1)>1
                    Values.Files.File   =   'MR23X.dat';                    
                    Values              =   Datalogger2_retreive_data(Values,Values2);                    
                else
                    Values.Files.File   =   'Error, no file chosen';
                end                
            end            
        case 'Total',
             Values.Files.File       =  'MR23X.dat';
             Values.Files.Directory  =  dir('*2005*');
             selected                =  listdlg('PromptString' ,'Select a directory`s:',...
                                               'SelectionMode','multiple',...
                                               'ListString'   ,{Values.Files.Directory.name});
            Values.Files.Directory  =   Values.Files.Directory(selected);
             for j = 1:size(Values.Files.Directory,1)
                 cd([Values.Files.Directory(j).name,'/Logger'])
                 if size(dir ('*.dat'),1)>1
                     Values  =   Datalogger2_retreive_data(Values,Values2);
                     Values2 =   Values;
                 end
                 cd (Values.Files.Startdir);
             end                      
        case ''
             Values.Files.ID     =   'Error';
             Values.Files.File   =   'Error, no file chosen';
end
clear Values2 question j

% keyboard
switch Values.Files.ID
    case {'Daily','Total'}
        Values  =   Datalogger2_correction(Values);
        Datalogger2_plotdata(Values);
        Datalogger2_writedata(Values);
    case ''
        %no data file is chosen, so no calculations can be made
end
close all
cd(Values.Files.Homedir)