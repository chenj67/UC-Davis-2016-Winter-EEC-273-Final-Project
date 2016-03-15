clc; close all; clear all;

% %% header size IPv6
% Lheader = 60;
% Lhcomp = 3;
% 
% %% Gilbert Elliot Channel model
% 
% Pg = 0.9; %successful probability for good state
% Pb = 0.1; %successful probability for bad state
% 
% Lb = 5;
% epsilon = 0.1;
% 
% P_BG = 1 / Lb;
% P_BB = 1 - P_BG;
% 
% P_GB = (epsilon * P_BG) / (1 - epsilon);
% P_GG = 1 - P_GB;
% 
% % channel state transision matrix
% Tch = [P_GG P_GB; P_BG P_BB];
% 
% %% System model
% w = 4; %decompressor window size
% 
% Ts = Tch * [Pg 0; 0 Pb];
% Tf = Tch * [1-Pg 0; 0 1- Pb];
% 
% T_IR = [Ts Tf zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) Tf zeros(2,2) zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) Tf zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) zeros(2,2) Tf zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2) Tf;
%         Ts zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2) Tf];
% T_SO = [Ts Tf zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) Tf zeros(2,2) zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) Tf zeros(2,2) zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) zeros(2,2) Tf zeros(2,2);
%         Ts zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2) Tf;
%         zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2) zeros(2,2) Tch];
%     

A = [];
b = [];
Aeq = [];
beq = [];
lb = [0; 0; 1];
ub = [1; 1; +Inf];
x0 = [0; 0; 150];


epsilon = 0.01 : 0.01 : 0.5;
x3 = zeros(3, length(epsilon));
fs = zeros(1, length(epsilon));

for ia = 1:length(epsilon);
[x, f] = fmincon(@(var)objectfunc(var, epsilon(ia)), x0, A, b, Aeq, beq, lb, ub,@(var1)circlecon(var1, epsilon(ia)));
x3(:, ia) = x;
fs(ia) = -f;
end
figure,
plot(epsilon , x3(3, :), 'linewidth', 2); grid on; xlabel('\epsilon'); ylabel('Packet size');

figure;
plot(epsilon, fs, 'linewidth', 2);
grid on;
xlabel('\epsilon');
ylabel('Transmission Efficiency'); axis([0 0.5 0 1]);






% Pii = 4.148837319907435e-07;
% Pss = 0.948850432417224;
% 
% T = [Pii .* T_IR, (1 - Pii) .* T_IR;
%     (1 - Pss) .* T_SO, Pss .* T_SO];
% [L, V] = eig(T.');
% Pi = L(:, 1);
% Pi_index = Pi < 0;
% Pi(Pi_index) = Pi(Pi_index) * -1;
% Pi = Pi./(sum(Pi));

%Lheader = 60 * 8;
%Lhcomp = 3 * 8;

%L_IR = Lheader + pkt;
%L_SO = Lhcomp + pkt;

%Tbit = [L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO];

%B = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0];

%r = -(pkt * (B * Pi))/ (Tbit * Pi);