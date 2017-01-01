function [Ey, Vy] = testVHGPR(model, x_tst)

D = size(x_tst,2);

covfuncSignal = model.covfuncSignal;
covfuncNoise  = model.covfuncNoise;
LambdaTheta   = model.LambdaTheta;
loghyper    = model.loghyper;
x_tr          = model.Xtrain;
y_tr          = model.Ytrain;

lengthscales=loghyper(1:D);
x_tst = x_tst./(ones( size(x_tst,1) ,1)*exp(lengthscales(:)'));

[Ey, Vy]= vhgpr(LambdaTheta, covfuncSignal, covfuncNoise, 0, x_tr, y_tr, x_tst);
