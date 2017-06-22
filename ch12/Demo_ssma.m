% X = labeled data, U = unlabeled data
Z = blkdiag([X1,U1],[X2,U2]);	% (n1+n2) x (d1+d2)
[L,Ls,Ld] = Laplacians(X1,U1,Y1,X2,U2,Y2);
n = n1 + n2; d = d1 + d2;
% Combine graph Laplacians
mu = 0.1;
A  = L + mu * Ls;   % (n1+n2) x (n1+n2)
B  = Ld;            % (n1+n2) x (n1+n2)
% Solve the generalized eigenproblem
[V D] = eigs(Z'*A*Z, Z'*B*Z, d, 'SM');
nf = 4;	% features
E1 = V(1:d1,1:nf); E2 = V(d1+1:end,1:nf);
% Project data
PX12 = X1*E1;