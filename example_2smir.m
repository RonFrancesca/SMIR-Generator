procFs = 8000;                      % Sampling frequency (Hz)
c = 343;                            % Sound velocity (m/s)
nsample = 512;                      % Length of desired RIR
N_harm = 40;                        % Maximum order of harmonics to use in SHD
K = 2;                              % Oversampling factor

L = [10 6 8];                      % Room dimensions (x,y,z) in m

sphLocation = [5 1 4];       % Receiver location (x,y,z) in m
s = [2.37 4.05 4.4];                % Source location(s) (x,y,z) in m

beta = [1 0.7 0.7 0.5 0.2 1];       % Room reflection coefficients [\beta_x_1
                                    % \beta_x_2 \beta_y_1 \beta_y_2 \beta_z_1 \beta_z_2]
order = -1;                         % Reflection order (-1 is maximum reflection order)

sphRadius = 0.042;                     % Radius of the sphere (m)
sphType = 'rigid';                  % Type of sphere (open/rigid)

mic = [pi/2 pi/4; pi/2 pi/2];                % Microphone positions (azimuth, elevation)

[h, H, beta_hat] = smir_generator(c, procFs, sphLocation, s, L, beta, sphType, sphRadius, mic, N_harm, nsample, K, order);
display(size(h))

figure;
subplot(211);
plot([0:nsample-1]/procFs, h(1,1:nsample), 'r')
hold all
plot([0:nsample-1]/procFs, h(2,1:nsample), 'b')
xlim([0 (nsample-1)/procFs]);
title(['Room impulse response at microphone ', num2str(1)]);
xlabel('Time (s)');
ylabel('Amplitude');
legend('SMIR generator mic 1', 'SMIR generator mic 2');

subplot(212);
plot([0:nsample-1], H(1,1:nsample), 'r')
hold all
plot([0:nsample-1], H(2,1:nsample), 'b')
xlim([0 (nsample-1)]);
title(['Room impulse response at microphone ', num2str(1)]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
legend('SMIR generator mic 1', 'SMIR generator mic 2');


