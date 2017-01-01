function model = trainSVR(X,Y)

vf    = 3;
eps   = [0.001 0.01 0.1:0.1:0.5];
C     = logspace(0,3,10);

% First guess for the sigma parameter
meanSigma = mean(pdist(X));
sigmaMin = log10(meanSigma*0.1);
sigmaMax = log10(meanSigma*10);
sigma = logspace(sigmaMin,sigmaMax,20);

bestEps = 1;
bestC = 1;
bestSigma = 1;
bestMse = Inf;

for ss = 1:numel(sigma)
    K = kernelmatrix('rbf', X', X', sigma(ss));
    for cc = 1:numel(C)
        for ee = 1:numel(eps)
            params = sprintf('-s 3 -t 4 -c %f -p %f -v %d', C(cc), eps(ee), vf);
            mse = mexsvmtrain(Y,K,params);
            if mse < bestMse
                bestMse = mse;
                bestEps = ee;
                bestC   = cc;
                bestSigma = ss;
            end
        end
    end
end

K = kernelmatrix('rbf', X', X', sigma(bestSigma));
params = sprintf('-s 3 -t 4 -c %f -p %f', C(bestC), eps(bestEps));
model = mexsvmtrain(Y,K,params);
model.sigma = sigma(bestSigma);
model.C = C(bestC);
model.Xtrain = X;