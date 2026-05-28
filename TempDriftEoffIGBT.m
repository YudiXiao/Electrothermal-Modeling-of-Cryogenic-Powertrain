%{
Curve fitting results of Si IGBT turn-off energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
%}
function [K] = TempDriftEoffIGBT(T)

       p1 = 0.002223;
       p2 = 0.3121;
       K = p1*T + p2;

end