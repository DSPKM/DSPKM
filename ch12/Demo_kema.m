% X = labeled data, U = unlabeled data
K1 = kernelmatrix(X1,U1);   % n1 x n1
K2 = kernelmatrix(X2,U2);   % n2 x n
K  = blkdiag(K1,K2);        % (n1+n2) x (n1+n2)
[L,Ls,Ld] = Laplacians(X1,U1,Y1,X2,U2,Y2);
n  = n1+n2; d = d1+d2;
% Combine graph Laplacians
mu = 0.1;
A = L + mu*Ls;  % (n1+n2) x (n1+n2)
B = Ld;         % (n1+n2) x (n1+n2)
% Solve the generalized eigenproblem
[A D] = eigs(K'*A*K, K'*B*K, d, 'SM');
nf = 4;	% n_f features
A1 = A(1:n1,1:nf); A2 = A(n1+1:end,1:nf);	
% Project data
PX12 = K1 * A1;