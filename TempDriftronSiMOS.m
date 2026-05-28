%{
Curve fitting results of Si MOSFET on-resistance (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications listed in Sorted_Data.xlsx
%}
function [K] = TempDriftronSiMOS(T)
     
       p1 = 2.894e-05;
       p2 = -0.007925;
       p3 = 0.8138;
       K = p1*T^2 + p2*T + p3;

end