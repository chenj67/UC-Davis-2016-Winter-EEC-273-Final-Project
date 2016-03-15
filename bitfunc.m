function b = bitfunc(Probvector, epsilon, a)

Pii = Probvector(1);
Pss = Probvector(2);
pkt = 25 * 8;

Lheader = 60 * 8;
Lhcomp = 3 * 8;

L_IR = Lheader + pkt;
L_SO = Lhcomp + pkt;


BERgood =  a * 10^(-6);
BERbad =  a * 10^(-4);

BlERgood_IR = 1 - (1 - BERgood)^(L_IR);
BlERbad_IR = 1 - (1 - BERbad)^(L_IR);
BlERgood_SO = 1 - (1 - BERgood)^(L_SO);
BlERbad_SO = 1 - (1 - BERbad)^(L_SO);

Lb = 5;


P_BG = 1 / Lb;
P_BB = 1 - P_BG;

P_GB = (epsilon * P_BG) / (1 - epsilon);
P_GG = 1 - P_GB;

% channel state transision matrix
Tch = [P_GG P_GB; P_BG P_BB];

z = zeros(2,2);

Tf_IR = Tch * [BlERgood_IR 0; 0 BlERbad_IR];
Tf_SO = Tch * [BlERgood_SO 0; 0 BlERbad_SO];

Ts_IR = Tch * [1-BlERgood_IR 0; 0 1-BlERbad_IR];
Ts_SO = Tch * [1-BlERgood_SO 0; 0 1-BlERbad_SO];

T_IR = [Ts_IR Tf_IR z z z z;
        Ts_IR z Tf_IR z z z;
        Ts_IR z z Tf_IR z z;
        Ts_IR z z z Tf_IR z;
        Ts_IR z z z z Tf_IR;
        Ts_IR z z z z Tf_IR];

T_SO = [Ts_SO Tf_SO z z z z;
        Ts_SO z Tf_SO z z z;
        Ts_SO z z Tf_SO z z;
        Ts_SO z z z Tf_SO z;
        Ts_SO z z z z Tf_SO;
        z z z z z Tch];



T = [Pii .* T_IR, (1 - Pii) .* T_IR;
    (1 - Pss) .* T_SO, Pss .* T_SO];
[L, V] = eig(T.');
Pi = L(:, 1);
Pi_index = Pi < 0;
Pi(Pi_index) = Pi(Pi_index) * -1;
Pi = Pi./(sum(Pi));



Tbit = [L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_IR L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO L_SO];



b = Tbit * Pi;

