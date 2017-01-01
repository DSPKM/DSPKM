function model = trainRVM(X,Y)

[n d] = size(X);
rate = 0.66;      % Use 2/3 - 1/3 for xvalidation
ntrain = round(rate*n);
r = randperm(n);
Xtrain = X(r(1:ntrain),:);
Ytrain = Y(r(1:ntrain),:);
Xtest = X(r(ntrain+1:end),:);
Ytest = Y(r(ntrain+1:end),:);

outdim = size(Ytrain,2);

meanSigma = mean(pdist(X));
sigmaMin = log10(meanSigma*0.1);
sigmaMax = log10(meanSigma*10);
sigma = logspace(sigmaMin,sigmaMax,20);
maxIts = 100;

rmse = Inf;
for ls = 1:numel(sigma)
    Kt = kernelmatrix('rbf', Xtrain', Xtrain', sigma(ls));
    Kv = kernelmatrix('rbf', Xtest', Xtrain', sigma(ls));
    [weights, used, alpha, beta] = mvrvm(Kt,Ytrain,maxIts);
    % Validate
    yp = Kv(:,used) * weights;
    % Error
    if outdim > 1
        res = norm(Ytest-yp,'fro');
    else
        res = mean( sqrt(mean((Ytest-yp).^2)) );
    end
    if res < rmse
        model.sigma = sigma(ls);
        rmse = res;
    end
end

% Final model
model.x = X;
K = kernelmatrix('rbf', model.x', model.x', model.sigma);
[weights, used, alpha, beta] = mvrvm(K,Y,maxIts);
model.alpha = weights;
model.used = used;
model.beta = beta;

