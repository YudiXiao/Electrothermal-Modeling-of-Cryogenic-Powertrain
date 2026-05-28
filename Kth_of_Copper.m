% Date of thermal conductivity of copper in W/mK over temperature in Kelvin
% from publication "Thermal considerations in the cryogenic regime for the 
% BNL double ridge higher order mode waveguide" by Dhananjay Ravikumar.

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
Kthofcopper = readtable("Kth_of_copper.csv", opts);


%% Clear temporary variables
clear opts

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Kthofcopper.x, Kthofcopper.y );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [1464.09592147112 26.2711735095008 18.7299497392236 608.619789522541 53.3898305084746 39.7764137925278];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

%{
General model Gauss2:
     data(x) =  a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2)
     Coefficients (with 95% confidence bounds):
       a1 =        1174  (877.5, 1470)
       b1 =       29.74  (27.18, 32.3)
       c1 =       20.92  (14.53, 27.3)
       a2 =       482.9  (334.9, 631)
       b2 =       165.6  (97.81, 233.5)
       c2 =       198.2  (15.22, 381.1)
%}