%{
Curve fitting results of SiC MOSFET turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
    
%}
function [K] = TempDriftEoffSiCNormMOS(T)

       p1 = 1.622e-07;
       p2 = -0.0001097;
       p3 = 0.0229;
       p4 = -0.3954;
       K = p1*T^3 + p2*T^2 + p3*T + p4;

end