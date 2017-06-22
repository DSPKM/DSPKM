% Xs = data in source domain, Xt = data in the taret domain
sigmax = estimateSigma(Xs);
Kss = kernelmatrix('rbf', Xs', Xs', sigmax);
Ktt = kernelmatrix('rbf', Xt', Xt', sigmax);
Kst = kernelmatrix('rbf', Xs', Xt', sigmax);
Kts = kernelmatrix('rbf', Xt', Xs', sigmax);
K = [Kss Kst; Kts Ktt];
L = [ 1/(length(Xs).^2)*ones(length(Xs)) ...
      1/(length(Xs)*length(Xt))*ones(length(Xs),length(Xt)); ...
      1/(length(Xs)*length(Xt))*ones(length(Xt),length(Xs)) ...
      1/(length(Xt).^2)*ones(length(Xt)) ];
MMD = trace(K*L);