%{
Curve fitting results of Si IGBT forward voltage (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Cryogenically cooled power electronics for long-distance aircraft by
    Schefer.
    2. Characterizing semiconductor devices for all-electric  aircraft by
    El-Wakeel.
%}
function [K] = TempDriftvfIGBT(T)

       p1 = 7.098e-06;
       p2 = -0.0008958;
       p3 = 0.6968;
       K = p1*T^2 + p2*T + p3;

end