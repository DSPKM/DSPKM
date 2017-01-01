function yp = testRVM(model,xp)

K = kernelmatrix('rbf',xp',model.x',model.sigma);
yp = K(:,model.used) * model.alpha;
