function [predict,coefs] = SVR(Xtrain,Ytrain,Xtest,sigma,nu,C)

% Train SVM and predict
gamma = 1/(2*sigma)^2;
inparams=sprintf('-s 4 -t 2 -g %f -c %f -n %f -j 1',gamma,C,nu);
[predict,model]=SVM(Xtrain,Ytrain,Xtest,inparams);
coefs = getSvmWeights(model);
