function display_results_OFDM(solution,conf)

SNR = conf.SIR;

SVM_results=mean(cell2mat(struct2cell(cat(1,solution{1}.SVM_OFDM(:).BER_and_MSE))),2);
LS_results=mean(cell2mat(struct2cell(cat(1,solution{1}.LS_OFDM(:).BER_and_MSE))),2);

%subplot(221)
figure(1); hold on
semilogy(SNR,SVM_results(1),'ob',SNR,LS_results(1),'+r')
xlabel('SNR'), ylabel('BER');
set(gca,'yscale','log'); grid on

% %subplot(222)
% figure(2)
% semilogy(SNR,mean(LS_results(1,:),2),'r',SNR,min(SVM_results(1,:)'),'k');
% legend('LS','SVM');

figure(2); hold on
% subplot(223)
semilogy(SNR,SVM_results(2),'ob',SNR,LS_results(2),'+r')
xlabel('SNR'), ylabel('MSE frequency domain');
set(gca,'yscale','log'); grid on

figure(3)
% subplot(224)
plot(SNR,SVM_results(3),'ob',SNR,LS_results(3),'+r'); %hold on
xlabel('SNR'), ylabel('MSE temporal domain');
set(gca,'yscale','log'); grid on


