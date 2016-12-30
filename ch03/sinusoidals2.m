%% Example of synthetic data
ntr = 100; nsecs = 20;
t_train = nsecs*rand(ntr,1);
fdata = 0.3;
Ampdata = 3;
phidata = 0.5;
% Generate data
y_train = Ampdata*cos(2*pi*fdata*t_train + phidata);
% Hypothesis frequencies
f = 0:.1:15;
f = f(2:end);   % zero mean
%f = [0.1 0.2 0.3 0.4 0.5];
ntest = 1000;
t_test = linspace(0,nsecs,ntest);
% Least squares optimization of the sinusoidal model
[B,C,A,Phi,y_test] = sinusoidals(y_train,t_train,t_test,2*pi*f);
% Plot results
figure(1), plot(t_train,y_train,'.r'); hold on; plot(t_test,y_test,'b'); hold off;
xlabel('t (s)'); ylabel('Estimated and training signal')
figure(2), subplot(211), plot(f,A); grid on; xlabel('f (Hz)'); ylabel('A')
subplot(212), plot(f,Phi); grid on; xlabel('f (Hz)'); ylabel('\phi');