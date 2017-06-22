% Xtrain:  Train samples [samples x features]
% Xtest:   Test samples  [samples x features]
% C_tot:   Gaussian mixture parameter estimates
% IDX_tot: Clusters from Gaussian mixture distribution
KbagUL = zeros(size(Xtrain,1),size(Xtest,1));
nk = 0;
for k = Kvector % Number of clustering realizations
    nk = nk + 1;
    for n = 1:N   % Number of realizations
        if ~isempty(C_tot{nk,n})
            Pgmm = posterior(C_tot{nk,n},Xtrain);
            [ID_UL PP]= closerClusterGMM(Xtest,C_tot{nk,n},'resoft');
            idx_tot=IDX_tot{nk,n};
            idx_tot=idx_tot(1:size(Xtrain,1),:);
            for p = 1:length(ID_UL)
                for q = 1:length(idx_tot)
                    KbagUL(q,p) = KbagUL(q,p) + PP(p,:)*Pgmm(q,:)';
                end
            end
        end
    end
end
KbagUL = KbagUL/max(max(KbagUL));