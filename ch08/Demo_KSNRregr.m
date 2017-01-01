% Comparing KRR and KSNR
clear, clc, close all %; warning off;
% Setup paths
addpath(genpath('../simpleR/')), addpath('./ksnr/')
% Load Data
load data/motorcycle.mat; Y = y;
%% Split training-testing data
rate = 0.1;
[n d] = size(X);                 % samples x bands
r = randperm(n);                 % random index
ntrain = round(rate*n);          % #training samples
Xtrain = X(r(1:ntrain),:);       % training set
Ytrain = Y(r(1:ntrain),:);       % observed training variable
Xtest = X(r(ntrain+1:end),:);    % test set
Ytest = Y(r(ntrain+1:end),:);    % observed test variable
ntest = size(Ytest,1);
%% Remove the mean of Y for training only
my = mean(Ytrain);
Ytrain = Ytrain - repmat(my,ntrain,1);
% KRR
modelKRR = trainKRR(Xtrain,Ytrain);
Yp_KRR = testKRR(modelKRR,Xtest) + repmat(my,ntest,1);
results_KRR = assessment(Yp_KRR,Ytest,'regress')
% KSNR
modelKSNR = trainKSNR(Xtrain,Ytrain);
Yp_KSNR = testKSNR(modelKSNR,Xtest) + repmat(my,ntest,1);
results_KSNR = assessment(Yp_KSNR,Ytest,'regress')
% Residuals
RESIDUALS = [Ytest-Yp_KRR Ytest-Yp_KSNR];
% Statistical analysis of the bias and the accuracy
anova1(RESIDUALS); anova1(abs(RESIDUALS));
% Scatter plots and marginal distributions
figure, scatterhist(Ytest,Yp_KRR), title('KRR'); grid on
xlabel('Observed signal'); ylabel('Predicted signal')
figure, scatterhist(Ytest,Yp_KSNR), title('KSNR'); grid on
xlabel('Observed signal'); ylabel('Predicted signal')