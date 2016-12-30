%% Load data examples
load Noisy_ecg.mat
fs = 600;   % We know the sampling frequency
ts = 1/fs; n = length(clean_ecg); t = ts*(0:n-1);
% Time axis to plot
tmax = 20; % [s]
ind = find(t<tmax);
%% Plots in time
figure(1),
subplot(311), plot(t(ind),clean_ecg(ind)); ylabel('mV'),
subplot(312), plot(t(ind),noise(ind)); ylabel('mV'),
subplot(313), plot(t(ind),ecg_signal(ind));
ylabel('mV'), xlabel('t (s)')
%% Plots in frequency
X1 = abs(fftshift(fft(clean_ecg(ind)-mean(clean_ecg(ind)))));
X2 = abs(fftshift(fft(noise(ind)-mean(noise(ind)))));
X3 = abs(fftshift(fft(ecg_signal(ind)-mean(ecg_signal(ind)))));
f = linspace(-fs/2,fs/2,length(X1));
figure(2),
subplot(311), plot(f,X1); ylabel('FFT'),
axis tight, ax = axis; ax(1:2)=[-100 100]; axis(ax);
subplot(312), plot(f,X2); ylabel('FFT'),
axis(ax); subplot(313), plot(f,X3); ylabel('FFT'), xlabel('f (Hz)')
%% Try to filter out ...
filtord = 256+1;    % Try other orders
fc = 50;            % Try e.g. cutting freq 80 and 50
b = fir1(filtord,2*fc/fs);
[H,f] = freqz(b,1,1024,fs);  % Check and plot the design is OK
figure(3),
subplot(211), stem(b); axis tight; xlabel('n');
subplot(212), plot(f,abs(H)); axis tight; xlabel('f (Hz)');
%% ... but check for distortion in the residuals
ecg_filtered = filtfilt(b,1,ecg_signal);
resid = ecg_signal - ecg_filtered;
% Plot results
figure(4)
subplot(211), plot(t(ind),ecg_filtered(ind)), ylabel('mV'); axis tight
subplot(212), plot(t(ind),resid(ind)), ylabel('mV'); axis tight; xlabel('t(s)');
