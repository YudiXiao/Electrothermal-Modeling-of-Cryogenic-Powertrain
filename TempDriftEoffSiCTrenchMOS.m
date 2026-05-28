%{
Curve fitting results of trench SiC MOSFET turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Static and dynamic characterization of 1200V SiC NOSFETs at roon and
    cryogenic temperatures by Mahmoud.
    
%}
function [K] = TempDriftEoffSiCTrenchMOS(T)

       p1 = 3.915e-05;
       p2 = -0.02089;
       p3 = 3.755;
       K = p1*T^2 + p2*T + p3;

end