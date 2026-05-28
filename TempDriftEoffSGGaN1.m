%{
Curve fitting results of SG GaN HEMT turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Static and dynamic characterization of 650V GaN E-HEMTs in Room and
    cryogenic environments by Mahmoud.
    
%}
function [K] = TempDriftEoffSGGaN1(T)

       p1 = -0.008591;
       p2 = 3.409;
       K = p1*T + p2;

end