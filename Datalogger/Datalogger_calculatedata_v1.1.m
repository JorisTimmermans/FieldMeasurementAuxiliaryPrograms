function [Values] =   Datalogger_calculatedata(Values)

Temp                        =   load('MR23X_total.mat')
Pressure    =   mean(Temp.Values.Minutes.Pressure)*100;     %Pascal so multiply by 100

Values.Ten_Minutes.UCN2_av          =   mean(reshape(Values.Minutes.UCN2_av(1:end-1),10,977));
Values.Ten_Minutes.Var_UCN2         =   mean(reshape(Values.Minutes.Var_UCN2(1:end-1),10,977));
Values.Ten_Minutes.Temperature_high =   mean(reshape(Values.Minutes.Temperature_high(1:end-1),10,977));
Values.Ten_Minutes.Wind_speed_high  =   mean(reshape(Values.Minutes.Wind_speed_high(1:end-1),10,977));


% Pressure    =   101300;
Ucn2        =   Values.Minutes.UCN2_av;
Sigma       =   Values.Minutes.Var_UCN2;
Cn2         =   10.^(Ucn2-12+1.15*Sigma);
Air_Temp    =   Values.Minutes.Temperature_high + 273.15;
U           =   Values.Minutes.Wind_speed_high;

% Ucn2        =   Values.Ten_Minutes.UCN2_av;
% Sigma       =   Values.Ten_Minutes.Var_UCN2;
% Cn2         =   10.^(Ucn2-12+1.15*Sigma);
% Air_Temp    =   Values.Ten_Minutes.Temperature_high + 273.15;
% U           =   Values.Ten_Minutes.Wind_speed_high;

% declare constants
N           =	7.80E-07;
Bowen       =	3;
Rho         =	1.2;
Rd          =	287;
Cp          =	1008;
g           =	9.81;
k           =	0.4;
B           =	0.57;   %
Zom         =	0.15;   %
Dis         =	0.0;      %Displacement heigt
CTTA        =	4.9;
CTTB        =	6.1;
CTTC        =   2.2;
Zlas        =	4.85;
Zcup        =	4.40;

Ct          =   sqrt(Cn2).*Air_Temp.^2/((-N*Pressure)*(1+0.03/Bowen));
Ct2         =   Ct.^2;
H_free      =   Rho*Cp*B*(Zlas-Dis)*sqrt(g./Air_Temp).*(Ct2.^(3/4));

% start values (take not a number)
[u_star_s,u_star_u,T_star_s,T_star_u]  =   deal(NaN*ones(size(Cn2)));
  
figure(1)
h       =   waitbar(0,'Please wait, Iterating...');

for j=1:99 %begin iteration    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STABLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Hlas_s          =   ones(size(Cn2)) * 1;
    Hlas2           =   -Rho*Cp*T_star_s.*u_star_s;
    index           =   find(isfinite(Hlas2));
    Hlas_s(index)   =   Hlas2(index);
    
    Lmo_s           =   ones(size(Cn2)) * 1;
    Lmo2            =   Air_Temp.*u_star_s.^2./(k*g*T_star_s);
    index           =   find(isfinite(Lmo2) & Lmo2~=0);
    Lmo_s(index)    =   Lmo2(index);

    Psi_m_zcup_s    =   -5*(Zcup-Dis)./Lmo_s;
    Psi_m_zom_s     =   -5*(Zom)./Lmo_s;
    Ct_help_s       =   CTTA*(1+CTTC*((Zlas-Dis)./Lmo_s).^(2/3));
    u_star_s        =   k*U./(log((Zcup - Dis)/Zom) - Psi_m_zcup_s + Psi_m_zom_s);
    T_star_s        =   sqrt((Ct2*(Zlas-Dis)^(2/3))./Ct_help_s);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNSTABLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Hlas_u          =   ones(size(Cn2)) * -1e-6;
    Hlas2           =   -Rho*Cp*T_star_u.*u_star_u;
    index           =   find(isfinite(Hlas2));
    Hlas_u(index)   =   Hlas2(index);
    
    Lmo_u           =   ones(size(Cn2)) * -1e-6;
    Lmo2            =   Air_Temp.*u_star_u.^2./(k*g*T_star_u);
    index           =   find(isfinite(Lmo2) & Lmo2~=0);
    Lmo_u(index)    =   Lmo2(index);
    
    Aux_x_Zcup      =   sqrt(sqrt(1 - 16*(Zcup - Dis) ./ Lmo_u));
    Aux_x_Zom       =   sqrt(sqrt(1 - 16*(Zom) ./ Lmo_u));
    Psi_m_zcup_u    =   2*log((1 + Aux_x_Zcup)/2)   + ...
                          log((1 + Aux_x_Zcup.^2)/2) - 2*atan(Aux_x_Zcup)+3.14159/2;
    Psi_m_zom_u     =   2*log((1 + Aux_x_Zom )/2)   + ...
                          log((1 + Aux_x_Zom .^2)/2)- 2*atan(Aux_x_Zom )+3.14159/2;
    Ct_help_u       =   Ct*((Zlas-Dis)^(1/3));
    u_star_u        =   k*U./(log((Zcup - Dis)/Zom) - Psi_m_zcup_u + Psi_m_zom_u);
    T_star_u        =   Ct_help_u.*((1-CTTB*(Zlas-Dis)./Lmo_u).^(1/3))/sqrt(CTTA);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot([Hlas_u]), drawnow
    waitbar(j/100,h)
end
close(h)
index2=(Values.Minutes.Temperature_high-Values.Minutes.Temperature_low)>=0;
% plot([Hlas_u,Hlas_s,index.*Hlas_u + index2.*Hlas_s])

