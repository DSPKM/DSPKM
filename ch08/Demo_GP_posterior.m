%% Sampling GP Posterior and Computation of Marginal Likelihood
clear, clc
% Generating data
sig_e = 0; %  std of the noise
X = [-10 -3 2 8 12]; N = length(X); Y = sin(X) + sig_e * randn(1,N);
% kernel function
delta = 3; k = @(z1,z2) exp(-(z1-z2).^2/(2*delta^2));
% kernel matrix
z = meshgrid(X); K = k(z,z');
Lambda = (K + sig_e^2 * eye(N));
% inputs for test
x_pr = -20:0.2:20;
% posterior mean and variance
Kxx = zeros(length(x_pr),N);
f_mean = zeros(1,length(x_pr)); sig_post = f_mean;
for i = 1:length(x_pr)
    kx = k(x_pr(i),X);
    Kxx(i,:) = kx';
    f_mean(i) = kx / Lambda * Y'; %  posterior mean
    sig_post(i) = k(x_pr(i),x_pr(i)) - kx / Lambda * kx'; %  posterior var.
end
% Sampling GP Posterior
z = meshgrid(x_pr); K_pr = k(z,z');
Sigma_pr = K_pr - Kxx / Lambda * Kxx';
f_samples_from_post = mvnrnd(f_mean, Sigma_pr, 2);
% Plot
figure(1), clf
V1 = f_mean - sqrt(sig_post); V2 = f_mean + sqrt(sig_post);
fill([x_pr, fliplr(x_pr)], [V1, fliplr(V2)], ...
    'k','FaceAlpha', 0.3, 'EdgeAlpha', 0.7);
hold on; plot(x_pr, f_samples_from_post, '--', 'LineWidth', 3)
    plot(x_pr, f_mean, 'k', 'LineWidth', 5)
    plot(X, Y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 15);
axis([-20 20 -3.5 3.5]), set(gca, 'Fontsize', 20), box on
% Computation of the Marginal Likelihood
LogMargLike = -1/2 * (Y / Lambda * Y' + log(det(Lambda)) + N * log(2*pi));