function [predict,coefs] = LS_OFDM(X,Y,Xtest,N,M)

coefs=zeros(size(Y));
for l=1:size(Y,2)
    coefs(:,l)=fft(Y(:,l));
end

%channel estimation
ch_est_fd=mean(coefs./X,2); % mean over Lp OFDM-symbols (only Npil subcarriers)
ch_est_td=ifft(ch_est_fd); % per sub-carrier (for N subcarriers)
ch_est_td_N=[ch_est_td(1:3); zeros(N-3,1)];
predict.ch_est_fd=fft(ch_est_td_N);

% Equalization (ZF) and detection
Nsymb_frm=size(Xtest,2);
predict.output=zeros(Nsymb_frm*N*M,1);
for l=1:Nsymb_frm
    bits_symbofdm=degray(Xtest(:,l)./predict.ch_est_fd,M);
    predict.output((1:N*M)+(l-1)*N*M)=bits_symbofdm;
end
