% Data of thermal conductivity in W/mK of HTS tapes over varying
% temperature T in Kelvin. Thermal conductivity of HTS tapes is found from 
% "Thermal conductivity measurement of HTS tapes and stacks for current 
% lead applications" by Michael Schwarz.

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
KthHTStapes = readtable("Kth_of_HTS_tapes.csv", opts);


%% Clear temporary variables
clear opts

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( KthHTStapes.x, KthHTStapes.y );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

%{
    Linear model Poly1:
     data(x) = p1*x + p2
     Coefficients (with 95% confidence bounds):
       p1 =      0.8913  (0.7455, 1.037)
       p2 =       10.41  (2.92, 17.9)

%}