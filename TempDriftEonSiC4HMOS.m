%{
Curve fitting results of SiC MOSFET (4H-SiC, not specified) turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Characterization of 1.2kV 4H-SiC power mosfets and Si IGNTs at
    cryogenic and high temperatures by Tian.
    
%}
function [K] = TempDriftEonSiC4HMOS(T)

       p1 = 2.138e-07;
       p2 = -0.000153;
       p3 = 0.03371;
       p4 = -1.118;
       K = p1*T^3 + p2*T^2 + p3*T + p4;

end