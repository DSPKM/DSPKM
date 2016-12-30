function solution_summary = display_results_interp(solution,conf)
% Initials
algs = fields(solution);
nalgs = length(algs);
Xtest = solution.(algs{1})(end).Xtest;
fm = 1/conf.data.T;
f = linspace(-fm/2,fm/2,length(Xtest))';
Ytf = abs(fftshift(fft(solution.(algs{1})(end).Ytest)));
options = {'FontSize',20,'Interpreter','Latex'};
options2 = {'FontSize',18,'FontName','Times New Roman'};
% Figures
figure
for ia = 1:nalgs
    subplot(3,nalgs,ia)
    plot(solution.(algs{ia})(end).Xtrain,solution.(algs{ia})(end).Ytrain,'ok'); hold on
    plot(Xtest,solution.(algs{ia})(end).Ytest);
    plot(Xtest,solution.(algs{ia})(end).Ytestpred,'r')
    title(strrep(algs{ia},'_','-'),options{:});
    if ia==1; H=legend('$y_{train}$','$y_{test}$','$y_{pred}$'); set(H,options{:}); end
    axis tight; set(gca,options2{:})
    subplot(3,nalgs,nalgs+ia)
    stem(solution.(algs{ia})(end).coefs);
    axis tight; set(gca,options2{:})
    subplot(3,nalgs,2*nalgs+ia)
    plot(f, Ytf, 'b'); hold on;
    plot(f,abs(fftshift(fft(solution.(algs{ia})(end).Ytestpred))),'r');
    xlabel('f',options{:}); xlim([0, .2]); set(gca,options2{:})
    if ia == 1; H = legend('Test','Pred.'); set(H,options{:}); end
end
suptitle(['SNR=',num2str(conf.SNR),' - u=',num2str(conf.u)])
% Performance summary
solution_summary = results_summary(solution,conf);