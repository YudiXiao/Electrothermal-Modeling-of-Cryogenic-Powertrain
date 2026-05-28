% This script is the baseline modeling of the thermal and electrical
% performance of a cryogenic electric powertrain. The modeling framework
% and formulus follow "Dual Use of Liquid Hydrogen in a Next-Generation 
% PEMFC-Powered Regional Aircraft With Superconducting Propulsion" by
% Hartmann, and "Optimal operating conditions of PEM fuel cells in 
% commercial aircraft" by Schroder.
%
% 
%
% Here the script only considers one operating point at peak power.

clc
clear all

% % Hydrogen properties at 1.66 bar
% opts = delimitedTextImportOptions("NumVariables", 14);
% 
% % Specify range and delimiter
% opts.DataLines = [2, Inf];
% opts.Delimiter = "\t";
% 
% % Specify column names and types
% opts.VariableNames = ["TemperatureK", "Pressurebar", "Densitykgm3", "Volumem3kg", "InternalEnergykJkg", "EnthalpykJkg", "EntropyJgK", "CvJgK", "CpJgK", "SoundSpdms", "JouleThomsonKbar", "ViscosityPas", "ThermCondWmK", "Phase"];
% opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"];
% 
% % Specify file level properties
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% 
% % Specify variable properties
% opts = setvaropts(opts, "Phase", "EmptyFieldRule", "auto");
% 
% % Import the data
% fluid_H2_1bar66 = readtable("Hydrogen_enthalpy_data\fluid.txt", opts);
% 
% 
% %Clear temporary variables
% clear opts
% 
% % 
% % Read data (electrical, i.e., average input current, phase RMS current,
% % RMS current of switches, average current of diodes, etc.) 
% % of baseline three-phase three-level inverter. 
% 
% % Import simulation date from LTspice - three-level NPC three-phase inverter
% % with 5kHz switching frequency.
% Three_level_data = readtable('Three_phase_three_level_inverter.txt','VariableNamingRule','preserve');
% 
% % Processing of LTspice waveform for bipolar devices (IGBT)
% size_threelevel = height(Three_level_data);
% % Average input current
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(V4)")(k) * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% Iin_three_avg = -temp / max(Three_level_data.time);
% % Average clamping diode current
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(D5)")(k) * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% Idclp_three_avg = temp / max(Three_level_data.time);
% % Average current of top body diode
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(D1)")(k) * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% for k = 1:1:(size_threelevel - 1)
%     if Three_level_data.("I(S1)")(k)<0
%         temp = temp - Three_level_data.("I(S1)")(k) * ...
%             (Three_level_data.time(k + 1) - Three_level_data.time(k));
%     end
% end
% Idtopbd_three_avg = temp / max(Three_level_data.time);
% % Average current of sec body diode
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(D2)")(k) * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% for k = 1:1:(size_threelevel - 1)
%     if Three_level_data.("I(S2)")(k)<0
%         temp = temp - Three_level_data.("I(S2)")(k) * ...
%             (Three_level_data.time(k + 1) - Three_level_data.time(k));
%     end
% end
% Idsecbd_three_avg = temp / max(Three_level_data.time);
% % RMS current of top switch
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(S1)")(k) ^ 2 * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% IStop_three_rms = sqrt(temp / max(Three_level_data.time));
% % Average current of top switch
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     if Three_level_data.("I(S1)")(k)>0
%         temp = temp + Three_level_data.("I(S1)")(k) * ...
%             (Three_level_data.time(k + 1) - Three_level_data.time(k));
%     end
% end
% IStop_three_avg = temp / max(Three_level_data.time);
% % RMS current of second switch
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(S2)")(k) ^ 2 * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% ISsec_three_rms = sqrt(temp / max(Three_level_data.time));
% % Average current of second switch
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     if Three_level_data.("I(S2)")(k)>0
%         temp = temp + Three_level_data.("I(S2)")(k) * ...
%             (Three_level_data.time(k + 1) - Three_level_data.time(k));
%     end
% end
% ISsec_three_avg = temp / max(Three_level_data.time);
% % RMS current of phase output
% temp = 0;
% for k = 1:1:(size_threelevel - 1)
%     temp = temp + Three_level_data.("I(L1)")(k) ^ 2 * ...
%         (Three_level_data.time(k + 1) - Three_level_data.time(k));
% end
% IL_three_rms = sqrt(temp / max(Three_level_data.time));

load('dataforpreload.mat');
%%

P_inv_baseline = 800 * Iin_three_avg;   % Power rating of this baseline inverter, W

fsw = 5e3;  % switching frequency, Hz

