function [Values] =   Datalogger_calculatedata(Values)

Temp                        =   load('MR23X_total.mat')
Pressure    =   mean(Temp.Values.Minutes.Pressure)*100;     %Pascal so multiply by 1000
Ucn2        =   Values.Minutes.UCN2_av
Sigma       =   Values.Minutes.Var_UCN2;
% Cn2         =   10.^(Ucn2-12);
Cn2         =   10.^(Ucn2-12+1.15*Sigma)


10^($J5-12+1,15*$K5)
Air_Temp    =   Values.Minutes.Temperature_high + 273.15;
U           =   Values.Minutes.Wind_speed_high;

% declare constants
N           =	7.80E-07;
Bowen       =	0.5;
Rho         =	1.2;
Rd          =	287;
Cp          =	1008;
g           =	9.81;
k           =	0.4;
B           =	0.57;   %
Zom         =	0.15;   %
Dis         =	1.5;      %Displacement heigt
CTTA        =	4.9;
CTTB        =	6.1;
Zlas        =	4,85;
Zcup        =	4.40;

Ct          =   sqrt(Cn2).*Air_Temp.^2/((-N*Pressure)*(1+0.03/Bowen));
Ct2         =   Ct.^2;
H_free      =   Rho*Cp*B*(Zlas-Dis)*sqrt(g./Air_Temp).*(Ct2.^(3/4));

Ct_help     =   CTTA*(1+CTTC*((Zlas-Dis)/Lmo)^(2/3))        %stable       
Ct_help     =   Ct*((Zlas-Dis)^(1/3));                      %unstable


% start values (take not a number)
u_star  =   NaN*ones(size(Cn2));
T_star  =   NaN*ones(size(Cn2));
figure(1)
h       =   waitbar(0,'Please wait, Iterating...');

for j=1:100 %begin iteration    
    Hlas        =   ones(9771,1) * +1.000000;       %  stable
    Hlas        =   ones(9771,1) * -0.000001;       %unstable
    Hlas2       =   -Rho*Cp*T_star.*u_star;
    index       =   find(isfinite(Hlas2));
    Hlas(index) =   Hlas2(index);

    Lmo         =   ones(9771,1) * +1.000000;       %stable
    Lmo         =   ones(9771,1) * -0.000001;       %unstable
    Lmo2        =   Air_temp.*u_star.^2./(k*g*T_star);
    index       =   find(isfinite(Lmo2) & Lmo2~=0);
    Lmo(index)  =   Lmo2(index);
    
    index       =   find(Lmo<0);
%     if Lmo >0 stable else unstable

    Aux_x_Zcup  =   sqrt(sqrt(1 - 16*(Zcup - Dis) ./ Lmo(index)));  %unstable
    Aux_x_Zom   =   sqrt(sqrt(1 - 16*(Zom  - Dis) ./ Lmo(index)));
    
    Psi_m_zcup          =   -5*(Zcup-Dis)./Lmo;                                             %stable
    Psi_m_zcup(index)   =   2*log((1 + Aux_x_Zcup)/2)   + ...
                             log((1 + Aux_x_Zcup.^2)/2) - 2*atan(Aux_x_Zcup)+3.14159/2;     %unstable
    Psi_m_zom           =   -5*(Zom)./Lmo;                                                  %stable
    Psi_m_zom(index)    =   2*log((1 + Aux_x_Zom )/2)   + ...
                              log((1 + Aux_x_Zom .^2)/2)- 2*atan(Aux_x_Zom )+3.14159/2;     %unstable
    
    u_star  =   k*U./(log((Zcup - Dis)/Zom) - Psi_m_zcup + Psi_m_zom);
    T_star  =   sqrt((Ct2*(Zlas-Dis)^(2/3))/Ct_help);                       %stable
    T_star  =   Ct_help.*((1-CTTB*(Zlas-Dis)./Lmo).^(1/3))./sqrt(CTTA);     %unstable
    plot(Hlas),ylim([0 3500]),drawnow
    waitbar(j/100,h)
end
close(h)



