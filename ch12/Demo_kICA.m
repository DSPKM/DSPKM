%% Example of ICA and Kernel ICA
% fast ICA: https://research.ics.aalto.fi/ica/fastica/
% kernel ICA: http://www.di.ens.fr/~fbach/kernel-ica/
N = 1000;
s(1,:) = sign(randn(1,N)).*abs(randn(1,N)).^2;
s(2,:) = sign(randn(1,N)).*abs(randn(1,N)).^2; 
rng(2); W = randn(2); 
% Mixing
x = W * s;
% ICA Unmixing 
[ss Aica Wica] = fastica(x); % function in fastICA toolbox
s_hat_ica   = Wica * x; 
% kICA Unmixing 
Wcca = kernel_ica(x); % function in Bach's toolbox
s_hat_kica = Wcca * x;