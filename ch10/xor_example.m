function xor_example
% Toy example of the solution of the XOR problem using kernels and SVMs
addpath('../libsvm/'), addpath('../simpleR/'), rng(1);
C = 0.1;      % Complexity parameter
sigma = 0.5;  % Kernel parameter
c = [ 1 -1 -1 1 ; 1 -1 1 -1 ];  % Centers of the 4 clusters
% Generation of 400 datapoints
x = [ repmat(c(:,1:2),1,100) repmat(c(:,3:4),1,100) ];
x = x + 0.4 * randn(size(x));
y = [ ones(1,200) -ones(1,200) ]';
K = kernelmatrix('rbf', x, x, sigma);    % Kernel matrix
options = ['-s 0 -t 4 -c ' num2str(C)];
model = mexsvmtrain(y,K,options);        % Train the SVM
% alpha = pinv(K + gamma * eye(size(K))) * y; % Compute dual parameters
% Note the use of a diag matrix
[X1,X2] = meshgrid(-3:.05:3,-3:.05:3);   % Grid for representing data
% representation of the data
xt = [X1(:) X2(:)]';                     % Vectorize it to use it in test
Ktest = kernelmatrix('rbf', xt, x, sigma);
[~,~,z] = mexsvmpredict(zeros(size(xt,2),1), Ktest, model); % Predictions
Z = buffer(z, size(X1,1), 0);  % convert output vector into matrix
% Plot data
figure(1), clf
plot(x(1,y>0), x(2,y>0), 'bo', x(1,y<0),x(2,y<0), 'ro'); hold on
contour(X1, X2, Z, [0 0], 'LineWidth', 2, 'Color', 'Black'), hold off
figure(2), surfc(X1,X2,Z), shading interp, camlight right, view([-38 30])
xlabel('$x_1$','Interpreter','latex'); ylabel('$x_2$','Interpreter','latex')