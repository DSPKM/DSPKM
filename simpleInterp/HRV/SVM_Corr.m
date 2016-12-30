function [predict,coefs] = SVM_Corr(Xtrain,Ytrain,Xtest,gamma,epsilon,C,path_acorr)

% Initials
load(path_acorr)
resolution = mean(diff(t_rxx));

% Contruct kernel matrix
% Train
[x,y] = meshgrid(Xtrain,Xtrain);
tau = abs(x-y);
idx = round(tau / resolution) + 1;
H = rxx(idx); %H.H_ent = interp1(t_rxx,rxx,tau,'linear');
% Test
[x,y] = meshgrid(Xtrain,Xtest);
tau = abs(x-y);
idx = round(tau / resolution) + 1;
Htest = rxx(idx); %interp1(t_rxx,rxx,tau,'linear');

% Train SVM and predict
inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
[predict,model]=SVM(H,Ytrain,Htest,inparams);
coefs = getSvmWeights(model);