% SG GaN FET- GS66516T *  2 in parallel 
% 0.14mJ-Eon and 0.17mJ-Eoff at 400V/20A
Ron_GaN = 25e-3 / 2; % Drain source on-resistance, ohm
Vbd_GaN = 1.7; % 3rd quadrant voltage drop, V
Eon_GaN = 2* 0.14e-3 * 400 / 400 * 25 / 20;  % Turn-on switching energy per pulse at 400V/50A, J
Eoff_GaN = 2 * 0.017e-3 * 400 / 400 * 25 / 20;  % Turn-off switching energy per pulse at 400V/50A, J

% Generate mission profile
% Power in MW, Altitude in km, Time in seconds
%[Power,Altitude,Time] = mission_profile_function();
load('Mission_profile\Power_time.mat');
Time = Time_mission';
Power = Power_mission';
Altitude = Altitude_mission';

ResultsTemperature = zeros(3,size(Time,2));
ResultsInvLoss = zeros(1,size(Time,2));
ResultsInvEffi = zeros(1,size(Time,2));
ResultsQH2Remain = zeros(1,size(Time,2));
ResultsQTMS = zeros(1,size(Time,2));
Loss_vec= zeros(size(Time,2),5);
Effi_vec = zeros(size(Time,2),2);

% Definitions

% Temperature in-dependent ones
V_dc = 800; % Voltage of interlink DC bus, V
Ma_A320 = 0.8; % Average Mach number of A320
T_H2_fuel = 22;  % Hydrogen temperature in tank, K

% Temperature and pressure at mean sea level
T_MSL = 288.15; % Average ambient temperature at mean sea level, K
Pres_MSL = 101324;  % Average ambient pressure at mean sea level, Pa

% Gearbox
eta_gear = 0.99;    % gearbox efficiency
k_gear = 0.21;      % sizing factor
n_prop = 1200;  % maximum propeller speed, rpm

% Motor (superconducting)
n_scm = 1500;   % maximum motor speed, rmp
TTW_motor = 60; % Torque to weight ratio, N*m/kg
eta_scm = 0.995;    % motor efficiency

% HTS cable
rho_HTS = 5;    % specific weight of HTS cable, kg/m
A320_wingspan = 35.8;   % Wing span of A320, m
A320_length = 37.57;    % Length of A320, m
eta_HTS = 0.995;    % efficiency of HTS cable

% DC/AC
PTW_dcac = 15;  % power to weight ratio, kW/kg
eta_dcac = 0.99;    % efficiency of dc/ac stage

% Copper cable
J_cu = 8e6;    % current density in copper lead, A/m2
rho_cu = 8960;  % mass density of copper, kg/m3

% DC/DC
PTW_dcdc = 50;  % power to weight ratio, kW/kg
eta_dcdc = 0.99;    % efficiency of dc/dc stage

% Fuel cells
j_FC = 0.8;   % maximum cell current density, A/cm2
a_FC = -0.232;  % coefficient for fuel cell polarization voltage, V*cm2/A
b_FC = 0.8956;  % coefficient for fuel cell polarization voltage, V
lamda_H2 = 1.05;    % Stoichiometric ratio of hydrogen flow to fuel cell
lamda_air = 1.8;     % Stoichiometric ratio of air flow to fuel cell
HHV_H2 = 1.418e8;   % Higher heating value of hydrogen, J/kg
F = 96485;  % Faraday's constant, coulombs per mole (C/mol)
M_air = 28.9646431; % Molar mass of air, g/mol
x_O2 = 0.209;   % Molar fraction of O2 in air
gama_air = 1.4; % Ratio of specific heat for air
R_sp_air = 0.28704e3;   % Specific gas constant of air, J/(kg*K)
cp_air = 1e3;   % Specific heat capacity of air, J/(kg*K)
eta_pr = 0.75;  % Pressure recovery
eta_comp_s = 0.76;  % Isentropic compressor efficiency
eta_comp_m = 0.97;  % Mechanical compressor efficiency
eta_comp_el = 0.94; % Compressor motor efficiency
eta_comp_pc = 0.95; % Compressor converter efficiency
Pres_FCHX_in = 1.75e5;  % Pressure at fuel cell heat exchanger inlet, Pa
T_FCHX_out = 358.15;    % Temperature at fuel cell heat exchanger outlet, K
lamda_FC_TMS = 0.95;    % Fraction of heat rejected to TMS in the fuel cell
m_cell_sp = 3.5;    % mass per cell area, kg/m2
m_comp_sp = 5.333e-4;   % mass density of compressor, kg/W
m_hum_sp = 82.353;  % mass density of humidifier, kg/(kg/s)
lamda_BoP = 0.2;    % mass overhead coefficient of the remaining balance of plant (BoP) components

