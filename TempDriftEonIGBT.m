%{
Curve fitting results of Si IGBT turn-on energy (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications:
    
%}
function [K] = TempDriftEonIGBT(T)

       p1 = 5.816e-06;
       p2 = 2.69e-05;
       p3 = 0.4919;
       K = p1*T^2 + p2*T + p3;

end