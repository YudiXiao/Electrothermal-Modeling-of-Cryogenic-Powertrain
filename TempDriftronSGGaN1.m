%{
Curve fitting results of cascode SG GaN on-resistance (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Cryogenic evaluation and modeling of a 900V cascode GaN HEMT by
    Hossain.
    2. Comparative study of Gallium nitride and silicon carbide MOSFETs as
    power switching applications under cryogenic conditions by El-Azeem.
%}
function [K] = TempDriftronSGGaN1(T)
         
       p1 = 5.218e-06;
       p2 = -0.001143;
       p3 = 0.8958;
       K = p1*T^2 + p2*T + p3;

end