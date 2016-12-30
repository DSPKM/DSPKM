% Assuming a pre-computed kernel matrix in Kt, centering is done as:
[Ni,Nj] = size(Kt);
Kt = Kt - ( mean(Kt,2)*ones(1,Nj) - ones(Ni,1)*mean(Kt,1) + mean(Kt(:)) );
% Sum columns and divide by the number of rows
S = sum(Kt) / Ni;
% Centered test kernel w.r.t. a train kernel
Kv = Kv - ( S' * ones(1,Nj) - ones(Ni,1) / Ni * sum(Kv) + sum(S) / Ni );
