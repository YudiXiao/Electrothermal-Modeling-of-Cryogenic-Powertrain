% Function to calculate thermal conductivity of copper in W/mK over temperature in Kelvin
% from publication "Thermal considerations in the cryogenic regime for the 
% BNL double ridge higher order mode waveguide" by Dhananjay Ravikumar.
function [Kth] = Kthcopper(T)    
       a1 = 1174;
       b1 = 29.74;
       c1 = 20.92;
       a2 = 482.9;
       b2 = 165.6;
       c2 = 198.2;
       Kth = a1*exp(-((T-b1)/c1)^2) + a2*exp(-((T-b2)/c2)^2);
end