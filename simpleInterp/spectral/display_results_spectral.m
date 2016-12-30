function display_results_spectral(solution,conf)
cf=conf.data;

figure(1)
alg=fields(solution);
y = solution.(alg{1})(1).Ytest;
subplot(2,1,1); plot(y); xlim([0,cf.n]); ylim([-10.5, 10.5]); xlabel('# sample')
[P,f] = pwelch(y,cf.n,[],[],1);
subplot(2,1,2); plot(f,P/norm(P)); ylim([0, max(P/norm(P))]); xlabel('f')

figure(2)
Cs=conf.vector_loop1;
iC=find(solution.(alg{1})(1).C == Cs);
coefs=solution.(alg{1})(1).coefs;
[P2,f2]=pwelch(coefs,cf.n,[],[],1);
subplot(3,1,iC); plot(f2,P2/norm(P2)); xlabel('f');
title(['$\gamma C = $',num2str(Cs(iC))],'interpreter','latex')

figure(3)
res = y - solution.(alg{1})(1).Ytestpred;
hist(res,100)
