%% Group 6 - Project 1B: Anti-Reflection Coating
%% Glass substrate (εr = 2.25), Design frequency = 10 GHz

clear; clc; close all;

%% ============================================================
%% GIVEN PARAMETERS
%% ============================================================
er_air    = 1.0;
er_glass  = 2.25;
er_coat   = 1.5;        % calculated: sqrt(er_air * er_glass)
eta0      = 377;        % free space impedance (Ohm)
c         = 3e8;        % speed of light (m/s)
f_design  = 10e9;       % 10 GHz
t_coat    = 6.12e-3;    % quarter-wave thickness in meters (6.12 mm)

%% ============================================================
%% IMPEDANCES
%% ============================================================
eta_air   = eta0 / sqrt(er_air);
eta_glass = eta0 / sqrt(er_glass);
eta_coat  = eta0 / sqrt(er_coat);

fprintf('=== Impedance Values ===\n');
fprintf('eta_air   = %.2f Ohm\n', eta_air);
fprintf('eta_coat  = %.2f Ohm\n', eta_coat);
fprintf('eta_glass = %.2f Ohm\n', eta_glass);
fprintf('Matching condition check: sqrt(eta_air * eta_glass) = %.2f Ohm\n', sqrt(eta_air*eta_glass));

%% ============================================================
%% TASK 8: |Gamma| vs Frequency (5 GHz to 15 GHz)
%% ============================================================
f = linspace(4e9, 16e9, 1000);   % frequency sweep

% phase constant inside coating at each frequency
beta_coat = 2*pi*f*sqrt(er_coat) / c;

% electrical thickness of coating at each frequency
beta_t = beta_coat * t_coat;

% Reflection coefficient of 3-layer stack (air/coating/glass)
% Using impedance transformation formula:
% Z_in = eta_coat * (eta_glass + j*eta_coat*tan(beta*t)) / (eta_coat + j*eta_glass*tan(beta*t))
% Gamma = (Z_in - eta_air) / (Z_in + eta_air)

Z_in = eta_coat .* (eta_glass + 1j*eta_coat.*tan(beta_t)) ./ ...
                   (eta_coat  + 1j*eta_glass.*tan(beta_t));

Gamma = (Z_in - eta_air) ./ (Z_in + eta_air);

Gamma_mag   = abs(Gamma);
Return_loss = -20*log10(Gamma_mag);   % return loss in dB (positive value)

%% ============================================================
%% TASK 9: Find 20 dB bandwidth
%% ============================================================
threshold = 20;   % dB
above_20dB = Return_loss >= threshold;

% Find the frequency indices where return loss crosses 20 dB
crossings = diff(above_20dB);
idx_rise = find(crossings == 1);
idx_fall = find(crossings == -1);

f_low  = f(idx_rise(1)) / 1e9;    % GHz
f_high = f(idx_fall(end)) / 1e9;  % GHz
BW_20dB = f_high - f_low;

fprintf('\n=== Task 9: 20 dB Bandwidth ===\n');
fprintf('Lower edge : %.2f GHz\n', f_low);
fprintf('Upper edge : %.2f GHz\n', f_high);
fprintf('20 dB Bandwidth = %.2f GHz\n', BW_20dB);

%% ============================================================
%% PLOT 1: |Gamma| vs Frequency
%% ============================================================
figure(1);
plot(f/1e9, Gamma_mag, 'b-', 'LineWidth', 2);
xlabel('Frequency (GHz)', 'FontSize', 13);
ylabel('|\Gamma|', 'FontSize', 13);
title('Group 6 — Reflection Coefficient Magnitude vs Frequency', 'FontSize', 13);
grid on;
xline(10, 'r--', 'f_{design} = 10 GHz', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.5);
ylim([0 0.25]);
xlim([5 15]);

%% ============================================================
%% PLOT 2: Return Loss vs Frequency (for Task 9)
%% ============================================================
figure(2);
plot(f/1e9, Return_loss, 'b-', 'LineWidth', 2);
hold on;
yline(20, 'r--', '20 dB threshold', 'LineWidth', 1.5);
xline(f_low,  'g--', sprintf('%.1f GHz', f_low),  'LineWidth', 1.2);
xline(f_high, 'g--', sprintf('%.1f GHz', f_high), 'LineWidth', 1.2);
xlabel('Frequency (GHz)', 'FontSize', 13);
ylabel('Return Loss (dB)', 'FontSize', 13);
title('Group 6 — Return Loss vs Frequency (Single-layer ARC)', 'FontSize', 13);
legend('Return Loss', '20 dB threshold', 'Location', 'south');
grid on;
xlim([5 15]);
ylim([0 70]);
% shade the 20dB bandwidth region
x_fill = [f_low, f_high, f_high, f_low];
y_fill = [0, 0, 20, 20];
fill(x_fill, y_fill, 'g', 'FaceAlpha', 0.15, 'EdgeColor', 'none');
text((f_low+f_high)/2, 5, sprintf('BW = %.2f GHz', BW_20dB), ...
    'HorizontalAlignment','center', 'FontSize', 12, 'Color', 'k');

