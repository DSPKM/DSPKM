function Ypred = testRLR(model,X)

[n d] = size(X);
Xtest = [ones(n,1) X];
Ypred = Xtest*model.W;