% Batteries
m_BAT_sp = 500; % power density of Li-ion batteries, W/kg
eta_BAT = 0.95; % discharge efficiency of batteries

% Thermal management system
p_sp_TMS = 0.08;    % Power consumption of thermal management system per removed heat, dimentionless P/Q
m_sp_TMS = 3;   % maximum heat can be removed per kilogram of the TMS system, kW/kg


%%
tic

for count_mission = 1:1:size(Time,2)
%for count_mission = 1:1:150

    % System parameters
    P_prop = Power(1,count_mission) * 1e6;  % power output at propeller, W
    Alt = Altitude(1,count_mission) * 1e3;   % Altitude of flight, m

    if P_prop <= 0
        break;
    end

    k_bat = 0;

    I_ph = P_prop / 3 / (V_dc / sqrt(3) / sqrt(2)); % RMS value of phase current, A, assume three phase star connection
    
    P_TMS_ini = P_prop * 0.1;   % initial guess of thermal management system power consumption, W
    P_TMS_arr = zeros(1,100);
    P_TMS_arr(1) = P_TMS_ini;
    Count_p_TMS = 1;

    % T_H2_ini = [22;23;24];   % initial guess of hydrogen temperature at [motor, dcac, dcdcFC], K
    % T_H2_arr = zeros(3,100);
    % T_H2_arr(:,1) = T_H2_ini;
    % Count_T_H2 = 1;
    
    while 1
        
        % Temperature dependent ones
        
        K_ele_HTS = 1000 * 5.8e7;  % electrical conductivity of HTS, S/m
        %K_th_HTS = 398;    % thermal conductivity of HTS, W/(m*K)
        
        %K_ele_cu = 5.8e7;  % electrical conductivity of copper, S/m
        %K_th_cu = 398;    % thermal conductivity of copper, W/(m*K)

        T_H2_ini = [22;23;24];   % initial guess of hydrogen temperature at [motor, dcac, dcdcFC], K
        T_H2_arr = zeros(3,100);
        T_H2_arr(:,1) = T_H2_ini;
        Count_T_H2 = 1;
        
        % Calculations
        
        % Ambient temperature and pressure
        Pres_amb = Pres_MSL * (1 - 0.0065 * Alt / T_MSL) ^ 5.2561;  % Ambient pressure, Pa
        T_amb = T_MSL - 6.5 * Alt / 1000 + 24 * (1 - Alt / 42361);  % Ambient temperature, K
        
        % Gearbox
        m_gear = k_gear * P_prop ^ 0.76 * n_scm ^ 0.13 ...
            / n_prop ^ 0.89;    % gearbox mass, kg
        
        % Motor (superconducting)
        Ploss_gearbox = P_prop * (1 / eta_gear - 1);    % Power loss of gear box, W
        P_motor = Ploss_gearbox + P_prop;   % output power of motor, W
        Ploss_motor = P_motor * (1 / eta_scm - 1);  % Power loss of motor, W
        PTW_motor = pi / 30 * n_scm * TTW_motor * (1e-3);   % Power to weight ratio of motor, kW/kg
        m_motor = P_motor * (1e-3) / PTW_motor;  % mass of motor, kg
        
        % Heat leak-in from dc/ac zone to motor zone
        P_lk_motor = 3 * I_ph * sqrt(2) * sqrt(2 * ...
            mean([KthHTStapes(T_H2_arr(1,Count_T_H2)),KthHTStapes(T_H2_arr(2,Count_T_H2))],2) / ...
            K_ele_HTS * ...
            (T_H2_arr(2,Count_T_H2) - T_H2_arr(1,Count_T_H2)));
        
        % HTS cable between motor and DC/AC stage (superconducting)
        m_cableHTS = 3 * rho_HTS * (A320_wingspan + A320_length) / 2 * (1 / 4); % mass of HTS cable, kg
        P_cableHTS = Ploss_motor + P_motor; % power on the output of the HTS cable, W
        Ploss_cableHTS = P_cableHTS * (1 / eta_HTS - 1);    % power loss of HTS cable, W
        
        % DC/AC
        P_dcac = Ploss_cableHTS + P_cableHTS; % output power of DC/AC, W
        N_baseinv = P_dcac / P_inv_baseline;    % number of required baseline inverters
        m_dcac = P_dcac * (1e-3) / PTW_dcac;    % mass of dc/ac stage, kg
        Ploss_dcac_outSW = 3 * 2 * (IStop_three_rms ^ 2 * TempDriftronSGGaN2(T_H2_arr(2,Count_T_H2)) * Ron_GaN + ...
            Idtopbd_three_avg * TempDriftdiode(T_H2_arr(2,Count_T_H2)) * Vbd_GaN + ...
            fsw / 2 * TempDriftEonSGGaN2(T_H2_arr(2,Count_T_H2)) * Eon_GaN + ...
            fsw / 2 * TempDriftEoffSGGaN2(T_H2_arr(2,Count_T_H2)) * Eoff_GaN);
        Ploss_dcac_inSW = 3 * 2 * (ISsec_three_rms ^ 2 * TempDriftronSGGaN2(T_H2_arr(2,Count_T_H2)) * Ron_GaN + ...
            Idsecbd_three_avg * TempDriftdiode(T_H2_arr(2,Count_T_H2)) * Vbd_GaN + ...
            fsw / 2 * TempDriftEonSGGaN2(T_H2_arr(2,Count_T_H2)) * Eon_GaN + ...
            fsw / 2 * TempDriftEoffSGGaN2(T_H2_arr(2,Count_T_H2)) * Eoff_GaN);
        Ploss_dcac_clpD = 3 * 2 * Idclp_three_avg * TempDriftdiode(T_H2_arr(2,Count_T_H2)) * Vbd_GaN;
        Ploss_dcac = N_baseinv * (Ploss_dcac_outSW + Ploss_dcac_inSW + Ploss_dcac_clpD);   % power loss of dc/ac stage, W
        
        % Power division between fuel cell and battery
        %k_bat = 0.5;    % battery to fuel cell power-output ratio
        
        % Copper cable between the DC/DC stage linking fuel cells and DC/AC stage
        P_cableFC = (1 - k_bat) * (P_dcac + Ploss_dcac);    % power on the output of this cable, W
        I_cableFC = P_cableFC / V_dc;   % current in this cable, A
        P_cableFC_max = P_dcac + Ploss_dcac;    % power on the output of this cable, W
        I_cableFC_max = P_cableFC_max / V_dc;   % current in this cable, A
        % m_cableFC = 2 * rho_cu * (I_cableFC / (1 - k_bat) / J_cu) ...
        %     * (A320_wingspan + A320_length) / 2 * (1 / 4);  % mass of this cable, kg
        Ploss_cableFC = I_cableFC ^ 2 * 2 * (A320_wingspan + A320_length) / 2 ...
            * (1 / 4) / (I_cableFC_max / J_cu) / mean([KeCopper(T_H2_arr(3,Count_T_H2)),...
            KeCopper(T_H2_arr(2,Count_T_H2))],2);    % power loss in this cable, W
        
        m_cableFC_max = 2 * rho_cu * (I_cableFC_max / J_cu) ...
            * (A320_wingspan + A320_length) / 2 * (1 / 4);  % mass of this cable, kg
        Ploss_cableFC_max = I_cableFC_max ^ 2 * 2 * (A320_wingspan + A320_length) / 2 ...
            * (1 / 4) / (I_cableFC_max / J_cu) / mean([KeCopper(T_H2_arr(3,Count_T_H2)),...
            KeCopper(T_H2_arr(2,Count_T_H2))],2);    % power loss in this cable, W
    
        % Heat leak-in from dc/dc (FC) zone to dc/ac zone
        P_lk_dcfc = 2 * I_cableFC * sqrt(2 * ...
            mean([Kthcopper(T_H2_arr(2,Count_T_H2)),Kthcopper(T_H2_arr(3,Count_T_H2))],2) / ...
            mean([KeCopper(T_H2_arr(2,Count_T_H2)),KeCopper(T_H2_arr(3,Count_T_H2))],2) * ...
            (T_H2_arr(3,Count_T_H2) - T_H2_arr(2,Count_T_H2)));
        
        % Copper cable between the DC/DC stage linking batteries and DC/AC stage
        P_cableBAT = k_bat * (P_dcac + Ploss_dcac);    % power on the output of this cable, W
        I_cableBAT = P_cableBAT / V_dc;   % current in this cable, A
        P_cableBAT_max = P_dcac + Ploss_dcac;    % power on the output of this cable, W
        I_cableBAT_max = P_cableBAT_max / V_dc;   % current in FCthis cable, A
        % m_cableBAT = 2 * rho_cu * (I_cableBAT / k_bat / J_cu) ...
        %     * (A320_wingspan + A320_length) / 2 * (1 / 4);  % mass of this cable, kg
        Ploss_cableBAT = I_cableBAT ^ 2 * 2 * (A320_wingspan + A320_length) / 2 ...
            * (1 / 4) / (I_cableBAT_max / J_cu) / mean([KeCopper(T_amb),...
            KeCopper(T_H2_arr(2,Count_T_H2))],2);    % power loss in this cable, W
        
        m_cableBAT_max = 2 * rho_cu * (I_cableBAT_max / J_cu) ...
            * (A320_wingspan + A320_length) / 2 * (1 / 4);  % mass of this cable, kg
        Ploss_cableBAT_max = I_cableBAT_max ^ 2 * 2 * (A320_wingspan + A320_length) / 2 ...
            * (1 / 4) / (I_cableBAT_max / J_cu) / mean([KeCopper(T_amb),...
            KeCopper(T_H2_arr(2,Count_T_H2))],2);    % power loss in this cable, W
    
        % Heat leak-in from dc/dc (BAT) zone to dc/ac zone
        P_lk_dcbat = 2 * I_cableBAT * sqrt(2 * ...
            mean([Kthcopper(T_H2_arr(2,Count_T_H2)),Kthcopper(T_amb)],2) / ...
            mean([KeCopper(T_H2_arr(2,Count_T_H2)),KeCopper(T_amb)],2) * ...
            (T_amb - T_H2_arr(2,Count_T_H2)));
        
        % DC/DC stage linking fuel cells and DC/AC stage
        P_dcdcFC = P_cableFC + Ploss_cableFC;   % output power of this DC/DC converter, W
        P_dcdcFC_max = P_cableFC_max + Ploss_cableFC_max;   % output power of this DC/DC converter, W
        m_dcdcFC = P_dcdcFC_max * (1e-3) / PTW_dcdc;    % mass of this DC/DC converter, kg
        Ploss_dcdcFC = P_dcdcFC * (1 / eta_dcdc - 1);   % power loss of this DC/DC converter, W
        Ploss_dcdcFC_max = P_dcdcFC_max * (1 / eta_dcdc - 1);   % power loss of this DC/DC converter, W
    
        % Heat leak-in from ambient zone to dc/dc (FC) zone
        P_lk_fc = 2 * I_cableFC * sqrt(2 * ...
            mean([Kthcopper(T_H2_arr(3,Count_T_H2)),Kthcopper(T_amb)],2) / ...
            mean([KeCopper(T_H2_arr(3,Count_T_H2)),KeCopper(T_amb)],2) * ...
            (T_amb - T_H2_arr(3,Count_T_H2)));
        
        % DC/DC stage linking batteries and DC/AC stage
        P_dcdcBAT = P_cableBAT + Ploss_cableBAT;   % output power of this DC/DC converter, W
        P_dcdcBAT_max = P_cableBAT_max + Ploss_cableBAT_max;   % output power of this DC/DC converter, W
        m_dcdcBAT = P_dcdcBAT_max * (1e-3) / PTW_dcdc;    % mass of this DC/DC converter, kg
        Ploss_dcdcBAT = P_dcdcBAT * (1 / eta_dcdc - 1);   % power loss of this DC/DC converter, W
        Ploss_dcdcBAT_max = P_dcdcBAT_max * (1 / eta_dcdc - 1);   % power loss of this DC/DC converter, W
        
        % Batteries
        P_BAT = P_dcdcBAT + Ploss_dcdcBAT;  % output power of batteries, W
        P_BAT_max = P_dcdcBAT_max + Ploss_dcdcBAT_max;  % maximum output power of batteries, W
        m_BAT = P_BAT_max / m_BAT_sp;   % mass of batteries, kg
        Ploss_BAT = P_BAT * (1 / eta_BAT - 1);  % power loss of batteries during discharge, W
        Ploss_BAT_max = P_BAT_max * (1 / eta_BAT - 1);  % power loss of batteries during discharge, W
        
        % P_TMS_ini = P_prop * 0.1;   % initial guess of thermal management system power consumption, W
        % P_TMS_arr = zeros(1,100);
        % P_TMS_arr(1) = P_TMS_ini;
        % Count_p_TMS = 1;
        
        while 1
        
            % Fuel cells
            P_comp_ini = P_prop * 0.3;  % initial guess of compressor power, W
            P_comp_arr = zeros(1,100);
            P_comp_arr(1) = P_comp_ini;
            Count_p_comp = 1;
            
            while 1
                P_FC = P_dcdcFC + Ploss_dcdcFC + P_comp_arr(Count_p_comp) + P_TMS_arr(Count_p_TMS); % output power of fuel cell, W
                P_FC_max = P_dcdcFC_max + Ploss_dcdcFC_max + P_comp_arr(Count_p_comp) + P_TMS_arr(Count_p_TMS); % output power of fuel cell, W
                U_FC_cell = a_FC * j_FC + b_FC; % average cell voltage of FC, V
                eta_FC = U_FC_cell / 1.481; % fuel cell efficiency
                Area_FC = P_FC_max / U_FC_cell / j_FC / (1e4);  % required total effective cell area, m2
                
                mf_H2_in = lamda_H2 * P_FC / eta_FC / HHV_H2;   % mass flow rate of hydrogen into fuel cell, kg/s
                mf_air_in = P_FC / U_FC_cell * lamda_air * M_air / (4 * F * x_O2) / (1e3);    % mass flow rate of air into fuel cell, kg/s
                
                P_H2 = mf_H2_in * HHV_H2;   % Chemical power delivered to fuel cell, W
                
                T_comp_in = T_amb + (sqrt(gama_air * R_sp_air * T_amb) ...
                    * Ma_A320) ^ 2 / (2 * cp_air);   % Compressor inlet temperature, K
                Pres_comp_in_stat = Pres_amb * (T_comp_in / T_amb) ...
                    ^ (gama_air / (gama_air - 1));    % maximum achievable static pressure at compressor inlet, Pa
                Pres_comp_in = eta_pr * (Pres_comp_in_stat - Pres_amb) + Pres_amb;  % Pressure at compressor inlet, Pa
                Delta_h_comp = 1 / eta_comp_s * cp_air * T_comp_in ...
                    * ((Pres_FCHX_in / Pres_comp_in) ^ (R_sp_air / cp_air) - 1); % Change of specific enthalpy of the compressor, J/kg 
                P_comp = Delta_h_comp * mf_air_in / (eta_comp_m * eta_comp_el * eta_comp_pc);   % Required compressor power, W
                Count_p_comp = Count_p_comp + 1;
                P_comp_arr(Count_p_comp) = P_comp;
                if abs(P_comp_arr(Count_p_comp) - P_comp_arr(Count_p_comp - 1))<=10
                    break
                end
            end
            
            % figure
            % [max,indmax] = max(nonzeros(P_comp_arr));
            % plot(1:1:indmax,P_comp_arr(1:1:indmax));
            
            T_FCHX_in = T_comp_in + Delta_h_comp / (1e3);   % Temperature at compressor's outlet, i.e., fuel cell exchanger's inlet, K
            P_FCHX = cp_air * mf_air_in * (T_FCHX_in - T_FCHX_out); % Heat (rate) rejected from fuel cell heat exchanger, W
            
            P_H2_eff = P_H2 * (1 / lamda_H2);   % Chemical power of H2 that contributes to reaction in fuel cell, W
            Ploss_FC_total = P_H2_eff - P_FC;   % Total loss in fuel cell, W
            Ploss_FC_TMS = lamda_FC_TMS * Ploss_FC_total;   % Loss in fuel cell rejected to TMS, W
            Ploss_FC_exha = (1 - lamda_FC_TMS) * Ploss_FC_total;    % Loss in fuel cell rejected to cathode exhaust, W
            
            m_FC_stack = m_cell_sp * Area_FC;   % Fuel cell mass, kg
            m_FC_comp = m_comp_sp * P_comp;    % Compressor mass, kg
            m_FC_hum = m_hum_sp * mf_air_in;   % Humidifier mass, kg
            m_FC_BoP = lamda_BoP * (m_FC_stack + m_FC_comp + m_FC_hum); % mass of miscellaneous components, kg
            
            % Heat generation rate and temperature
            h_H2_fuel = Enthalpyvstemperatureh2(T_H2_fuel);    % find enthalpy corresponding to specified temperature, kJ/kg
            h_H2_FC = Enthalpyvstemperatureh2(T_FCHX_out);    % find enthalpy corresponding to specified temperature, kJ/kg
            
            Q_motor = Ploss_motor + Ploss_cableHTS / 2 + P_lk_motor; % Heat generation rate at motor region, W
            h_H2_motor = h_H2_fuel + Q_motor / mf_H2_in / (1e3);    % enthalpy of H2 after absorbing heat generated in motor region, kJ/kg
            T_H2_motor = Temperaturevsenthalpyh2(h_H2_motor);   % find temperature corresponding to specified enthalpy, K
            
            Q_dcac = Ploss_cableHTS / 2 + Ploss_dcac + Ploss_cableFC / 2 + Ploss_cableBAT / 2 + P_lk_dcfc + P_lk_dcbat;  % Heat generation rate at DC/AC region, W
            h_H2_dcac = h_H2_motor + Q_dcac / mf_H2_in / (1e3);    % enthalpy of H2 after absorbing heat generated in motor region, kJ/kg
            T_H2_dcac = Temperaturevsenthalpyh2(h_H2_dcac);   % find temperature corresponding to specified enthalpy, K
            
            Q_dcdc = Ploss_cableFC / 2 + Ploss_dcdcFC + P_lk_fc;  % Heat generation rate at fuel cell DC/DC region, W
            h_H2_dcdc = h_H2_dcac + Q_dcdc / mf_H2_in / (1e3);    % enthalpy of H2 after absorbing heat generated in motor region, kJ/kg
            T_H2_dcdc = Temperaturevsenthalpyh2(h_H2_dcdc);   % find temperature corresponding to specified enthalpy, K
            
            Q_H2_remaining = (h_H2_FC - h_H2_dcdc) * mf_H2_in * (1e3);  % remaining cooling capacity of H2, W
            
            Q_TMS = P_FCHX + Ploss_FC_TMS + Ploss_gearbox + Ploss_dcdcBAT + Ploss_cableBAT / 2 ...
                + Ploss_BAT - Q_H2_remaining; % Heat load of thermal management system, W
            P_TMS = Q_TMS * p_sp_TMS;   % Power consumption of thermal management system, W
            m_TMS = Q_TMS / (1e3) / m_sp_TMS;   % mass of thermal management system, kg

            Count_T_H2 = Count_T_H2 + 1;
            T_H2_arr(:,Count_T_H2) = [T_H2_motor;T_H2_dcac;T_H2_dcdc];
            T_error = abs(T_H2_arr(1,Count_T_H2) - T_H2_arr(1,Count_T_H2-1)) + ...
                abs(T_H2_arr(2,Count_T_H2) - T_H2_arr(2,Count_T_H2-1)) + ...
                abs(T_H2_arr(3,Count_T_H2) - T_H2_arr(3,Count_T_H2-1));
            if T_error<0.1
                break
            end
  
        end

        Count_p_TMS = Count_p_TMS + 1;
        P_TMS_arr(Count_p_TMS) = P_TMS;
        if abs(P_TMS_arr(Count_p_TMS) - P_TMS_arr(Count_p_TMS - 1))<=10
            break
        end

    end
    ResultsTemperature(:,count_mission) = [T_H2_motor;T_H2_dcac;T_H2_dcdc];
    ResultsInvLoss(1,count_mission) = Ploss_dcac;
    ResultsInvEffi(1,count_mission) = (P_dcac - Ploss_dcac) / P_dcac;
    ResultsQH2Remain(1,count_mission) = Q_H2_remaining;
    ResultsQTMS(1,count_mission) = Q_TMS;

    if count_mission == 13 || count_mission == 26 || count_mission == 45 || count_mission == 200 || count_mission == 221 || count_mission == 238 || count_mission == 255 || count_mission == 273
        Loss_vec(count_mission,:) = [Q_motor Q_dcac Q_dcdc Q_H2_remaining Q_TMS];
    end

    Effi_vec(count_mission,:) = [P_dcac / (P_dcac + Ploss_dcac) P_prop / P_H2_eff];

