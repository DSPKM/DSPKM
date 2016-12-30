n = size(K,1);
D = sum(K) / ell;
E = sum(D) / ell;
D2 = diag(K) - 2 * D' + E * ones(n,1);
