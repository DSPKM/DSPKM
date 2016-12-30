function solution_summary = display_results_MAE(solution,conf)

load(conf.data.path)
nm=length(data);
color={'ob-','+r-'};
figure
for il=1:nm
    subplot(ceil(sqrt(nm)),ceil(sqrt(nm)),il)
    algs=fields(solution); algtitle=algs;
    plot(solution.(algs{1})(il).Ytest,'k-'); hold on
    for ia=1:length(algs)
        algtitle{ia}=strrep(algs{ia},'_','-');
        plot(solution.(algs{ia})(il).Ytestpred,color{ia});
    end
    axis tight; title(data{il}.currentName);
    ylabel(sprintf('Price (%c)',8364)); legend(['Test';algtitle])
end
figure
for il=1:nm
    subplot(ceil(sqrt(nm)),ceil(sqrt(nm)),il); hold on
    test=solution.(algs{1})(il).Ytest;
    for ia=1:length(algs)
        stem(abs(solution.(algs{ia})(il).Ytestpred-test),color{ia});
    end
    axis tight; title(data{il}.currentName);
    ylabel(sprintf('Error (%c)',8364)); legend(algtitle)
end
% Performance summary
solution_summary = results_summary(solution,conf);
