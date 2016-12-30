function solution_summary = display_results_ultrasound(solution,conf)

algs=fields(solution);
y = solution.(algs{1})(50).Ytest;
n = length(y); nalgs=length(algs);
figure
for ia=1:nalgs
    xpred=solution.(algs{ia})(50).coefs;
    ypred=solution.(algs{ia})(50).Ytestpred;
    subplot(nalgs,2,(ia-1)*2+1); plot(1:n,xpred); title(algs{ia}(8:end)), axis tight; xlim([1 n]); ylim([-.1 .5])
    subplot(nalgs,2,(ia-1)*2+2); plot(1:n,y,':g',1:n,ypred(1:n),'r'); title(algs{ia}(8:end)), axis tight; xlim([1 n]); ylim([-.6 .6])
end
figure
Bscan4 = cat(2,solution.deconv_AKSM.Ytest);
subplot(2,2,1), surf(Bscan4), title('B-scan')
axis tight, shading interp, alpha(.5)
for ia=1:nalgs
    alg=func2str(conf.machine.algs{ia});
    Xpred = cat(2,solution.(algs{ia}).coefs);
    subplot(2,2,ia+1), surf(Xpred), title(algs{ia}(8:end))
    axis tight, shading interp, alpha(.5)
end
% Performance summary
solution_summary = results_summary(solution,conf);

