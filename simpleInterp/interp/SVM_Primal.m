function [predict,coefs] = SVM_Primal(Xtrain,Ytrain,Xtest,T0,gamma,epsilon,C)

% Initials
tk  = Xtrain;
N = length(tk);
Ntest = length(Xtest);
% Construct kernel matrix
S = sinc((repmat(tk,1,N) - repmat(tk',N,1))/T0);
Stest = sinc((repmat(Xtest,1,N) - repmat(tk',Ntest,1))/T0);
H = zeros(N,N);
Htest = zeros(Ntest,N);
for m = 1:N
    H(:,m) = sum(S.*repmat(sinc((tk(m)-tk)/T0)',N,1),2);
    Htest(:,m) = sum(Stest.*repmat(sinc((tk(m)-tk)/T0)',Ntest,1),2);
end
% Train SVM and predict
inparams = ['-s 3 -t 4 -g ',num2str(gamma),' -c ',num2str(C),' -p ',num2str(epsilon)];
[predict,model] = SVM(H,Ytrain,Htest,inparams);
coefs = getSvmWeights(model);