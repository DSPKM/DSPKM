K  = kernelmatrix('rbf',X,X,sigma);  % compute kernel matrix n x n
K2 = kernelmatrix('rbf',X2,X,sigma); % compute kernel matrix n x m
n = size(K,2);      % n: number of samples used in the kernel matrix
D = 10;             % subspace dimensionality (D<n)
[A L] = eigs(K,n);  % extract the top D eigenvectors of the kernel matrix
P_X2 = K2*A;        % projection of X2 onto the subspace of size m x n
P_X2 = K2*A(:,1:D); % projection of X2 onto the subspace of size m x D
