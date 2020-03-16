function [Values] =   Datalogger_calculatedata(Values)


% Cn2     =	9,95E-12;
% u       =	0,5;
% Pres    =	101300;
% Temp    =	300;


Temp                        =   load('MR23X_total.mat')
Pressure    =   mean(Temp.Values.Minutes.Pressure);
Cn2         =   10.^(Values.Minutes.UCN2_av-12);
Air_temp    =   Values.Minutes.Temperature_high;
U           =   Values.Minutes.Wind_speed_high;


N       =	7.80E-07;
Bowen   =	3;
Rho     =	1.2;
Rd      =	300;
Cp      =	1008;
g       =	9.81;
k       =	0.4;
B       =	0.57;   %
Zom      =	0.25;   %
Dis     =	0;      %Displacement heigt
CTTA    =	4.9;
CTTB    =	9;
ZLAS    =	5.08;
Zcup    =	4.90;



u_star  =   k*U/log((Zcup - Dis)/Zom) - Psi_m_zcup + Psi_m_zom;
T_star  =   Ct_help*((1-CTTB*(Zlas-Dis)/Lmo)^(1/3))/sqrt(CTTA);
Ct      =   sqrt(Cn2)*Air_Temp^2/((-N*Pressure)*(1+0.03/Bowen));
Ct2     =   Ct^2;
H_free  =   Rho*Cp*B*(Zlas-Dis)*sqrt(g/Air_temp)*Ct2^(3/4);
Ct_help =   Ct*((Zlas-Dis)^(1/3));



if ~isfinite(-Rho*Cp*T_star*u_star)
            Hlas    =   -0.000001;
else
            Hlas    =   -Rho*Cp*T_star*u_star;
end

if (~isfinite(Air_temp*u_star^2/(k*g*T_star))       %Obukhov length
            Lmo     =   -0.000001;
else
            Lmo     =   Air_temp*u_star^2/(k*g*T_star));
end

if(Lmo>0)
    Psi_m_zcup  =   -5*(Zcup-Dis)/Lmo;
else
    Psi_m_zcup  =   2*log((1+Aux_x_Zcup)/2)+log((1+Aux_x_Zcup^2)/2)-2*atan(Aux_x_Zcup)+3,14159/2;
end

if(Lmo>0)
   Psi_m_zom    =   -5*(Zom)/Lmo;
else
   Psi_m_zom    =   2*log((1+Aux_x_Zom )/2)+log((1+Aux_x_Zom ^2)/2)-2*atan(Aux_x_Zom )+3,14159/2;
end

Aux_x_Zcup      =   sqrt(sqrt(1 - 16*(Zcup - Dis) / Lmo));
Aux_x_Zom       =   sqrt(sqrt(1 - 16*(Zom  - Dis) / Lmo));

if(Lmo>0)
    Situtation  =   'stable';
else
    Situation   =   'unstable';
end


