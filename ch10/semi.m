function  C = semi(X,Y,sigma,alpha)

N = size(X, 1);

% Step 1: Affinity matrix
M = zeros(N, N); % norm matrix
for i = 1:N % compute the pairwise norm
    for j = (i+1):N
        M(i, j) = norm(X(i, :) - X(j, :)); 
        M(j, i) = M(i, j);
    end
end
% Use a Gaussian to form an affinity matrix
K = exp(-M.^2/(2*sigma^2));  
K = K - eye(N); 

% Step 2: Symmetrical normalization
D = diag(1./sqrt(sum(K))); % inverse of the square root of the degree matrix
S = D*K*D; % normalize the affinity matrix

% Step 3(a): Compute the classification function
F = (eye(N) - alpha * S) \ Y;
% Step 3(b): Predictions
[~,C] = max(F, [], 2);