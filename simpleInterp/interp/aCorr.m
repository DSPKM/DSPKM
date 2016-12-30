function [rxx,t_rxx] = aCorr(Xtrain,Ytrain,paso)

% Initials
K = 4;
N = length(Xtrain);
Nc_ent = K*N;
fs_corr = 1/paso;
fs = mean(diff(Xtrain));
T = paso * round(1/(fs*paso));
fs = 1/T;
F = fs_corr/fs;
Nc_test = K*N*F;

% Autocorrelation
deltaf = fs / Nc_ent;
f = linspace(-fs/2,fs/2-deltaf,Nc_ent);
Yf = sqrt(lombperiod(Ytrain,Xtrain,f));
Yf_flip = Yf(end:-1:1);
Yf_flip = [0; Yf_flip(1:end-1)];
Yf = fftshift(Yf + Yf_flip);
Yfcent = fftshift(Yf); Yfcent = Yfcent(:);
N_der = ceil((Nc_test-Nc_ent)/2); N_izq = N_der;
Yf_padded=fftshift([zeros(N_izq,1); Yfcent; zeros(N_der,1)]);
acorr = fftshift(real(ifft(abs(Yf_padded).^2)));
rxx = (acorr(ceil(Nc_test/2)+1:end))./max(acorr);
t_rxx = (0:1/fs_corr:(length(rxx)-1)*(1/fs_corr));