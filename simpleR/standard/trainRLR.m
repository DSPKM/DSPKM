function model = trainRLR(X,Y)

[n d] = size(X);
rate = 0.66;      % Use 2/3 - 1/3 for xvalidation
ntrain = round(rate*n);
r = randperm(n);
X = [ones(n,1) X];
d = d+1;
Xtrain = X(r(1:ntrain),:);
Ytrain = Y(r(1:ntrain),:);
Xtest  = X(r(ntrain+1:end),:);
Ytest  = Y(r(ntrain+1:end),:);

gamma = logspace(-20,0,50);

Ctrain = Xtrain'*Xtrain;

res = Inf;
for lg = 1:numel(gamma)
    W = inv(Ctrain + gamma(lg)*eye(d))*Xtrain'*Ytrain;
    Ypred = Xtest*W;
    res(lg) = norm(Ytest-Ypred,'fro'); 
end
% figure,semilogx(gamma,res,'ko-'), grid

[val idx] = min(res);
bestgamma = gamma(idx);
W = inv(X'*X + bestgamma*eye(d))*X'*Y;   
model.W = W;
model.gamma = bestgamma;
