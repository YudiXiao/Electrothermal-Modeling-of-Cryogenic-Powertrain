clear all
clc

% Hydrogen properties at 1.66 bar
opts = delimitedTextImportOptions("NumVariables", 14);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["TemperatureK", "Pressurebar", "Densitykgm3", "Volumem3kg", "InternalEnergykJkg", "EnthalpykJkg", "EntropyJgK", "CvJgK", "CpJgK", "SoundSpdms", "JouleThomsonKbar", "ViscosityPas", "ThermCondWmK", "Phase"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Phase", "EmptyFieldRule", "auto");

% Import the data
fluid_H2_1bar66 = readtable("Hydrogen_enthalpy_data\fluid.txt", opts);


%Clear temporary variables
clear opts

%% Temperature vs. Enthalpy
%Fit: 'untitled fit 1'.
% [xData, yData] = prepareCurveData( fluid_H2_1bar66.EnthalpykJkg, fluid_H2_1bar66.TemperatureK );
% 
% % Set up fittype and options.
% ft = fittype( 'logistic' );
% opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts.Display = 'Off';
% opts.StartPoint = [300 0.00118232217391358 2151.7403196963];
% 
% % Fit model to data.
% [fitresult, gof] = fit( xData, yData, ft, opts );
% 
% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'TemperatureK vs. EnthalpykJkg', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'EnthalpykJkg', 'Interpreter', 'none' );
% ylabel( 'TemperatureK', 'Interpreter', 'none' );
% grid on

% General model Logistic:
%      data(x) = a/(1 + exp(-b*(x-c)))
%      Coefficients (with 95% confidence bounds):
%        a =       316.3  (312.5, 320.1)
%        b =    0.001179  (0.001155, 0.001203)
%        c =        2044  (2017, 2071)

%% Enthalpy vs temperature
% % Fit: 'untitled fit 1'.
% [xData, yData] = prepareCurveData( fluid_H2_1bar66.TemperatureK , fluid_H2_1bar66.EnthalpykJkg);
% 
% % Set up fittype and options.
% ft = fittype( 'poly1' );
% 
% % Fit model to data.
% [fitresult, gof] = fit( xData, yData, ft );
% 
% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'EnthalpykJkg vs. TemperatureK', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'TemperatureK', 'Interpreter', 'none' );
% ylabel( 'EnthalpykJkg', 'Interpreter', 'none' );
% grid on
% 
% Linear model Poly1:
%      data(x) = p1*x + p2
%      Coefficients (with 95% confidence bounds):
%        p1 =       12.69  (12.63, 12.75)
%        p2 =       58.28  (47.27, 69.29)