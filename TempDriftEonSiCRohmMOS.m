%{
Curve fitting results of SiC MOSFET (Rohm) turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Cryogenic pweformances comparisons among Si MOSFET, SiC MOSFET,
    Cascode GaN, and GaN devices by Wei.
    2. Comparisons and evaluations of silicon and wide band gap devices at
    crygoenic temperature by Wei.
    3. Performance evaluation of 650V SiC MOSFET under low temperature
    operation by Wei.
    
%}
function [K] = TempDriftEonSiCRohmMOS(T)

       p1 = -0.0006076;
       p2 = 1.177;
       K = p1*T + p2;

end