clc;
clear all;
close all;

A = [];
b = [];
Aeq = [];
beq = [];
lb = [0; 0];
ub = [1; 1];
x0 = [0; 0];

lb1 = [0; 0; 0];
ub1 = [1; 1; +Inf];
x3 = [0; 0; 100];
a = 15;

epsilon = 0.01:0.01:0.7;
e1 = zeros(1,length(epsilon));
e2 = zeros(1,length(epsilon));
e3 = zeros(1,length(epsilon));

bit1 = zeros(1, length(epsilon));
bit2 = zeros(1, length(epsilon));
bit3 = zeros(1, length(epsilon));



rohc = zeros(2, length(epsilon));
rohc3  = zeros(3, length(epsilon));


for i = 1:length(epsilon)
[x1, f1] = fmincon(@(var)objectfunc1(var, epsilon(i), a), x0, A, b, Aeq, beq, lb, ub, @(var1)circlecon1(var1, epsilon(i), a));
e1(i) = -f1;
rohc(:, i) = x1;
bit1(i) = bitfunc(x1, epsilon(i), a);




[x2, f2] = fmincon(@(var)objectfunc2(var, epsilon(i), a), x0, A, b, Aeq, beq, lb, ub, @(var1)circlecon2(var1, epsilon(i), a));
e2(i) = -f2;
bit2(i) = bitfunc1(x2, epsilon(i), a);


[x3, f3] = fmincon(@(var)objectfunc3(var, epsilon(i), a), x3, A, b, Aeq, beq, lb1, ub1, @(var1)circlecon3(var1, epsilon(i), a));
e3(i) = -f3;
rohc3(:, i) = x3;
bit3(i) = bitfunc2(x3, epsilon(i), a);


end
figure,
plot(epsilon, e1, 'r', 'linewidth', 2); hold on,
plot(epsilon, e2, 'b', 'linewidth', 2); hold on,
plot(epsilon, e3, 'k', 'linewidth', 2),
legend('small payload size', 'large payload size', 'dynamic payload size', 'location', 'best');
grid on, xlabel('channel condition'), ylabel('Bit Efficiency'),
%axis([0.01 0.35 0.4 0.95]);


% for i = 1:length(epsilon)
%     
% [x1, v1] = fmincon(@(var)bitobjectfunc(var, epsilon(i)), x0, A, b, Aeq, beq, lb, ub, @(var1)bitcirclecon1(var1, epsilon(i)));
% b1(i) = v1;
% 
% [x2, v2] = fmincon(@(var)bitobjectfunc1(var, epsilon(i)), x0, A, b, Aeq, beq, lb, ub, @(var1)bitcirclecon2(var1, epsilon(i)));
% b2(i) = v2;
% 
% [x3, v3] = fmincon(@(var)bitobjectfunc2(var, epsilon(i)), x3, A, b, Aeq, beq, lb1, ub1, @(var1)bitcirclecon3(var1, epsilon(i)));
% b3(i) = v3;
% 
% end
% 
figure,
plot(epsilon, bit1, 'r', 'linewidth', 2); hold on,
plot(epsilon, bit2, 'b', 'linewidth', 2); hold on,
plot(epsilon, bit3, 'k', 'linewidth', 2),
legend('small payload size', 'large payload size', 'dynamic payload size', 'location', 'best')
grid on, xlabel('channel condition'), ylabel('Bit'),
%axis([0.01 0.35 0.4 0.95]);