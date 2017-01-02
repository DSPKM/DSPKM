% Random Kitchen Sinks (RKS) for Least squares kernel regression
%
% We are given the following training-test data matrices
% Xtrain: N x d, Xtest: M x d
% Ytrain: N x 1, Ytest: M x 1

% Training
D      = 100;          % number of random features
lambda = 1e-3;         % regularization parameter
W      = randn(D,d);   % random projection matrix
Z      = exp(1i * Xtrain * W);   % explicitly projected features, N x D
alpha  = (Z'*Z + lambda*eye(D)) \ (Z'*Ytrain);  % primal weights, D x 1

% Testing
Ztest = exp(1i * Xtest * W);   % M x D
Ypred = real(Ztest * alpha);   % M x 1