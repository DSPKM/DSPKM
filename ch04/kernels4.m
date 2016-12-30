np   = 200;
dist = 2.5;
m1   = [-dist ; dist];
m2   = [0 ; 0];
m3   = [2*dist ; 2*dist];
% Generate samples
X1 = randn(2,np) + repmat(m1,1,np);
X2 = randn(2,np) + repmat(m2,1,np);
X3 = randn(2,np) + repmat(m3,1,np);
% All samples matrix
X = [X1 X2 X3]';
% Normalization
Xn = zscore(X);
% Look at the generated examples
figure(1)
plot(Xn(1:np,1), Xn(1:np,2), 'xb', ...
      Xn((1:np)+1*np,1), Xn((1:np)+1*np,2), 'xr', ...
      Xn((1:np)+2*np,1), Xn((1:np)+2*np,2), 'xk')
% Linear kernel
K = Xn * Xn';
% Inspecting the kernel
figure(2), imagesc(K), axis square off
