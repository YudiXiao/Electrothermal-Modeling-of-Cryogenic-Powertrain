%{
Curve fitting results of SG GaN HEMT turn-ooff energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Cryogenic temperature characterizations of state of the aer cascode
    900V GaN FET by Wei.
    2. Evaluation of the high performance 650V cascode GaN FET under low
    temperature by Wei.
    3. Cryogenic performances comparisons among Si MOSFET, SiC MOSFET,
    cascode GaN and GaN devices by Wei.
    4. Static and dynamic cryogenic characterizations of commercial high
    performance GaN HEMTs for more electric aircraft by Wei.
    5. Comparisons and Evaluations of Silicon and wide band gap devices at
    cryogenic temperature by Wei.
    
%}
function [K] = TempDriftEoffSGGaN2(T)

       p1 = -8.105e-06;
       p2 = 0.003795;
       p3 = 0.604;
       K = p1*T^2 + p2*T + p3;

end