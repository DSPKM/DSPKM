function values = BER_and_MSE(ypred,y)

% BER
[M,Nb_frm]=size(y.input);
values.ber=zeros(M,1);
for kt=1:M
    values.ber(kt,1)=sum(y.input(kt,:)~=ypred.output(kt,:))/Nb_frm;
end

% MSE
N=length(ypred.ch_est_fd);
L=length(y.path);
% frequency domain
values.mse_fd=mean(abs(ypred.ch_est_fd-fft(y.path,N)).^2);
% temporal domain
ch_est_td=ifft(ypred.ch_est_fd);
values.mse_td=mean(abs(ch_est_td(1:L)-y.path).^2);

