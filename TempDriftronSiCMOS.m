%{
Curve fitting results of SiC MOSFET on-resistance (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications listed in Sorted_Data.xlsx
%}
function [K] = TempDriftronSiCMOS(T)
     
       p1 = 4.151e-05;
       p2 = -0.02054;
       p3 = 3.437;
       K = p1*T^2 + p2*T + p3;

end