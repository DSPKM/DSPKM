%% KECA implementation
sigma    = estimateSigma(X);
K        = kernelmatrix('rbf', X', X', sigma);
[E D]    = eig(K);
V2       = sum((E*(D.^0.5))).^2;
[V2 ind] = sort(V2,'descend');
Vkeca    = E(:,ind);