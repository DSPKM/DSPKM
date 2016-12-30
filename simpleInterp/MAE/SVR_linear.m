function [predict,coefs] = SVR_linear(Xtrain,Ytrain,Xtest,nu,C)

% Train SVM and predict
inparams=sprintf('-s 4 -t 0 -c %f -n %f -j 0',C,nu);
[predict,model]=SVM(Xtrain,Ytrain,Xtest,inparams);
coefs = getSvmWeights(model);
