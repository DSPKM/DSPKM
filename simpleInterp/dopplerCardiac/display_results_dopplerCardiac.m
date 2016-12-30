function solution_summary = display_results_dopplerCardiac(solution,conf)

% Initials
algs=fields(solution);
nalgs=length(algs);
Xtest=solution.(algs{1})(end).Xtest;
load(conf.data.path)
load(conf.data.path_map)
% Figures
for ia=1:nalgs
    figure
    Vrecons = nan(size(I));
    ind_recons = sub2ind(size(I),Xtest(:,1),Xtest(:,2));
    Vrecons(ind_recons) = solution.(algs{ia})(end).Ytestpred;
    imagesc(t_sistolic,s_depth,Vrecons);
    k = max(abs([min(Vrecons(:)),max(Vrecons(:))]));
    caxis([-k k]); axis tight; colormap(Dmap); custombar('vert',[-k,k]);
    title('V_{recons}'); xlabel('Time (s)'); ylabel('Depth (cm)');
end
% Performance summary
solution_summary = results_summary(solution,conf);
