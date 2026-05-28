% Curve fitting results of diode forward voltage (p.u. against 300K) 
% vs. temperature in Kelvin
function [K] = TempDriftdiode(T)
    
    p1 = -0.001196;
    p2 = 1.365;
    K = p1*T + p2;

end