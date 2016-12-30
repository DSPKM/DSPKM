temp = F_norm(K,Y);
A = temp/sqrt(F_norm(K,K)*F_norm(Y,Y));

function F = F_norm(A,B)
F = trace(A'*B);
