function [predict,coefs] = SVM_aCorr(Xtrain,Ytrain,Xtest,gamma,epsilon,C,path_acorr)

% Initialization
if nargin == 7 && ischar(path_acorr)
    load(path_acorr) % Precomputed autocorrelation of all available data
else
    % Computing autocorrelation with training data
    if nargin < 7; paso = 1; else paso = path_acorr; end
    [acorr,acs] = aCorr(Xtrain,Ytrain,paso);
end
% Contruct kernel matrix
resolution = mean(diff(acs));
% Train
[x,y] = meshgrid(Xtrain,Xtrain);
tau = abs(x-y);
idx = round(tau / resolution) + 1;
H = acorr(idx);
% Test
[x,y] = meshgrid(Xtrain,Xtest);
tau = abs(x-y);
idx = round(tau / resolution) + 1;
Htest = acorr(idx);
% Train SVM and predict
inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
[predict,model] = SVM(H,Ytrain,Htest,inparams);
coefs = getSVs(Ytrain,model);