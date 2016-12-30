function [predict,coefs] = SVM_RBF(Xtrain,Ytrain,Xtest,T0,gamma,epsilon,C)

% Initials
tk = Xtrain;
N = length(tk);
Ntest = length(Xtest);
% Construct kernel matrix
H = exp(-(repmat(tk,1,N)-repmat(tk',N,1)).^2/(2*T0^2));
Htest = exp(-(repmat(Xtest,1,N)-repmat(tk',Ntest,1)).^2/(2*T0^2));
% Train SVM and predict
inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
[predict,model] = SVM(H,Ytrain,Htest,inparams);
coefs = getSVs(Ytrain,model);