% Generate data
sig_e = 0.5; % std of the noise
X = [-12 -10 -3 -2  2 8 12 14]';
N = length(X);
Y = sin(X) + sig_e * randn(N,1); % N x 1
% Basis functions
M = 4; % number of basis functions
phi = @(x) [1 x.^(1:M-1)];
% Basis function matrix
PHI = zeros(N,M);
for i = 1:N
    PHI(i,:) = phi(X(i)); % N x M
end
% Prior variance
sig_prior = 10;
Sigma_p = sig_prior^2 * eye(M); % Cov-Matrix of the prior over w
% Moments of the posterior of w
w_mean = ((PHI' * PHI) + sig_e^2 * inv(Sigma_p)) \ PHI' * Y; % M x 1
w_Covar_Matrix = ((1/sig_e^2) * (PHI'*PHI) + inv(Sigma_p)) \ eye(M); % M x M
% Test inputs
x_pr = -16:0.2:16;
% posterior mean and variance of f
f_mean = zeros(1,length(x_pr)); sigma_post = f_mean;
for i = 1:length(x_pr)
    f_mean(i) = phi(x_pr(i)) * w_mean;
    sigma_post(i) = phi(x_pr(i)) * w_Covar_Matrix * phi(x_pr(i))';
end
% Sampling functions from Posterior of w
Num_Funct = 3;
w_sample = mvnrnd(w_mean, w_Covar_Matrix, Num_Funct);
f_samples_from_post = zeros(length(x_pr), Num_Funct);
for i = 1:length(x_pr)
    f_samples_from_post(i,:) = phi(x_pr(i)) * w_sample';
end
% Plot results
V1 = f_mean - sqrt(sigma_post); V2 = f_mean + sqrt(sigma_post);
figure(1), clf
fill([x_pr, fliplr(x_pr)], [V1, fliplr(V2)], 'k', ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.7); hold on
plot(x_pr,f_mean, 'k', 'LineWidth', 5)
plot(x_pr, f_samples_from_post, '--', 'LineWidth', 3);
plot(X, Y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
axis([-16 16 -4.2 4.2]), set(gca, 'Fontsize', 20), box on
% Alternative procedure: Sampling functions from Posterior
PHI_pr = zeros(length(x_pr),M);
for i = 1:length(x_pr)
    PHI_pr(i,:) = phi(x_pr(i));
end
CovMatr_post = PHI_pr * w_Covar_Matrix * PHI_pr';
Num_Funct = 3;
f_samples_from_post = mvnrnd(f_mean, CovMatr_post, Num_Funct);
% Alternative formulation of f_mean
w_mean_alt = Sigma_p * PHI' / (PHI*Sigma_p*PHI' + sig_e^2*eye(N)) * Y;
w_mean - w_mean_alt  % check equality
w_Covar_Matrix_alt = Sigma_p - Sigma_p * PHI' / ...
                     (PHI*Sigma_p*PHI' + sig_e^2*eye(N)) * PHI*Sigma_p;
w_Covar_Matrix - w_Covar_Matrix_alt % check equality
f_mean_alt = zeros(1,length(x_pr));
for i = 1:length(x_pr)
    f_mean_alt(i) =  phi(x_pr(i)) * w_mean_alt;
end
figure(2), clf, plot(x_pr, sigma_post, 'k--', 'LineWidth', 3), hold on,
plot(X, zeros(1,N), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
axis([-22 22 0 1.5]), set(gca, 'Fontsize', 20), box on