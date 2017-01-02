% Choose method
mklmethod = 'align'; % or alignf
% Given X and y
[n d] = size(X);
% Optimal kernel
Y = y * 2 - 1; Ky = Y * Y'; Kyc = centering(Ky);
% The best combination of kernels with different sigmas
ker = 'rbf';
Kc = zeros(size(K,1),size(K,2),d); a = zeros(1,d);
for dim = 1:d
    sigma = median(pdist(X(:,dim)));
    K = kernelmatrix(ker,X(:,dim)',X(:,dim)',sigma);
    Kc(:,:,dim) = centering(K);
    a(dim) = alignment(Kc(:,:,dim),Ky);
end
% Compute the M kernel matrix
M = zeros(d);
for i = 1:d
    for j = 1:d
        M(i,j) = sum(sum(Kc(:,:,i) .* Kc(:,:,j)));
    end
end
% Solve the problems
if strcmpi(mklmethod,'align') % Linear combination ("align", Prop. 8)
    v = M \ a';
elseif strcmpi(mklmethod, 'alignf') % Convex combination ("alignf", Prop. 9)
    options = optimset('Algorithm', 'interior-point-convex');
    v = quadprog(M,-a',-1*ones(1,length(a)),0,[],[],[],[],[],options);
end
mu = v/norm(v);
% The combined kernels
Kbest = zeros(n);
for dim = 1:d
    Kbest = Kbest + mu(dim) * squeeze(Kc(:,:,dim));
end