end
toc
% figure
% [max,indmax] = max(nonzeros(P_TMS_arr));
% plot(1:1:indmax,P_TMS_arr(1:1:indmax));

%% Reduce data from cruise
Time_trunc = Time;
Time_trunc(50:186) = [];
Time_trunc(50:end) = Time_trunc(50:end) - (5471 - 1326);

%% Data processing for plot
TemperatureBar = zeros(size(Time,2),3);
TemperatureBar(:,1) = ResultsTemperature(1,:).';
TemperatureBar(:,2) = ResultsTemperature(2,:).' - ResultsTemperature(1,:).';
TemperatureBar(:,3) = ResultsTemperature(3,:).' - ResultsTemperature(2,:).';

TemperatureBar_trunc = TemperatureBar;
TemperatureBar_trunc(50:186,:) = [];

%%
Loss_vec_trunc = Loss_vec;
Loss_vec_trunc(50:186,:) = [];

Effi_vec_trunc = Effi_vec;
Effi_vec_trunc(50:186,:) = [];
%% Plot

font_size = 24;
font_name = 'Times New Roman';

figure

yyaxis left
plota = area(Time_trunc,TemperatureBar_trunc(:,:),'LineStyle','--');

plota(1).FaceColor = [0.6,0.8,1.0];
plota(1).FaceAlpha = 0.2;
plota(1).EdgeColor = 'b';
plota(2).FaceColor = [1.0,0.7,0.2];
plota(2).FaceAlpha = 0.2;
plota(2).EdgeColor = 'b';
plota(3).FaceColor = [0.5,0.9,0.5];
plota(3).FaceAlpha = 0.2;
plota(3).EdgeColor = 'b';


