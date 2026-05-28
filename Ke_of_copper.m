% Data of electrical conductivity in S/m of copper over varying
% temperature T in Kelvin.
% "Materials & Properties: Thermal & Electrical Characteristics" 
% by Sergio Calatroni.

clear all
clc

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["x", "y"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Keofcopper = readtable("Ke_of_copper.csv", opts);
Ke_Copper = 1 ./ (Keofcopper.y * (1e-8)); % S/m 


%% Clear temporary variables
clear opts

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Keofcopper.x, Ke_Copper );

% Set up fittype and options.
ft = fittype( 'poly3' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'KeCopper vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'KeCopper', 'Interpreter', 'none' );
grid on

%{
Linear model Poly3:
     data(x) = p1*x^3 + p2*x^2 + p3*x + p4
     Coefficients (with 95% confidence bounds):
       p1 =      -123.4  (-243.6, -3.125)
       p2 =   8.723e+04  (3.434e+04, 1.401e+05)
       p3 =  -2.015e+07  (-2.631e+07, -1.399e+07)
       p4 =   1.592e+09  (1.444e+09, 1.74e+09)
%}