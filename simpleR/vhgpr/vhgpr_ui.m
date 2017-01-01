function [NMSE, NLPD, Ey, Vy, mutst, diagSigmatst, atst, diagCtst, ... 
    LambdaTheta, loghyperGP, convergence] = vhgpr_ui(x_tr, y_tr, x_tst, y_tst, iter, loghyperGP, loghyper)
% VHGPR_UI implements a convenient user interface for VHGPR
%
% Input:    - x_tr: Training input data. One vector per row.
%           - y_tr: Training output value. One scalar per row.
%           - x_tst: Test input data. One vector per row.
%           - y_tst: Tetst output value. One scalar per row. Used to
%           compute error measures, predictions below do not use it.
%           - iter: Number of iterations for the optimizer. (Optional).
%           - loghyperGP: Use this full GP hyperparameters to initialize
%           VHGPR's hyperparameters. (Optional).
%           - loghyper: Use these initial VHGPR's hyperparameters.
%           (Optional).
%
% Output:   - NMSE: Normalized Mean Square Error on test set.
%           - NLPD: Negative Log-Probability Density on test set.
%           - Ey: Expectation of the approximate posterior for test data.
%           - Vy: Variance of the approximate posterior for test data.
%           - mutst: Expectation of the approximate posterior for g.
%           - diagSigmatst: Variance of the approximate posterior for g.
%           - atst: Expectation of the approximate posterior for f.
%           - diagCtst: Variance of the approximate posterior for f.
%           - LambdaTheta: Obtained values for [Lambda hyperf hyperg mu0]
%           - convergence: Evolution of the MV bound during optimization.
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
% - NOTE: This is just a helper function providing a default initialization,
% other initializations, or other optimization techniques, may be better
% suited to achieve a better bound on other problems.
%
% Copyright (c) 2011 by Miguel Lazaro Gredila


[n, D] = size(x_tr);
meanp=mean(y_tr);

% Covariance functions
covfuncSignal = {'covSum',{'covSEisoj','covConst'}};
covfuncNoise  = {'covSum',{'covSEisoj','covNoise'}};

if nargin < 5
    iter = 40;
end
if nargin < 6
    % Hyperparameter initialization
    SignalPower = var(y_tr,1);
    NoisePower = SignalPower/4;
    lengthscales=log((max(x_tr)-min(x_tr))'/2);
    
    display('  - Running standard, homoscedastic GP...')
    loghyperGP = [lengthscales; 0.5*log(SignalPower); 0.5*log(NoisePower);-0.5*log(max(SignalPower/20,meanp^2))];
    loghyperGP = minimize(loghyperGP, 'gpr', 40, {'covSum', {'covSEardj','covNoise','covConst'}}, x_tr, y_tr);
end
lengthscales=loghyperGP(1:D);
x_tr = x_tr./(ones(n,1)*exp(lengthscales(:)'));
x_tst = x_tst./(ones( size(x_tst,1) ,1)*exp(lengthscales(:)'));

if nargin < 7 % Learn hyperparameters
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
else % Use given, fixed hyperparameters
    display('  - Running VHGPR...')
    LambdaTheta = [log(0.5)*ones(n,1);loghyper];
    [LambdaTheta, convergence] = minimize(LambdaTheta, 'vhgpr', iter, covfuncSignal, covfuncNoise, 2, x_tr, y_tr);
end


if nargout > 1
    [Ey, Vy, mutst, diagSigmatst, atst, diagCtst]= vhgpr(LambdaTheta, covfuncSignal, covfuncNoise, 0, x_tr, y_tr, x_tst);
else
    [Ey, Vy, mutst, diagSigmatst]= vhgpr(LambdaTheta, covfuncSignal, covfuncNoise, 0, x_tr, y_tr, x_tst);
end

NMSE=mean((Ey-y_tst).^2)/mean((meanp-y_tst).^2);

if nargout > 1
    [NLPDapprox, NLPD] = nlogprob_vhgpr(y_tst, mutst, diagSigmatst, atst, diagCtst);
    NLPD = mean(NLPD);
end