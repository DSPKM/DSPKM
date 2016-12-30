function [predict,coefs] = SVM_OFDM(X,Y,Xtest,N,M,epsilon,gamma,C)

% Initials
[Np,Lp]=size(X);
n = (0:Np-1)';
Y = Np*Y; % Denormalizing

coefs = zeros(Np,Lp);
for i=1:Lp
    % Construct kernel matrix
    H = zeros(Np);
    for j=1:Np
        H(:,j)=X(j,i)*exp(1i*2*pi/Np*(j-1)*n);
    end
    % Train SVM and obtain coefficients
    inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
    [~,model]=SVM(H,Y(:,i),H,inparams);
    coefs(:,i) = getSVs(Y(:,i),model);
end

% Channel estimation
ch_est_fd=mean(coefs,2); % mean over Lp OFDM-symbols (only Np subcarriers)
ch_est_td=ifft(ch_est_fd); % per sub-carrier (for N subcarriers)
ch_est_td_N=[ch_est_td(1:3); zeros(N-3,1)];
predict.ch_est_fd=fft(ch_est_td_N);

% Equalization (ZF) and detection
Nsymb_frm=size(Xtest,2);
predict.output=zeros(Nsymb_frm*N*M,1);
for l=1:Nsymb_frm
    bits_simbofdm=degray(Xtest(:,l)./predict.ch_est_fd,M);
    predict.output((1:N*M)+(l-1)*N*M)=bits_simbofdm;
end
