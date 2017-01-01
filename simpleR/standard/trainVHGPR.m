function model = trainVHGPR(x_tr, y_tr)

% trainVHGPR implements a convenient user interface for VHGPR
%
% Input:    - x_tr: Training input data. One vector per row.
%           - y_tr: Training output value. One scalar per row.
%
% Output:   - VHGPR model ready to perform test predictions. The Matlab structure contains:
%             the optimized hyperparameters, the covariance functions and the training data
%
% Note that the input dimensions are scaled according to the lengthscales
% in loghyperGP (either supplied or determined by this function) in
% addition to the single lengthscale in hyperf and hyperg.
%
% The algorithm in this file is based on the following paper:
% M. Lazaro Gredilla and M. Titsias,
% "Variational Heteroscedastic Gaussian Process Regression"
% Published in ICML 2011
%
% See also: vhgpr
%
% Copyright (c) 2011 by Miguel Lazaro Gredilla

[n, D] = size(x_tr);
meanp  = mean(y_tr);

% Covariance functions
covfuncSignal = {'covSum',{'covSEisoj','covConst'}};
covfuncNoise  = {'covSum',{'covSEisoj','covNoise'}};
iter = 40;

% Hyperparameter initialization
SignalPower = var(y_tr,1);
NoisePower = SignalPower/4;
lengthscales=log((max(x_tr)-min(x_tr))'/2);

display('  - Running standard, homoscedastic GP...')
loghyperGP = [lengthscales; 0.5*log(SignalPower); 0.5*log(NoisePower);-0.5*log(max(SignalPower/20,meanp^2))];
loghyperGP = minimize(loghyperGP, 'gpr', 40, {'covSum', {'covSEardj','covNoise','covConst'}}, x_tr, y_tr);

lengthscales=loghyperGP(1:D);
x_tr = x_tr./(ones(n,1)*exp(lengthscales(:)'));

% Learn hyperparameters
SignalPower = exp(2*loghyperGP(D+1));
NoisePower =  exp(2*loghyperGP(D+2));
ConstPower =  exp(-2*loghyperGP(D+3));

sn2 = 1;
mu0 = log(NoisePower)-sn2/2-2;
loghyperSignal = [0; 0.5*log(SignalPower);-0.5*log(ConstPower)];
loghyperNoise =  [0; 0.5*log(sn2); 0.5*log(sn2*0.25)];

display('  - Initializing VHGPR (keeping hyperparameters fixed)...')
LambdaTheta = [log(0.5)*ones(n,1);loghyperSignal;loghyperNoise;mu0];
[LambdaTheta, convergence0] = minimize(LambdaTheta, 'vhgpr', 30, covfuncSignal, covfuncNoise, 2, x_tr, y_tr);
display('  - Running VHGPR...')
[LambdaTheta, convergence] = minimize(LambdaTheta, 'vhgpr', iter, covfuncSignal, covfuncNoise, 0, x_tr, y_tr);
convergence = [convergence0; convergence];

model.LambdaTheta = LambdaTheta;
model.loghyper    = loghyperGP;
model.Xtrain      = x_tr;
model.Ytrain      = y_tr;
model.covfuncSignal = covfuncSignal;
model.covfuncNoise  = covfuncNoise;
model.meanp         = meanp;

