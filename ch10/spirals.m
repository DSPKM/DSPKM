function spirals
% Setup paths
addpath('../libsvm/'), addpath('../simpleR/')
% Generate and plot a set of data in two spirals
rng(1); sigma = 0.01;
[X1,X2,y] = fibonacci(300);
x = [X1 X2]; % Data stored in a matrix. Labels are stored in y
K = kernelmatrix('rbf', x, x, sigma); % Training kernel matrix

nfig = 1;
for C = [1000 100 10 1]
    options = ['-s 0 -t 4 -c ' num2str(C)];
	 % Compute the dual parameters and store them in a column vector called alpha.
    model = mexsvmtrain(y,K,options); 
    M = max(abs(x(:))) * 0.9;
    [X1_,X2_] = meshgrid(-M:M/100:M, -M:M/100:M); % Grid of points for
    xt = [X1_(:) X2_(:)]';  % Vectorize it to use it in test
    Ktest = kernelmatrix('rbf', xt, x, sigma);  % Test matrix
    % Classify the test data
    [~,~,z] = mexsvmpredict(zeros(size(xt,2),1), Ktest, model);
	% Convert the output vector into a matrix for representation
    Z = buffer(z, size(X1_,1), 0);
    % Plotting results
    figure(nfig), nfig = nfig + 1; clf
    plot(X1(1,:), X1(2,:), 'bo', X2(1,:), X2(2,:), 'ro'); hold on
    contour(X1_, X2_, Z, [0 0], 'LineWidth', 2, 'Color', 'Black'); hold off
    axis square; title(['C = ' num2str(C)])
end

function [X1,X2,y] = fibonacci(N)
theta = rand(1,N) * (log10(3.5*pi));
theta = 10.^theta + pi; theta = 4*pi - theta;
a = 0.01; b = 0.2; r = a * exp(b*theta);
x1 = r .* cos(theta); y1 = r .* sin(theta);
d = 0.14 * sqrt(x1.^2 + y1.^2);
x1 = x1 + randn(size(x1)) .* d; y1 = y1 + randn(size(y1)) .* d;
X1 = [x1;y1]; x2 = r .* cos(theta+pi); y2 = r .* sin(theta+pi);
d = 0.14 * sqrt(x2.^2 + y2.^2); x2 = x2 + randn(size(x2)) .* d;
y2 = y2 + randn(size(y2)) .* d; X2 = [x2;y2];
y = [ones(1,300) -ones(1,300)]';