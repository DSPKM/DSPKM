% Example for HRV signal
load ejemploHRV RR
auxRR = RR(500:2500); auxt = cumsum(auxRR);
auxRR = auxRR/1000; auxt = auxt/1000;     % in seconds
% Plot
figure(1), clf
subplot(311), plot(auxRR), grid, hold on, axis tight
subplot(312), plot(auxt,auxRR), grid, hold on, axis tight
%% Remove ectopic beats
aux = find(abs(diff(auxRR))>0.1);
aux = unique([aux,aux+1]);
aux = setdiff(1:length(auxRR), aux);
auxt = auxt(aux);
auxRR = auxRR(aux);
subplot(313), plot(auxt,auxRR); grid, hold on, axis tight
%% Plot spectra
X = abs(fftshift(fft(auxRR-mean(auxRR))));
f = linspace(-0.5, 0.5, length(X));
% Plot results
figure(2), subplot(211), plot(f,X,'b'); hold on; ejes = axis; ejes(1)=0; axis(ejes); xlabel('f (tachogram)');
% Estimation
t_test = 0:.25:length(auxt);
ff = linspace(0,0.5,400);
[B,C,A,Phi,y_test] = sinusoidalLS(auxRR-mean(auxRR),auxt,t_test,2*pi*ff);
subplot(212), plot(ff,A), axis tight, xlabel('f (Hz)'), ylabel('Estimated amplitude');
% Plot results
figure(3),
subplot(211), plot(auxt,auxRR-mean(auxRR)), grid, axis tight, xlabel('t (s)'), ylabel('RR - mean (s)')
subplot(212), plot(t_test,y_test), grid, axis tight, xlabel('t (s)'), ylabel('RR - mean (s)')
