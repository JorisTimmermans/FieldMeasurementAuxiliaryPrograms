function    [Values]  =   Datalogger_Correction(Values);

%The Logger has also logt the time on which the sensors were being connected, which results in spikes. These spikes
%cannot be interpolated, and therefore have to be removed! to be corrected
time_cutoff_minutes =   0;
time_cutoff_seconds =   sum(Values.Minutes.N(1:time_cutoff_minutes));

if max(Values.Minutes.Time_Minutes<274818)
    for j=1:size(Values.Seconds.Names,1)
        Values.Seconds.(cell2mat(Values.Seconds.Names(j)))  =   ...
                                    Values.Seconds.(cell2mat(Values.Seconds.Names(j)))(time_cutoff_seconds + 1:end,:);
    end
    Values.Files.SizeDatablock_Seconds(1)       =   Values.Files.SizeDatablock_Seconds(1) - time_cutoff_seconds;
    
    for j=1:size(Values.Minutes.Names,1)
        Values.Minutes.(cell2mat(Values.Minutes.Names(j)))  =   ...
                                    Values.Minutes.(cell2mat(Values.Minutes.Names(j)))(time_cutoff_minutes + 1:end,:);
    end
    Values.Files.SizeDatablock_Minutes(1)       =   Values.Files.SizeDatablock_Minutes(1) - time_cutoff_minutes;
end

%Correct Net Radiometer for Black Body Radiation
Values.Minutes.('Radiation_Black_Body')  =   5.67e-8 * (Values.Minutes.('PT100') + 273.18).^4;
Values.Minutes.('Radiation_Long_inc')    =   Values.Minutes.('Radiation_Long_inc') + ... 
                                             Values.Minutes.('Radiation_Black_Body');
Values.Minutes.('Radiation_Long_out')    =   Values.Minutes.('Radiation_Long_out') + ... 
                                             Values.Minutes.('Radiation_Black_Body');
question    =   questdlg(['How interpret Spikes in the Data'],'Timedifference','Interpolate','Ommit','Interpolate'); 
switch question
    case 'Interpolate',
        index2=1;
    case 'Ommit',
        index2=0;
end
%Despiking Time
%Since the spikes in time are caused by the reading of the logger, the spikes occur at every sensor 
%(as the machine is off), it therefore impossible to interpolate those data.. and therefore, we will 
%not be bothered.
index   =   find(Values.Minutes.('Time_Minutes')< 2.7e5 | ...
                 Values.Minutes.('Time_Minutes')> 2.9e5 );
for j=2:6
     Values.Minutes.(cell2mat(Values.Minutes.Names(j)))(index)              =   NaN;  
end

Index   =   [7  , 8  , 9  , 10  , 11   , 12,  13  , 14  , 15  , 16  , 17, 18, 19, 20 , 21 , 22 , 23, 24, 25  , 26, 27, 28];
Min     =   [-60, -60, 0  , 0   , 0   , 0 ,  -100, -100, -100, -100, 10, 10, 10, 0  , 0  , 0  , 0 , 0 , -165, 10, 10, 0 ];
Max     =   [0  , 0  , 0.1, 5e-4, 751 , 61,  1300, 1300, 1000, 1000, 65, 65, 65, 100, 100, 360, 20, 20, 500 , 65, 65, 15];
for j=1:size(Index,2)
    index   =   find(Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))> Max(j) | ...
                     Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))< Min(j) );    
    if ~isempty(index)        
        Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))(index)            =   NaN;
        if index2            
        index(find(index==1))                                                       =   [];
        Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))(index)            =   ...
                                      0.5*Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))(index - 1) + ...
                                      0.5*Values.Minutes.(cell2mat(Values.Minutes.Names(Index(j))))(index + 1) ;
        end
    end
end

%create time-index for the 1Hz data
index   =   0;
sum1    =   0;
[Values.Seconds.Time_Hours          ,...
 Values.Seconds.Time_Day_Nums       ,...
 Values.Seconds.Time_Seconds            ]     =   deal(zeros(size(Values.Seconds.ID)));
h = waitbar(0,'Creating time-index for the 1Hz data');
for j=1:size(Values.Minutes.N,1)
    index                                               =   1:Values.Minutes.N(j);
    Values.Seconds.Time_Hours           (sum1 + index)  =   Values.Minutes.Time_Hours(j);
    Values.Seconds.Time_Day_Nums        (sum1 + index)  =   Values.Minutes.Time_Day_Nums(j);
    Values.Seconds.Time_Seconds         (sum1 + index)  =   60*Values.Minutes.Time_Minutes(j) + index - 60;
    sum1                                                =   sum1 + max(index);
    waitbar(j/size(Values.Minutes.N,1),h)
end
close(h)

Index   =   [2    , 3 ];
Min     =   [-10, -0.2];
Max     =   [0  , 0   ];
for j=1:size(Index,2)
    index   =   find(Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))> Max(j) | ...
                     Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))< Min(j) );
    Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))(index)              =   NaN;
    if ~isempty(index) & index2
        Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))(index)          =   ...
                                      0.5*Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))(index - 1) + ...
                                      0.5*Values.Seconds.(cell2mat(Values.Seconds.Names(Index(j))))(index + 1) ;
    end
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Time markers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Values.Minutes.Time_Hours_Minutes   =   Values.Minutes.Time_Hours*60;
Values.Minutes.Time_Start           =   min(Values.Minutes.('Time_Minutes'));
Values.Minutes.Time_End             =   max(Values.Minutes.('Time_Minutes'));
Values.Seconds.Time_Start           =   min(Values.Seconds.('Time_Seconds'));
Values.Seconds.Time_End             =   max(Values.Seconds.('Time_Seconds'));