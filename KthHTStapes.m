% Function to calculate thermal conductivity in W/mK of HTS tapes over varying
% temperature T in Kelvin. Thermal conductivity of HTS tapes is found from 
% "Thermal conductivity measurement of HTS tapes and stacks for current 
% lead applications" by Michael Schwarz.

function [Kth] = KthHTStapes(T)
       p1 = 0.8913;
       p2 = 10.41;
       Kth = p1*T + p2;
end