ylim([0,200])
ylabel({'{\it T_m_o_t}, {\it T_i_n_v} and {\it T_d_c} [K]'},'FontName',font_name,'FontSize',font_size)
yticks(0:50:200)
yticklabels({'0','50','100','150','200'})
ticky = get(gca,'YTicklabel');
set(gca,'YTicklabel',ticky,'FontName',font_name,'FontSize',font_size)
set(get(gca,'ylabel'),'rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center')


yyaxis right
b = bar(Time_trunc,Loss_vec_trunc / (1e3),"stacked",BarWidth=4);

yscale log
ylabel({'Loss [kW]'},'FontName',font_name,'FontSize',font_size)
% yticks(0:50:200)
% yticklabels({'0','50','100','150','200'})
ticky = get(gca,'YTicklabel');
set(gca,'YTicklabel',ticky,'FontName',font_name,'FontSize',font_size)
set(get(gca,'ylabel'),'rotation',90,'VerticalAlignment','top','HorizontalAlignment','center')

b(1).FaceColor = [0.2, 0.4, 0.6]; % (Deep Blue)
b(2).FaceColor = [0.9, 0.8, 0.2]; % (Yellow-Gold)
b(3).FaceColor = [0.6, 0.9, 0.6]; % (Light Green)
b(4).FaceColor = [1, 1, 1]; % (White)
b(5).FaceColor = [0.5, 0.5, 0.5]; % (Grey)
set(b, 'EdgeColor', 'r');

