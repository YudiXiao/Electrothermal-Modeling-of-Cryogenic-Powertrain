%{
Curve fitting results of SG GaN on-resistance (p.u. against 300K) vs. temperature in Kelvin
This fit covers data in publications found in Sorted_Data.xlsx

%}
function [K] = TempDriftronSGGaN2(T)
         
       a = 0.1073;
       b = 0.007391;
       K = a*exp(b*T);

end