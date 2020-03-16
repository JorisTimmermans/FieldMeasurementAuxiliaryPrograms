function [Data]  =   Goniometer_Combine_datastreams_Everest(Data)
Data.Files.Everest_File    =   dir('*Everest*.txt');

if ~isempty(Data.Files.Everest_File)
    Data.Files.Everest_Indicator        =   3;
    Data.Everest.Raw_Data               =   load(Data.Files.Everest_File.name);
    
%     Data.Everest.Raw_matrix             =   eye(size(Data.Everest.Raw_Data,1));
%     Data.Everest.Raw_matrix(find(Data.Everest.Raw_matrix)) =   Data.Everest.Raw_Data;   
    
else
    Data.Files.EverestFile         =   'No file selected';
    Data.Files.Everest_Indicator    =   0;
end