%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMPLE REGRESSION DEMO.
%   -----------------------------------------------------
%        Several statistical algorithms are compared:
%   ------------------------------------------------------
%    * Least Absolute Shrinkage and Selection Operator (LASSO)
%    * Elastic Net (ELASTICNET)
%    * Decision trees (TREE)
%    * Bagging trees (BAGTREE)
%    * Boosting trees (BOOST)
%    * Neural networks (NN)
%    * Extreme Learning Machines (ELM)
%    * Support Vector Regression (SVR)
%    * Kernel Ridge Regression (KRR)
%    * Relevance Vector Machine (RVM)
%    * Gaussian Process Regression (GPR)
%    * Variational Heteroscedastic Gaussian Process Regression (VHGPR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
clear, clc
fontname = 'Bookman'; fontsize = 14; fontunits = 'points';
set(0,'DefaultAxesFontName',fontname,'DefaultAxesFontSize', ...
    fontsize,'DefaultAxesFontUnits',fontunits, ...
    'DefaultTextFontName',fontname, ...
    'DefaultTextFontSize',fontsize,'DefaultTextFontUnits',fontunits,...
    'DefaultLineLineWidth',3, ...
    'DefaultLineMarkerSize',10,'DefaultLineColor',[0 0 0]);
% Paths
addpath(genpath('../simpleR/'))
addpath('../libsvm/')
%% Data
N = 1000;
X = [sin(1:N)', cos(1:N)', tanh(1:N)'] + 0.1*randn(N,3);
Y = sin(1:N)';
VARIABLES = {'SIN', 'COS', 'TANH'};
%% Split training-testing data
rate = 0.1; %[0.05 0.1 0.2 0.3 0.4 0.5 0.6]
[n d] = size(X);                 % samples x bands
r = randperm(n);                 % random index
ntrain = round(rate*n);          % #training samples
Xtrain = X(r(1:ntrain),:);       % training set
Ytrain = Y(r(1:ntrain),:);       % observed training variable
Xtest  = X(r(ntrain+1:end),:);   % test set
Ytest  = Y(r(ntrain+1:end),:);   % observed test variable
%% Remove the mean of Y for training only
my      = mean(Ytrain);
Ytrain  = Ytrain - my;
%% SELECT METHODS FOR COMPARISON
METHODS = {'LASSO' 'ELASTICNET' 'TREE' 'BAGTREE' ...
    'BOOST' 'NN' 'ELM' 'SVR' 'KRR' 'RVM' 'GPR' 'VHGPR'}
% Counter for the method used
m = 0;
%% (1) LASSO
if sum(strcmpi(METHODS,'LASSO'))
    m=m+1;
    t=cputime;
    fprintf('Training LASSO ... \n')
    model_LASSO     = trainLASSO(Xtrain,Ytrain);
    Yp              = testLASSO(model_LASSO,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsLASSO    = assessment(Ypred(:,m),Ytest,'regress');
    tempsLASSO      = cputime-t;
end
%% (2) ELASTIC NET
if sum(strcmpi(METHODS,'ELASTICNET'))
    m=m+1;
    t=cputime;
    fprintf('Training Elastic Net ... \n')
    model_ElasticNet = trainElasticNet(Xtrain,Ytrain);
    Yp               = testElasticNet(model_ElasticNet,Xtest);
    Ypred(:,m)       = Yp + my;
    resultsENET      = assessment(Ypred(:,m),Ytest,'regress');
    tempsENET        = cputime-t;
end
%% (3) TREES
if sum(strcmpi(METHODS,'TREE'))
    m=m+1;
    t=cputime;
    fprintf('Training Trees ... \n')
    model_TREE      = trainTREE(Xtrain,Ytrain);
    Yp              = testTREE(model_TREE,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsTREE     = assessment(Ypred(:,m),Ytest,'regress');
    tempsTREE       = cputime-t;
end
%% (4) Bagging Trees
if sum(strcmpi(METHODS,'BAGTREE'))
    m=m+1;
    t=cputime;
    fprintf('Training Bagging Trees ... \n')
    model_BAGTREE   = trainBAGTREE(Xtrain,Ytrain);
    Yp              = testTREEBAG(model_BAGTREE,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsBAGTREE  = assessment(Ypred(:,m),Ytest,'regress');
    tempsBAGTREE    = cputime-t;
end
%% (5) Boosting trees
if sum(strcmpi(METHODS,'BOOST'))
    m=m+1;
    t=cputime;
    fprintf('Training Boosting Trees ... \n')
    model_BOOST     = trainBOOST(Xtrain,Ytrain);
    Yp              = testBOOST(model_BOOST,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsBOOST    = assessment(Ypred(:,m),Ytest,'regress');
    tempsBOOST      = cputime-t;
end
%% (6) NN
if sum(strcmpi(METHODS,'NN'))
    m=m+1;
    t=cputime;
    fprintf('Training NN ... \n')
    warning off
    model_NN        = trainNN(Xtrain,Ytrain);
    Yp              = testNN(model_NN,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsNN       = assessment(Ypred(:,m),Ytest,'regress');
    tempsNN         = cputime-t;
end
%% (7) Extreme Learning Machine (ELM)
if sum(strcmpi(METHODS,'ELM'))
    m=m+1;
    t=cputime;
    fprintf('Training ELM ... \n')
    model_ELM       = trainELM(Xtrain,Ytrain);
    Yp              = testELM(model_ELM,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsELM      = assessment(Ypred(:,m),Ytest,'regress');
    tempsELM        = cputime-t;
end
%% (8) SVR
if sum(strcmpi(METHODS,'SVR'))
    m=m+1;
    t=cputime;
    fprintf('Training SVR ... \n')
    model_SVR      = trainSVR(Xtrain,Ytrain);
    Yp             = testSVR(model_SVR, Xtest);
    Ypred(:,m)     = Yp + my;
    resultsSVR     = assessment(Ypred(:,m),Ytest,'regress');
    tempsSVR       = cputime-t;
end
%% (9) KRR
if sum(strcmpi(METHODS,'KRR'))
    m=m+1;
    t=cputime;
    fprintf('Training KRR ... \n')
    model_KRR       = trainKRR(Xtrain,Ytrain);
    Yp              = testKRR(model_KRR,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsKRR      = assessment(Ypred(:,m),Ytest,'regress');
    tempsKRR        = cputime-t;
end
%% (10) RELEVANCE VECTOR MACHINE
if sum(strcmpi(METHODS,'RVM'))
    m=m+1;
    t=cputime;
    fprintf('Training RVM ... \n')
    model_RVM       = trainRVM(Xtrain,Ytrain);
    Yp              = testRVM(model_RVM,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsRVM      = assessment(Ypred(:,m),Ytest,'regress');
    tempsRVM        = cputime-t;
end
%% (11) GPR
if sum(strcmpi(METHODS,'GPR'))
    m=m+1;
    t=cputime;
    fprintf('Training GPR ... \n')
    model_GP        = trainGPR(Xtrain,Ytrain);
    [Yp S2]         = testGPR(model_GP,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsGP       = assessment(Ypred(:,m),Ytest,'regress');
    tempsGP         = cputime-t;
end
%% (12) VHGPR
if sum(strcmpi(METHODS,'VHGPR'))
    m=m+1;
    t=cputime;
    fprintf('Training VHGPR ... \n')
    model_VHGP      = trainVHGPR(Xtrain,Ytrain);
    [Yp S2]         = testVHGPR(model_VHGP,Xtest);
    Ypred(:,m)      = Yp + my;
    resultsVHGP     = assessment(Ypred(:,m),Ytest,'regress');
    tempsVHGP       = cputime-t;
end
%% NUMERICAL RESULTS
clc
fprintf('-------------------------------------------------- \n')
fprintf('METHOD   & ME    & RMSE  & MAE   & R \\\\ \n')
fprintf('-------------------------------------------------- \n')
fprintf('LASSO     & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsLASSO.ME),resultsLASSO.RMSE,resultsLASSO.MAE,resultsLASSO.R)
fprintf('ELASTIC   & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsENET.ME),resultsENET.RMSE,resultsENET.MAE,resultsENET.R)
fprintf('-------------------------------------------------- \n')
fprintf('TREE               & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsTREE.ME),resultsTREE.RMSE,resultsTREE.MAE,resultsTREE.R)
fprintf('BAGTREE            & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsBAGTREE.ME),resultsBAGTREE.RMSE,resultsBAGTREE.MAE,...
    resultsBAGTREE.R)
fprintf('BOOST              & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsBOOST.ME),resultsBOOST.RMSE,resultsBOOST.MAE,resultsBOOST.R)
fprintf('-------------------------------------------------- \n')
fprintf('NN                 & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsNN.ME),resultsNN.RMSE,resultsNN.MAE,resultsNN.R)
fprintf('ELM                & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsELM.ME),resultsELM.RMSE,resultsELM.MAE,resultsELM.R)
fprintf('-------------------------------------------------- \n')
fprintf('SVR                & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsSVR.ME),resultsSVR.RMSE,resultsSVR.MAE,resultsSVR.R)
fprintf('KRR                & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsKRR.ME),resultsKRR.RMSE,resultsKRR.MAE,resultsKRR.R)
fprintf('-------------------------------------------------- \n')
fprintf('RVM                & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsRVM.ME),resultsRVM.RMSE,resultsRVM.MAE,resultsRVM.R)
fprintf('GP                 & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsGP.ME),resultsGP.RMSE,resultsGP.MAE,resultsGP.R)
fprintf('VHGPR              & %3.2f & %3.2f & %3.2f & %3.2f \\\\ \n',...
    abs(resultsVHGP.ME),resultsVHGP.RMSE,resultsVHGP.MAE,resultsVHGP.R)
fprintf('-------------------------------------------------- \n')
%% THE ERROR BOXPLOTS
figure,
ERRORS = Ypred - repmat(Ytest,1,size(Ypred,2));
boxplot(ERRORS,'labels',METHODS)
h = findobj(gca, 'type', 'text');
set(h, 'Interpreter', 'tex');
ylabel('Residuals')
%% STATISTICAL ANALYSIS OF THE BIAS
anova1(ERRORS)
%% STATISTICAL ANALYSIS OF THE ACCURACY OF THE RESIDUALS
anova1(abs(ERRORS))