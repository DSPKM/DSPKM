function K = K_matrix(r)

[controlP,newP] = size(r);
new_r = r(:);
K = zeros(size(r));
repVert = find(new_r>0);

K(repVert) = single(log(r(repVert).^2).*r(repVert).^2);
K = reshape(K,controlP,newP);