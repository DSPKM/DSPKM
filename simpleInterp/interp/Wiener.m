function [predict,coefs] = Wiener(Xtrain,Ytrain,Xtest,path_acorr)

% Initials
if nargin == 4 && ischar(path_acorr)
    load(path_acorr) % Precomputed autocorrelation of all available data
else
    % Computing autocorrelation with training data
    if nargin < 4; paso = 1; else paso = path_acorr; end
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
% Train and predict
coefs = H \ Htest';
predict = coefs'*Ytrain;
coefs = mean(coefs,2);