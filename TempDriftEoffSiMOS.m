%{
Curve fitting results of Si MOSFET turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
%}
function [K] = TempDriftEoffSiMOS(T)

       p1 = 0.001117;
       p2 = 0.5746;
       K = p1*T + p2;

end