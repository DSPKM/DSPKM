% Signal generation
N = 1000;
n = linspace(0,pi,N);
s = cos(20.*n) + 0.5.*rand(1,N);
figure(1), clf, subplot(221),
plot(n,s), grid on, axis tight
title('Original signal')

% Two scales decomposition
[cA,cD] = dwt(s,'db2');

ssf = idwt(cA,cD,'db2');             % Full reconstruction
ssl = idwt(cA,zeros(1,N/2+1),'db2'); % Inverse using LF
ssh = idwt(zeros(1,N/2+1),cD,'db2'); % Inverse using HF

% Representations
subplot(222), plot(n,ssf)
grid on, axis tight, title('Reconstructed signal')
subplot(223), plot(n,ssl)
grid on, axis tight, title('Low freq. reconstruction')
subplot(224), plot(n,ssh)
grid on, axis tight, title('High freq. reconstruction')