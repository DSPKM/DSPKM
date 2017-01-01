function model = trainKSNR(X,Y)

warning('off', 'MATLAB:nearlySingularMatrix')
warning('off', 'MATLAB:singularMatrix')

n = size(X,1);
rate = 0.66;      % Use 2/3 - 1/3 for xvalidation

perm = randperm(n);
ntrain = round(rate*n);
train = perm(1:ntrain);
valid = perm(ntrain+1:end);

% dataset for crossvalidation
Ytrain = Y(train,:);
Ytest  = Y(valid,:);

% Estimation of the noise
NHAT = X - [0 ; diff(X)];  % quick and dirty estimation of the noise
% NHAT = noiseEstimation(X);  % use your noise estimator here

% Regularization path
LAMBDAS = [0 logspace(-5,-2,20)];
ROSCAS = logspace(-3,0,100);

rmse = inf;
for rosca = ROSCAS
    % GENERATE KERNELS
    sx = rosca * median(pdist(X));
    Kx = kernelmatrix('rbf',X',X',sx);
    % Explicit
    Kxhne = Kx - kernelmatrix('rbf',X',NHAT',sx);
    Khnxe = Kx - kernelmatrix('rbf',NHAT',X',sx);
    
    for lambda = LAMBDAS
        % KSNRe
        if lambda == 0
            alpha2i = (Kx(train,train) * Kx(train,train)) \ ...
                      (Kx(train,train) * Ytrain);
        else
            alpha2i = (Kx(train,train) * Kx(train,train) + ...
                lambda * (Kxhne(train,train) * Khnxe(train,train)) .* ...
                eye(ntrain)) \ (Kx(train,train) * Ytrain);
        end
        % Validate
        yp  = Kx(valid,train) * alpha2i;
        res = mean( sqrt(mean((Ytest-yp).^2)) );
        if res < rmse
            model.rosca = rosca;
            model.lambda = lambda;
            rmse = res;
        end
    end
end

model.x = X;
model.NHAT = NHAT;
model.sigma = model.rosca * median(pdist(X));

% Explicit
Kx = kernelmatrix('rbf', X', X', model.sigma);
Kxhne = Kx - kernelmatrix('rbf', X', NHAT', model.sigma);
Khnxe = Kx - kernelmatrix('rbf', NHAT', X', model.sigma);

if lambda == 0
    model.alpha = Kx \ Y;
else
    model.alpha = (Kx*Kx + lambda * (Kxhne*Khnxe) .* eye(n)) \ (Kx*Y);
end