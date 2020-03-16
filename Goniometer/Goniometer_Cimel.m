function [Data]  =   Goniometer_Cimel(Data)

Data.Files.Cimel =   dir('*Cimel*');

if ~isempty(Data.Files.Cimel)
    Data.Files.Cimel_Indicator   =   1;
    
    [raw, txt, Data.Cimel.Raw]  =   xlsread(Data.Files.Cimel.name);
    Data.Cimel.Data_Filter      =   raw(1,2:end);
    Data.Cimel.Data_Band_Pass   =   raw(2,2:end);
    Data.Cimel.Data_Temperature =   raw(4:end,2:end);
    
    if size(Data.Cimel.Data_Temperature,1)<15
        Data.Cimel.Data_Temperature =   [zeros(1,size(Data.Cimel.Data_Temperature,2))   ;...
                                         Data.Cimel.Data_Temperature                    ;...
                                         zeros(1,size(Data.Cimel.Data_Temperature,2))];
    end
    
else
    Data.Files.Cimel             =   'No file selected';
    Data.Files.Cimel_Indicator   =   0;
end