loss_labels = {'$\dot{Q}_{mot}$', '$\dot{Q}_{inv}$', '$\dot{Q}_{dc}$', '$\dot{Q}_{fc\_H_2}$', '$\dot{Q}_{amb}$'}; 

lgd = legend(b, loss_labels, 'Interpreter', 'latex');

set(lgd, ...
    'Interpreter', 'latex', ...      % Enables the dot notation
    'Orientation', 'horizontal', ... % Forces legends into one row
    'Location', 'northeast', ...         % Moves it to the top center (adjust as needed)
    'Color', 'none', ...             % Removes the background (makes it transparent)
    'EdgeColor', 'none', ...         % Removes the border box
    'FontName', font_name, ...
    'FontSize', font_size - 4);      % Slightly smaller font often fits better in one row

bar_heights_kW = sum(Loss_vec_trunc / 1e3, 2); 

% 2. Calculate values for the label text (MW)
label_values_MW = sum(Loss_vec_trunc / 1e6, 2); 

hold on;
for i = 1:length(Time_trunc)
    if bar_heights_kW(i) > 0
        % Create the string
        label_text = [num2str(label_values_MW(i), '%.2f'), ' MW'];
        
        % Position the text at the top of the bar
        % Use a small multiplier for log scale (e.g., 1.2x the height)
        text(Time_trunc(i), bar_heights_kW(i) * 1, ... 
            label_text, ... 
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontName', font_name, ...
            'FontSize', font_size - 8, ... 
            'Interpreter', 'none');
    end
