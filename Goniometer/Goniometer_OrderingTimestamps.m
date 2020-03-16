function    [Data]  =   Goniometer_OrderingTimestamps(Data)
try
        datenum_serial                  =   datenum([Data.Serial.Time_Start_Day         ,...
                                                    ' '                                 ,...
                                                     Data.Serial.Time_Start_Time]       ,...
                                                     'dd-mm-yyyy HH:MM:SS');                                                 
                                                     
        datenum_thermal                 =   datenum([Data.Thermal.Time_Start_Day         ,...
                                                    ' '                                  ,...
                                                     Data.Thermal.Time_Start_Time]       ,...
                                                     'dd-mm-yyyy HH:MM:SS');
    dt  =   abs(datenum('00','MM') - datenum('01','MM'));   %1 minute allowed
    if (datenum_serial   + dt > datenum_thermal & ...
        datenum_serial   - dt < datenum_thermal ) ,
        %%%%%%%%%%%%%%%%%%%%Time in limits%%%%%%%%%%%%%%
        uiwait(msgbox(['Time difference of Serial and Thermal in limits!'],'Ok','modal')); 
        pause(0.1)
        Data.Serial.Time_Offset  =   0;        
    else
        %%%%%%%%%%%%%%%%%%%%Time difference to great%%%%%%%%%%%%%%
%         keyboard
        question    =   questdlg(['Timedifference to great, set clocks to same time?'],'Timedifference','Yes','No','Yes');
        pause(0.1)
        switch question
            case 'Yes',
                default_answer                  =   datestr(Data.Thermal.Time_Start_Time,'HH:MM:SS');
                time = inputdlg('Enter the start time for the Serial Data','Serial Data Time',1,{default_answer});
                [hours,minutes,seconds]         =   strread(cell2mat(time),'%d%d%f','delimiter',':');
                correction_seconds              =   01*(seconds                  + ...
                                                    60*(minutes                  + ...
                                                    60*(hours                    ))) + 10;
                serial_seconds                  =   01*(Data.Serial.Time_Seconds + ...
                                                    60*(Data.Serial.Time_Minutes + ...
                                                    60*(Data.Serial.Time_Hours   )));
                Data.Serial.Time_Offset         =   serial_seconds(1) - correction_seconds;                                                   
            case 'No',
                Data.Serial.Time_Offset         =   0;
                uiwait(msgbox('Time is not corrected!!!','Time','modal'));
                pause(0.1)
        end
        shifted_seconds                 =   serial_seconds      - Data.Serial.Time_Offset;
        Data.Serial.Time_Seconds        =   shifted_seconds     - 60*floor(shifted_seconds/60);
        shifted_minutes                 =   floor(shifted_seconds/60);
        Data.Serial.Time_Minutes        =   shifted_minutes     - 60*floor(shifted_minutes/60);
        Data.Serial.Time_Hours          =   floor(shifted_minutes/60);        
    end
catch
%    no
end
