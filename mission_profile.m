% This script generate mission profile (power and altitude) of a
% conceptualized electric aircraft equivalent to A320. Details of the
% conceptualization can be found in publication "Structural 
% Power Performance Targets for Future Electric Aircraft" by Karadotcheva
%

clc
clear all

%% time
t_takeoff = 60; % seconds
t_climb = 20 * 60;  % seconds
t_cruise = 60 * 60; % seconds
t_descent = 30 * 60;    % seconds
t_hold = 30 * 60;   % seconds
t_landing = 5 * 60; % seconds

% Power in MW
P_takeoff = 21;
P_cruise = 13;
P_descent = 7;
P_hold = 5;
P_landing = 7;

% Altitude in km
A_cruise = 11.3;
A_hold = 0.5;
%%
t = 0:1:(t_takeoff + t_climb + t_cruise + t_descent + t_hold + t_landing);
P = zeros(1,size(t,2));
A = zeros(1,size(t,2));

for i = 1:1:size(t,2)
    if i<=t_takeoff
        P(i) = P_takeoff;
        A(i) = 0;
    elseif i>t_takeoff && i<=(t_takeoff + t_climb)
        P(i) = P_takeoff + (P_cruise - P_takeoff) / t_climb * (i - t_takeoff);
        A(i) = 0 + (A_cruise - 0) / t_climb * (i - t_takeoff);
    elseif i>(t_takeoff + t_climb) && i<=(t_takeoff + t_climb + t_cruise)
        P(i) = P_cruise;
        A(i) = A_cruise;
    elseif i>(t_takeoff + t_climb + t_cruise) && i<=(t_takeoff + t_climb + t_cruise + t_descent)
        P(i) = P_descent;
        A(i) = A_cruise + (A_hold - A_cruise) / t_descent * (i - (t_takeoff + t_climb + t_cruise));
    elseif i>(t_takeoff + t_climb + t_cruise + t_descent) && i<=(t_takeoff + t_climb + t_cruise + t_descent + t_hold)
        P(i) = P_hold;
        A(i) = A_hold;
    else
        P(i) = P_landing + (0 - P_landing) / t_landing * (i - (t_takeoff + t_climb + t_cruise + t_descent + t_hold));
        A(i) = A_hold + (0 - A_hold) / t_landing * (i - (t_takeoff + t_climb + t_cruise + t_descent + t_hold));
    end
end

% %%
% font_size = 14;
% font_name = 'Times New Roman';
% 
% figure
% yyaxis left
% p = plot(t,P / P_takeoff);
% p(1).LineWidth = 1;
% xlabel('Flight time','FontName',font_name,'FontSize',font_size)
% ylabel({'Power [p.u.]'},'FontName',font_name,'FontSize',font_size)
% % xlim([-5e-6,5e-6])
% xticks(0:1000:8000);
% xticklabels({'','','','','','','','',''});
% set(get(gca,'ylabel'),'rotation',90,'VerticalAlignment','middle','HorizontalAlignment','right')
% ylim([-0.1,1.1])
% grid on
% grid minor
% 
% yyaxis right
% p = plot(t,A / A_cruise);
% p(1).LineWidth = 1;
% % % xlabel('Time [\mus]','FontName',font_name,'FontSize',font_size)
% ylabel({'Altitude [p.u.]'},'FontName',font_name,'FontSize',font_size)
% % xlim([-5e-6,5e-6])
% % xticks(-5e-6:1e-6:5e-6);
% % xticklabels({'-5','-4','-3','-2','-1','0','1','2','3','4','5'});
% set(get(gca,'ylabel'),'rotation',270,'VerticalAlignment','middle','HorizontalAlignment','left')
% ylim([-0.1,1.1])
% grid on
% grid minor