end
hold off;

xlabel('Flight time [s]','FontName',font_name,'FontSize',font_size)
xlim([0,max(Time_trunc)])
xticks([0,500,1000,1855,2355,2855,3355]);
xticklabels({'0','500','1000','6000','6500','7000','7500'});
tickx = get(gca,'XTicklabel');
set(gca,'XTicklabel',tickx,'FontName',font_name,'FontSize',font_size)

grid on
grid minor

% ax3 = axes('Position', get(gca, 'Position'), ...
%            'Color', 'none', ...         % Make background transparent
%            'YAxisLocation', 'right', ... % Put it on the right
%            'XColor', 'none', ...         % Hide the x-axis (already exists)
%            'YColor', 'm');               % Color the axis (e.g., Magenta)
% 
% % 2. Offset the third axis so it doesn't sit on top of the Loss axis
% ax3.Position(3) = ax3.Position(3) * 0.85; % Shrink width to move it inward
% % OR move the entire axes slightly if you want it outside
% %ax3.Position(1) = ax3.Position(1); 
% 
% % 3. Plot your third line
% hold(ax3, 'on');
% p3 = plot(Time_trunc, Effi_vec_trunc(:,2), 'm', 'LineWidth', 2, 'Parent', ax3);
% 
% % 4. Format the third axis
% ylabel(ax3, 'Efficiency', 'FontName', font_name, 'FontSize', font_size);
% set(ax3, 'FontName', font_name, 'FontSize', font_size);
% % Adjust limits for the third scale
% %ylim(ax3, [0, 1]);