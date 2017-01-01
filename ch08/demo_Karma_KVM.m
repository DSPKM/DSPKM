%% DEMO FOR TRAINING KARMA METHODS COMPARING KRR, SVR and RVM                               %%%%
clear, clc 
%% Setup paths
addpath('../simpleR/'), addpath('../libsvm/')
addpath('./rvm_code/'), addpath('./karma_rvm/')
%% Setup
setEnvironment('InfoLevel',0);
method  = 'stack+4k';
problem = 'mg17';
% Free Parameters (cost function and data)
D = 0;    % no delay of the signal
p = 2;    % number of taps
e = 1e-5; % epsilon insensitivity zone
C = 1e2;  % Penalization parameter
gam	= 1e-4; % Regularization factor of the kernel matrix (gam*C is the amount of Gaussian noise region in the loss)
% Free Parameters (kernel)
ker = 'rbf';
kparams.x  = 2;	 % Gaussian kernel width for the input signal kernel
kparams.y  = 2;  % Gaussian kernel width for the output signal kernel
kparams.z  = 2;  % Gaussian kernel width for the stacked signal kernel
kparams.xy = 2;  % Gaussian kernel width for the cross-information signal kernel
%% Load data
load data/mg17.dat
N = 400;
M = 1000;
X = mg17(1:N-1);
Y = mg17(2:N);
X2 = mg17(N+1:N+M-1);
Y2 = mg17(N+2:N+M);
% Generate input/output data matrices with a given signal delay D and tap
% order p. The data matrices are not scaled/standardized.
[Hx,Hy,Hx2,Hy2] = BuildData(X,Y,X2,Y2,D,p);
% Build kernel matrices from these data matrices:
[K,K2] = BuildKernels(Hx,Hy,Hx2,Hy2,ker,kparams,method);
% Train a regression algorithm (KRR, e-SVR, RVM) with the previous kernel matrices
[Y2hat_krr,results_krr,model_krr] = TrainKernel(K,K2,Y,Y2,D,p,gam,e,C,'krr');
[Y2hat_svr,results_svr,model_svr] = TrainKernel(K,K2,Y,Y2,D,p,gam,e,C,'svr');
[Y2hat_rvm,results_rvm,model_rvm] = TrainKernel(K,K2,Y,Y2,D,p,gam,e,C,'rvm');
%% RESULTS
results_krr
results_svr
results_rvm