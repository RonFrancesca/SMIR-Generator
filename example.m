% Comparing RIR and SMIR
procFs = 8000;                      % Sampling frequency (Hz)
c = 343;                            % Sound velocity (m/s)
nsample = 1024;                     % Length of desired RIR
N_harm = 40;                        % Maximum order of harmonics to use in SHD
K = 4;                              % Oversampling factor

L = [4 6 8];                        % Room dimensions (x,y,z) in m
sphLocation = [2 3.2 4];            % Receiver location (x,y,z) in m
s = [2.37 4.05 4.4];                % Source location(s) (x,y,z) in m
beta = [0.0 0.0 0.0 0.0 0.0 0.0];       % Room reflection coefficients [\beta_x_1
                                    % \beta_x_2 \beta_y_1 \beta_y_2 \beta_z_1 \beta_z_2]
order = 1;                         % Reflection order (-1 is maximum reflection order)

sphRadius = 0.0;                    % Radius of the sphere (m)
sphType = 'open';                  % Type of sphere (open/rigid)

mic = [0 0];           % Microphone positions (azimuth, elevation)

[h, H, beta_hat] = smir_generator(c, procFs, sphLocation, s, L, beta, sphType, sphRadius, mic, N_harm, nsample, K, order);

figure;
subplot(211);
plot([0:nsample-1]/procFs, h(1,1:nsample), 'g')
hold all;
plot([0:nsample-1]/procFs,h(1,1:nsample), 'r')
xlim([0 (nsample-1)/procFs]);
title(['Room impulse response at microphone ', num2str(1)]);
xlabel('Time (s)');
ylabel('Amplitude');
legend('RIR generator', 'SMIR generator');

subplot(212);
plot((0:1/nsample:1/2)*procFs,mag2db(abs(H(1,1:nsample/2+1))), 'g');
hold all;
plot((0:1/(K*nsample):1/2)*procFs,mag2db(abs(H(1,1:K*nsample/2+1))), 'r');
title(['Room transfer function magnitude at microphone ', num2str(1)]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');
legend('RIR generator', 'SMIR generator');
