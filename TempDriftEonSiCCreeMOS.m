%{
Curve fitting results of SiC MOSFET (from Cree) turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Cryogenic pweformances comparisons among Si MOSFET, SiC MOSFET,
    Cascode GaN, and GaN devices by Wei.
    2. Comparisons and evaluations of silicon and wide band gap devices at
    crygoenic temperature by Wei.
    
%}
function [K] = TempDriftEonSiCCreeMOS(T)

       p1 = 0.0002927;
       p2 = 0.9098;
       K = p1*T + p2;

end