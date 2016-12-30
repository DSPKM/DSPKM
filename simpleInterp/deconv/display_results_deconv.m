function solution_summary = display_results_deconv(solution,conf)
% Initials
algs = fields(solution);
nalgs = length(algs);
options = {'FontSize',20,'Interpreter','Latex'};
options2 = {'FontSize',20,'FontName','Times New Roman'};
% Figures
figure
for ia = 1:nalgs
    subplot(1,nalgs,ia)
    plot(solution.(algs{ia})(end).Ytest,'LineWidth',2); hold on
    plot(solution.(algs{ia})(end).Ytestpred,'ro','LineWidth',2)
    title(strrep(algs{ia},'_','-'),options{:});
    axis tight; set(gca,options2{:})
    if ia == 1; H = legend('Original','Deconv.'); set(H,options{:}); end
end
% Performance summary
solution_summary = results_summary(solution,conf);