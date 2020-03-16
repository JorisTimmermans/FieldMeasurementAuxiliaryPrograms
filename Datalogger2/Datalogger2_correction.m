function [Values]   =   Datalogger2_correction(Values)
%correcting spikes
MIN     =   [40,  40,  40,  40,  40,  40,  40,  40,  17,  17,  17,  17 ];
MAX     =   [165, 165, 165, 165, 165, 165, 165, 165, 144, 144, 144, 144];

question=   questdlg('Are the resistances measured?', 'Restistances', 'Yes','No','Yes');
switch question
    case 'Yes'
        base_resistance    =   load('Resistances.txt');
        base_resistance    =   base_resistance(:,2);
    case 'No'
        base_resistance    =   20*ones(size(MIN));%26
end % switch

% keyboard
for j=1:size(Values.Minutes.Resistance_NTC,2)
    index   =   find(Values.Minutes.Resistance_NTC(:,j)< MIN(j) | ...
                     Values.Minutes.Resistance_NTC(:,j)> MAX(j));
    Values.Minutes.Resistance_NTC(index,j)  =   NaN;
    Values.Minutes.Resistance_NTC(:,j)      =  Values.Minutes.Resistance_NTC(:,j)/20*base_resistance(j);
end

%because NTC3 has made a short during parts of its running, these short-values have to be removed!
index   =   find(Values.Minutes.Resistance_NTC(:,3)-20>Values.Minutes.Resistance_NTC(:,1) | ...
                 Values.Minutes.Resistance_NTC(:,3)+20<Values.Minutes.Resistance_NTC(:,1));
Values.Minutes.Resistance_NTC(index,3)  =   NaN;
%No Soil_Heat_Fluxes were measured

Values.Minutes.Soil_Heat_Flux           =   zeros(size(Values.Minutes.Soil_Heat_Flux));
Values.Minutes.Volume_Water_Content     =   zeros(size(Values.Minutes.Volume_Water_Content));

%Calibration
Values.Calibration.Names                =   {'NTC_Temperature';'NTC_Resistance';'NTC_Resistancelog';...
                                             'Order_Polynome';'Polynomial'};


Values.Calibration.NTC_Temperature      =   linspace(-40,100,29)';
% Values.Calibration.NTC_Resistance       =   [2664 ; 1933 ; 1421 ; 1052 ; 788.5; 594.4; 453.0; 347.6; ...
%                                              269.3; 209.7; 164.8; 130.1; 103.6; 83.00; 66.91; 54.19; ...
%                                              44.18; 36.17; 29.80; 24.65; 20.51; 17.13; 14.37; 12.10; ...
%                                              10.24; 8.700; 7.419; 6.351; 5.460];
% Values.Calibration.NTC_Resistance       =   [02841 ; 02055 ; 01506 ; 01112 ; 830.7 ; 624.5 ; 474.5 ; ...
%                                              363.1 ; 280.6 ; 218.0 ; 170.9 ; 134.6 ; 106.9 ; 85.49 ; ...
%                                              69.06 ; 56.05 ; 45.80 ; 37.57 ; 31.01 ; 24.70 ; 21.43 ; ...
%                                              17.92 ; 15.07 ; 12.71 ; 10.77 ; 9.165 ; 7.829 ; 6.712 ; ...
%                                              5.779 ];

Values.Calibration.NTC_Resistance       =   [02496 ; 01817 ; 01340 ; 995.2 ; 747.8 ; 565.4 ; 432.0 ; ...
                                             332.3 ; 258.1 ; 201.6 ; 158.8 ; 125.7 ; 100.3 ; 80.51 ; ...
                                             64.76 ; 52.34 ; 42.59 ; 34.80 ; 28.61 ; 23.63 ; 19.62 ; ...
                                             16.35 ; 13.70 ; 11.52 ; 9.728 ; 8.251 ; 7.025 ; 6.004 ; ...
                                             5.153]

% plot(Values.Calibration.NTC_Resistancelog,Values.Calibration.NTC_Temperature)
Values.Calibration.NTC_Resistancelog    =   log(Values.Calibration.NTC_Resistance);
Values.Calibration.Order_Polynome       =   4;
Values.Calibration.Polynomial           =   polyfit(Values.Calibration.NTC_Resistancelog    ,...
                                                    Values.Calibration.NTC_Temperature      ,...
                                                    Values.Calibration.Order_Polynome       );
Values.Minutes.NTC                      =   polyval(    Values.Calibration.Polynomial       ,...
                                                    log(Values.Minutes.Resistance_NTC)      );
hold on;