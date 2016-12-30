% Assuming we have Xt (training) and Xv (test)
Kt = Xt * Xt'; % Linear kernel for training
Kv = Xv * Xt'; % Linear kernel for validation/test
% Polynomial kernel
Kt = (Xt * Xt' + c).^d; % c: bias, d: polynomial degree
Kv = (Xv * Xt' + c).^d;
