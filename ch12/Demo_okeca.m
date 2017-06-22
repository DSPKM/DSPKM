%% OKECA implementation
% (Step 1) KECA-like part
% X   : input data
% Q   : extra rotation matrix
% gdit: #iterations in gradient descent
% dim : number of dimensions
Q = zeros(dim);
sigma = estimateSigma(X); K = kernelmatrix('rbf', X', X', sigma);
[E D] = eigs(K); [V2 ind] = sort(diag(D)); E = E(:,ind);
dD = diag(D); D = diag(dD(ind)); A = E*(D.^0.5);
% (Step 2) Optimization of the projections via gradient descent
tau = 1; % learning rate of the gradient descent procedure
for di = 1:size(K,1)
    m = rand(dim,1);
    m = m/sqrt(sum(m.^2));
    if di < dim
        for it = 1:gdit
            dJ = 2 * sum(A*m) * sum(A,1)';
            mn = m + tau * dJ;
            mn = mn - sum((repmat((Q'*mn)', dim, 1) .* Q), 2);
            mn = mn/sqrt(sum(mn.^2));
        end
    end
    Q(:,di) = mn; 
end
F = A * Q;