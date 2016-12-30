% Load the vertex and faces matrices
load vertex;    load faces;
n = length(vertex);

% The Laplacian is computed
L = graph_Laplacian(n,faces);

% Eigendecompositon of K:
[H,A] = eig(L);

% Plot the eigenvectors on the mesh surface
figure;
selec_basis = [1:5 20 50 100 200 400];
for i=1:length(selec_basis)
    subplot(2,5,i);
    h = patch('vertices',vertex,'faces',faces,...
    	'FaceVertexCData', H(:,selec_basis(i)), ...
	'FaceColor','interp');
    title(['H_{' num2str(selec_basis(i)) '}'],'FontSize', 20)
    caxis([-0.05 0.05]);
    axis([20   60   -30    60])
    lighting phong;    camlight('right');   camproj('perspective');
    shading interp;    axis off;            colormap('jet')
end

% Spectral coefficients
a = H'*vertex;
figure;
plot(a,'Linewidth',2);  axis tight; title('Spectral coefficients');
legend('a_x coefficients','a_y coefficients','a_z coefficients');

% Mesh reconstruction
figure; colormap gray(256);
selec_basis = [1:5 50 200 482];
for i=1:length(selec_basis)
    subplot(2,4,i);
    x_hat = H(:,1:selec_basis(i))*a(1:selec_basis(i),:);
    if selec_basis(i)>2
        patch('vertices',x_hat,'faces',faces, ...
        'FaceVertexCData',[0.5 0.5 0.5],'FaceColor','flat');
        title(['H_1 - H_{' num2str(selec_basis(i)) '}'])
        axis([20   60   -30    60]);    axis off;
        lighting phong;     camlight('right');  camproj('perspective');
    else
        plot3(x_hat(:,1),x_hat(:,2),x_hat(:,3),'k.-');
        title('H_1','FontSize', 20);    axis off;
    end
end