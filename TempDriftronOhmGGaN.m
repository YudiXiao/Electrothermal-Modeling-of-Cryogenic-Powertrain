%{
Curve fitting results of ohmic-gate GaN on-resistance (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    1. Evaluating common electronic components and GaN HEMTs under
    cryogenic conditions by Wadsworth.
    2. GaN based cryogenic temperature power electronics for
    superconducting motors in cryogenic electric aircraft by Wadsworth. 
    3. Performance of GaN Power devices for cryogenic applications down to
    4.2K by Nela.
%}
function [K] = TempDriftronOhmGGaN(T)
         
       p1 = 1.753e-05;
       p2 = -0.005244;
       p3 = 0.947;
       K = p1*T^2 + p2*T + p3;

end