% For the train kernel we have
nt = size(Xt,2);
ntsq = sum(Xt.^2,1);
Dt = 2 * (ntsq * ones(nt,1) - Xt' * Xt);
Kt = exp(-Dt / (2*sigma^2)); % sigma is the width of the RBF
% The test kernel can be computed as
nv = size(Xv,2);
nvsq = sum(Xv.^2,1);
Dv = ntsq' * ones(1,nv) + ones(nt,1) * nvsq - 2 * Xt' * Xv;
Kv = exp(-Dv / (2*sigma^2));
