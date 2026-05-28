%{
Curve fitting results of Si MOSFET turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
%}
function [K] = TempDriftEonSiMOS(T)

       p1 = 0.001844;
       p2 = 0.5097;
       K = p1*T + p2;

end