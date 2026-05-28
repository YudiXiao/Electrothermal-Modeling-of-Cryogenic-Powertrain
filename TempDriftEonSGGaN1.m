%{
Curve fitting results of SG GaN HEMT turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Static and dynamic characterization of 650V GaN E-HEMTs in Room and
    cryogenic environments by Mahmoud.
    
%}
function [K] = TempDriftEonSGGaN1(T)

       p1 = 2.842e-05;
       p2 = -0.01124;
       p3 = 1.832;
       K = p1*T^2 + p2*T + p3;

end