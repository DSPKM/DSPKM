n = 100 % number of training points per class
[X,Y] = generate_toydata(n,'swissroll');

% Compute the RBF kernel matrix
sigma = median(pdist(X));  % heuristic
K = kernelmatrix('rbf',X',X',sigma);

% Compute distances between data points in Hilbert space from the kernel
for i=1:2*n
    for j=1:2*n
        Dist2_X(i,j) = norm(X(i,:)-X(j,:),'fro');
        Dist2_H(i,j) = K(i,i)+K(j,j)-2*K(i,j);
    end
end
figure, plot(Dist2_X,Dist2_H,'k.','markersize',10), grid on, axis tight
xlabel('Distances in input space'), ylabel('Distances in Hilbert space')
