% Drawing from a GP prior
kernelType = 'SE';  % squared exponential kernel
switch  kernelType
    case 'SE' % SE kernel
        sig = 0.2; k = @(x1,x2) exp(-(x1-x2).^2/sig^2);
    case 'RQ' % Rational-quadratic kernel
        c = 0.05; k = @(x1,x2) (1 - (x1-x2).^2 ./ ((x1-x2).^2 + c));
    case 'Per' % Periodic kernel
        p = 0.5; % period
        sig = 0.7; % SE kernel length
        k = @(x1,x2) exp(-sin(pi*(x1-x2)/p).^2/sig^2);
    case 'Lin' % Linear kernel
        offset = 0; k = @(x1,x2)  (x1 - offset) .* (x2 - offset);
    case 'Lin+Per' %% Linear+PER kernel
        offset = -1; p = 0.5; % period
        sig = 0.7; % SE kernel length
        k = @(x1,x2) (x1 - offset).*(x2 - offset) + exp(-sin(pi*(x1-x2)/p).^2/sig^2);
    case 'Lin+SE' % Linear+SE kernel
        offset = 0; sig=0.1;
        k = @(x1,x2)  (x1 - offset).*(x2 - offset) + exp(-(x1-x2).^2/sig^2);
end
% Generate plot of correspoding kernels
stepInp = 0.04; xforFig = 0; x = -1:0.02:1;
figure(1), clf, plot(x,k(x,xforFig),'k','LineWidth',8)
axis([-1 1 -1 max(k(x,xforFig))+0.5]), axis off
% Create kernel matrix
x = -1:stepInp:1; z = meshgrid(x); K = k(z,z');
% Proxy to phi transform using Cholesky decomp.
sphi = chol(K + 1e-6*eye(size(K)))';
Num_of_Funct = 5; % number of i.i.d. functions from GP Prior
% Genration of iid random functions - vectors
Functions_from_GP_Prior = sphi * randn(length(x), Num_of_Funct);
% Generate plot of the drawn functions
figure(2), clf, plot(x,Functions_from_GP_Prior,'LineWidth',8), axis off