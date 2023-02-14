%% Initialization
close all
clear
clc
addpath('/Users/francescaronchini/poli/rir-simulations/src/lib')

%% Setup
procFs = 16000;                      % Sampling frequency (Hz)
c = 343;                            % Sound velocity (m/s)
nsample = 2*1024;                   % Length of desired RIR
N_harm = 30;                        % Maximum order of harmonics to use in SHD
K = 1;                              % Oversampling factor

L = [5 6 4];                        % Room dimensions (x,y,z) in m
sphLocation = [1.6 4.05 1.7];       % Receiver location (x,y,z) in m
s = [3.37 4.05 1.7];                % Source location(s) (x,y,z) in m

HP = 1;                             % Optional high pass filter (0/1)
src_type = 'o';                     % Directional source type ('o','c','s','h','b')
[src_ang(1),src_ang(2)] = mycart2sph(sphLocation(1)-s(1),sphLocation(2)-s(2),sphLocation(3)-s(3)); % Towards the receiver

%% Example 1
order = 6;                          % Reflection order (-1 is maximum reflection order)
refl_coeff_ang_dep = 0;             % Real reflection coeff(0) or angle dependent reflection coeff(1)
%beta = 0.3607;                     % Reverbration time T_60 (s)
%beta = 0.2*ones(1,6);             % Room reflection coefficients [\beta_x_1 \beta_x_2 \beta_y_1 \beta_y_2 \beta_z_1 \beta_z_2]
beta = [1 0.7 0.7 0.5 0.2 1];

sphRadius = 0.042;                  % Radius of the spherical microphone array (m)
sphType = 'rigid';                  % Type of sphere (open/rigid)
mic = [pi/4 pi; pi/2 pi];		    % Microphone positions (azimuth, elevation)

[h1, H1, beta_hat] = smir_generator(c, procFs, sphLocation, s, L, beta, sphType, sphRadius, mic, N_harm, nsample, K, order, refl_coeff_ang_dep, HP, src_type, src_ang);
%% Plotting

mic_to_plot = 1;

figure(1);
ax1(1)=subplot(211);
plot([0:nsample-1]/procFs,h1(mic_to_plot,1:nsample), 'r')
xlim([0 (nsample-1)/procFs]);
title(['Room impulse response at microphone ', num2str(mic_to_plot),' (real refl coeff)']);
xlabel('Time (s)');
ylabel('Amplitude');


%% Sabine formula vs Estimate_T60
% RT60 = 0.049 V/A where A = sum(beta*S)

Sx1 = L(1) * L(3); % x*z
Sx2 = Sx1;
fprintf('S x1, x2: %d %d\n', Sx1, Sx2)

Sy1 = L(2) * L(3); % x*z
Sy2 = Sy1;
fprintf('S y1, y2: %d %d\n', Sy1, Sy2)

Sz1 = L(1) * L(2); % x*y
Sz2 = Sz1;
fprintf('S z1, z2: %d %d\n', Sz1, Sz2)

A1 = (Sx1 * (1-beta(1))) + (Sx2 * (1-beta(2))) + (Sy1 * (1-beta(3))) + (Sy2 * (1-beta(4))) + (Sz1 * (1-beta(5))) + (Sz2 * (1-beta(6)));
A2 = (Sx1 * beta(1)) + (Sx2 * beta(2)) + (Sy1 * beta(3)) + (Sy2 * beta(4)) + (Sz1 * beta(5)) + (Sz2 * beta(6));
fprintf('A1: %f\n', A1);
fprintf('A2: %f\n', A2);
fprintf('V: %f\n', L(1)*L(2)*L(3));

RT60_A1 = 0.049*((L(1) * L(2) * L(3))/A1);
RT60_A2 = 0.049*((L(1) * L(2) * L(3))/A2);
fprintf('RT60 calculated for A1: %f\n', RT60_A1);
fprintf('RT60 calculated for A2: %f\n', RT60_A2);

plot_ok = 1;
T60 = Estimate_T60(h1,procFs,plot_ok);
fprintf("T60: %s\n", T60);

%% beta = 0.3607, comparing all
beta = 0.3607;
[h1, H1, beta_hat] = smir_generator(c, procFs, sphLocation, s, L, beta, sphType, sphRadius, mic, N_harm, nsample, K, order, refl_coeff_ang_dep, HP, src_type, src_ang)

mic_to_plot = 1;

figure(1);
ax1(1)=subplot(211);
plot([0:nsample-1]/procFs,h1(mic_to_plot,1:nsample), 'r')
xlim([0 (nsample-1)/procFs]);
title(['Room impulse response at microphone ', num2str(mic_to_plot),' (real refl coeff)']);
xlabel('Time (s)');
ylabel('Amplitude');

A1 = (Sx1 * (1-beta_hat)) + (Sx2 * (1-beta_hat)) + (Sy1 * (1-beta_hat)) + (Sy2 * (1-beta_hat)) + (Sz1 * (1-beta_hat)) + (Sz2 * (1-beta_hat));
A2 = (Sx1 * beta_hat) + (Sx2 * beta_hat) + (Sy1 * beta_hat) + (Sy2 * beta_hat) + (Sz1 * beta_hat) + (Sz2 * beta_hat);
fprintf('A1: %f\n', A1);
fprintf('A2: %f\n', A2);
fprintf('V: %f\n', L(1)*L(2)*L(3));

RT60_A1 = 0.049*((L(1) * L(2) * L(3))/A1);
RT60_A2 = 0.049*((L(1) * L(2) * L(3))/A2);
fprintf('RT60 calculated for A1: %f\n', RT60_A1);
fprintf('RT60 calculated for A2: %f\n', RT60_A2);

plot_ok = 1;
T60 = Estimate_T60(h1,procFs,plot_ok);
fprintf("T60 : %s\n", T60);






