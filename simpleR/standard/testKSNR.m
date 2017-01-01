function yp = testKSNR(model,xp)

K = kernelmatrix('rbf',xp',model.x',model.sigma);
yp = K * model.alpha;