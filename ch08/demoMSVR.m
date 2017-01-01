% Demo for Multioutput Support Vector Rregression (MSVR)
clear, clc
% Setup path
addpath('./msvr/'), addpath('../simpleR/')
% Creating synthetic data
N = 1000; X = [sin(1:N)' cos(1:N)' randn(N,1)];
[N d] = size(X);      % samples x dim
Y = [sin(1:N)' cos(1:N)']; [N,Q]=size(Y);
% Split training-testing data
rate = 0.1;
r = randperm(N);                 % random index
ntrain = round(rate*N);          % #training samples
Xtrain = X(r(1:ntrain),:);       % training set
Ytrain = Y(r(1:ntrain),:);       % observed training variables
Xtest  = X(r(ntrain+1:end),:);   % test set
Ytest  = Y(r(ntrain+1:end),:);   % observed test variables
%% Remove the mean of Y for training only
Ntrain = size(Xtrain,1); my      = mean(Ytrain);
Ytrain  = Ytrain - repmat(my,Ntrain,1);
%% Training with pairs Xtrain-Ytrain
% Parameters:
%  - C: penalization (regularization) parameter
%  - epsilon: tolerated error, defines the insensitivity zone
%  - sigma: lengthscale of the RBF kernel
%  - tol is a very small number (like 1e-15) for early stopping the
%    optimization of the IRWLS algorithm
ker = 'rbf'; epsilon = 0.1; C = 2; sigma = 1; tol = 1e-10;
[Beta,NSV,val] = msvr(Xtrain,Ytrain,ker,C,epsilon,sigma,tol);
% Prediction on new test data Xtest
% Build the test kernel matrix
Ktest = kernelmatrix('rbf',Xtest',Xtrain',sigma);
Ntest = size(Xtest,1);
testmeans = repmat(my,Ntest,1);
Ypred = Ktest * Beta + testmeans;
figure(1), clf
for q = 1:Q
    subplot(Q,1,q),plot(Ytest(:,q),Ypred(:,q),'k.')
    title(['Variable ' num2str(q)])
    xlabel('Actual'), ylabel('Prediction')
    res(q) = assessment(Ytest(:,q),Ypred(:,q),'regress'); res(q).R
end
