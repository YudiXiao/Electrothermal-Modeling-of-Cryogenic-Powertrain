%{
Curve fitting results of SiC MOSFET turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
%}
function [K] = TempDriftEonSiCNormMOS(T)

       p1 = 2.03e-05;
       p2 = -0.01357;
       p3 = 3.206;
       K = p1*T^2 + p2*T + p3;

end