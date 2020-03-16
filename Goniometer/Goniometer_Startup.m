clear all, close all, close(waitbar(0,'Starting Code...'))
clc
% global a
path('c:/program Files/Matlab/barrax/goniometer/',path);

homedir                             =   cd;
Data                                =   [];
Data.Files.Directory_Indicator      =   0;
Data.Files.Directory                =   uigetdir('d:/data/EAGLE2006/',...
                                                 'Choose the Day (not the subdirectory)');
if Data.Files.Directory~=0
    cd(Data.Files.Directory)    
    if ~isempty(dir('Goniometer'))
        cd('Goniometer')
        if ~isempty(dir('*Measurements'))
            Data.Files.Directory_Indicator =   1;
            Data.Files.Sub_Directory       =   '.';
            cd(Data.Files.Sub_Directory);
            cd ('Measurements');
        else
            subdirs =   dir('*Goniometer*');
            s       = listdlg('PromptString' ,'Select a measurement:',...
                              'SelectionMode','single',...
                              'ListString'   ,{subdirs.name});
             if ~isempty(s)
                 Data.Files.Directory_Indicator =   1;
                 Data.Files.Sub_Directory       =   subdirs(s).name;
                 cd(Data.Files.Sub_Directory);
                 cd('Measurements');                 
            end            
        end
    end    
end

clear directory_indicator s subdirs