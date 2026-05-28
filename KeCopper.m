% Function to calculate electrical conductivity in S/m of copper over varying
% temperature T in Kelvin.
% "Materials & Properties: Thermal & Electrical Characteristics" 
% by Sergio Calatroni.


function [Ke] = KeCopper(T)   
       p1 = -123.4;
       p2 = 8.723e+04;
       p3 = -2.015e+07;
       p4 = 1.592e+09;
       Ke = p1*T^3 + p2*T^2 + p3*T + p4;
end