%% ============================================================
%% EXTENSION: Thickness sensitivity (±10%)
%% ============================================================
figure(3);
hold on;
colors = {'b', 'r', 'g'};
labels = {'-10% thickness', 'Nominal (6.12 mm)', '+10% thickness'};
thickness_values = [t_coat*0.9, t_coat, t_coat*1.1];

for k = 1:3
    t_k = thickness_values(k);
    beta_t_k = beta_coat * t_k;
    Z_in_k = eta_coat .* (eta_glass + 1j*eta_coat.*tan(beta_t_k)) ./ ...
                         (eta_coat  + 1j*eta_glass.*tan(beta_t_k));
    Gamma_k = (Z_in_k - eta_air) ./ (Z_in_k + eta_air);
    RL_k    = -20*log10(abs(Gamma_k));
    plot(f/1e9, RL_k, colors{k}, 'LineWidth', 2, 'DisplayName', labels{k});
end

yline(20, 'k--', '20 dB', 'LineWidth', 1.2);
yline(15, 'm--', '15 dB', 'LineWidth', 1.2);
xline(10, 'k:', 'f_{design}', 'LineWidth', 1.2);
xlabel('Frequency (GHz)', 'FontSize', 13);
ylabel('Return Loss (dB)', 'FontSize', 13);
title('Group 6 — Thickness Sensitivity Analysis (Extension Task)', 'FontSize', 13);
legend('Location', 'south', 'FontSize', 11);
grid on;
xlim([5 15]);
ylim([0 70]);

%% Print sensitivity results at design frequency
fprintf('\n=== Extension: Thickness Sensitivity at 10 GHz ===\n');
for k = 1:3
    t_k     = thickness_values(k);
    bt_des  = 2*pi*f_design*sqrt(er_coat)/c * t_k;
    Z_des   = eta_coat * (eta_glass + 1j*eta_coat*tan(bt_des)) / ...
                        (eta_coat  + 1j*eta_glass*tan(bt_des));
    G_des   = (Z_des - eta_air)/(Z_des + eta_air);
    RL_des  = -20*log10(abs(G_des));
    fprintf('%s : Return Loss at 10 GHz = %.1f dB\n', labels{k}, RL_des);
end

%% ============================================================
%% TASK 11: TWO-LAYER BINOMIAL COATING (ANALYTICAL MODEL)
%% ============================================================

% Given from report /  CST design
er_c1 = 1.22;     % layer 1 (air side)
er_c2 = 1.84;     % layer 2 (substrate side)

d1 = 6.78e-3;     % thickness layer 1
d2 = 5.534e-3;     % thickness layer 2

eta_c1 = eta0 / sqrt(er_c1);
eta_c2 = eta0 / sqrt(er_c2);

beta_c1 = 2*pi*f*sqrt(er_c1)/c;
beta_c2 = 2*pi*f*sqrt(er_c2)/c;

%% ---- Layer 2 seen from substrate ----
Zin2 = eta_c2 .* (eta_glass + 1j*eta_c2.*tan(beta_c2*d2)) ./ ...
                 (eta_c2 + 1j*eta_glass.*tan(beta_c2*d2));

%% ---- Layer 1 on top of layer 2 ----
Zin_2layer = eta_c1 .* (Zin2 + 1j*eta_c1.*tan(beta_c1*d1)) ./ ...
                       (eta_c1 + 1j*Zin2.*tan(beta_c1*d1));

%% Reflection coefficient
Gamma_2layer = (Zin_2layer - eta_air) ./ (Zin_2layer + eta_air);
RL_2layer = -20*log10(abs(Gamma_2layer));

%% ============================================================
%% PLOT 4: SINGLE vs TWO LAYERS COMPARISON
%% ============================================================

figure(4);
plot(f/1e9, Return_loss, 'b', 'LineWidth', 2); hold on;
plot(f/1e9, RL_2layer, 'r', 'LineWidth', 2);

yline(20, 'k--', '20 dB threshold', 'LineWidth', 1.2);
xline(10, 'k:', 'f_{design}', 'LineWidth', 1.2);

xlabel('Frequency (GHz)');
ylabel('Return Loss (dB)');
title('Single-Layer vs Two-Layer Anti-Reflection Coating');
legend('Single Layer', 'Two Layer');
grid on;
xlim([4 16]);
ylim([0 70]);

%% ============================================================
%% TWO-LAYER BANDWIDTH (20 dB)
%% ============================================================

idx2 = RL_2layer >= 20;

fL2 = f(find(idx2,1,'first'))/1e9;
fH2 = f(find(idx2,1,'last'))/1e9;
BW2 = fH2 - fL2;

fprintf('\n=== TWO-LAYER RESULTS ===\n');
fprintf('Lower edge : %.2f GHz\n', fL2);
fprintf('Upper edge : %.2f GHz\n', fH2);
fprintf('Bandwidth  : %.2f GHz\n', BW2);

fprintf('\nImprovement factor = %.2f\n', BW2 / BW_20dB);