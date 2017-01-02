function K = centering(K)

[Ni,Nj] = size(K);
K = K - mean(K,2)*ones(1,Nj) - ones(Ni,1)*mean(K,1) + mean(K(:));