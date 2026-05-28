%{
Curve fitting results of SiC MOSFET (4H-SiC, not specified) turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Characterization of 1.2kV 4H-SiC power mosfets and Si IGNTs at
    cryogenic and high temperatures by Tian.
    
%}
function [K] = TempDriftEoffSiC4HMOS(T)

       p1 = -0.003662;
       p2 = 2.232;
       K = p1*T + p2;

end