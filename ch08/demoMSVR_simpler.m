%% Multioutput Support Vector Rregression (MSVR)
%  - C      : penalization (regularization) parameter
%  - epsilon: tolerated error, defines the insensitivity zone
%  - sigma  : lengthscale of the RBF kernel
%  - tol    : early stopping tolerance of the IRWLS algorithm
ker = 'rbf'; epsilon = 0.1; C = 2; sigma = 1; tol = 1e-10;
% Training with pairs Xtrain-Ytrain
[Beta,NSV,val] = msvr(Xtrain,Ytrain,ker,C,epsilon,sigma,tol);
% Prediction on new test data Xtest
Ktest = kernelmatrix(ker,Xtest',Xtrain',sigma);
Ntest = size(Xtest,1); testmeans = repmat(my,Ntest,1);
Ypred = Ktest * Beta + testmeans;