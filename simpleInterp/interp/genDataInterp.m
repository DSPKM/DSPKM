function data = genDataInterp(conf)
L = conf.data.L; LT = L*conf.data.T;
% Uniform sampling generation to training and reconstruction
Xtrain = linspace(1, LT, L); Xtrain = Xtrain(:);
Xtest = linspace(1, LT, L*16); Xtest = Xtest(:);
% Nonuniform sampling generation
Xtrain(2:L-1) = Xtrain(2:L-1)+ 2*conf.u .* (rand(L-2,1)-0.5);
% Avoiding samples out of the signal limits
Xtrain(Xtrain>LT) = 2*LT-Xtrain(Xtrain>LT);
Xtrain(Xtrain<1)  = 2-Xtrain(Xtrain<1);
% Signal generation
[Ytrain, Ytest] = interpSignal(conf,Xtrain,Xtest);
potY = mean(Ytest.^2);
N = sqrt(potY./(10.^(conf.SNR./10)));
Ytrain = Ytrain + N*randn(size(Ytrain));
% Return the data structure
data.Xtrain=Xtrain; data.Xtest=Xtest; data.Ytrain=Ytrain; data.Ytest =Ytest;