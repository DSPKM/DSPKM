% Load the vertex and faces matrices
load vertex;
load faces;

n = length(vertex);
L = geometric_Laplacian(vertex,faces);
K = graph_Laplacian(n,faces);

% Eigendecompositon of L and K:
[H_K,A_K] = eig(K);
[H_L,A_L] = eig(L);

% Spectral coefficients
a_K = H_K'*vertex;
a_L = H_L'*vertex;

% Mesh reconstruction error and mean absolute error
for i=1:n
    x_hat_K = H_K(:,1:i)*a_K(1:i,:);
    MAE_K(i) = mean(abs(vertex(:)-x_hat_K(:)));
    x_hat_L = H_L(:,1:i)*a_L(1:i,:);
    MAE_L(i) = mean(abs(vertex(:)-x_hat_L(:)));
end

% Plot the error figure
figure; set(gcf,'color','w');   set(gca,'FontSize',20);
plot(MAE_K,'LineWidth',2);
hold on; plot(MAE_L,'r','LineWidth',2); axis tight;
xlabel('Components');   ylabel('Mean absolute error')
legend('Graph Laplacian','Geometric Laplacian')