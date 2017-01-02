% perform one forgetting step
Sigma = lambda * Sigma + (1-lambda) * K; % forgetting on covariance matrix
mu = sqrt(lambda) * mu; % forgetting on mean vector
% kernels
k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
kxx = kernel(x,x,kaf.kerneltype,kaf.kernelpar); % kernel on x

q = Q * k;
y_mean = q' * mu; % predictive mean of new datum
gamma2 = kxx - k' * q; % projection uncertainty
h = Sigma * q;
sf2 = gamma2 + q' * h; % noiseless prediction variance
sy2 = sn2 + sf2; % unscaled predictive variance of new datum
y_var = s02 * sy2; % predictive variance of new datum

% include new sample and add a basis
Qold = Q; % old inverse kernel matrix
p = [q; -1];
Q = [Q zeros(m,1);zeros(1,m) 0] + 1/gamma2*(p*p'); % updated inverse matrix

err = d - y_mean; % instantaneous error
p = [h; sf2];
mu = [mu; y_mean] + err / sy2 * p; % posterior mean
Sigma = [Sigma h; h' sf2] - 1 / sy2 * (p*p'); % posterior covariance
dict = [dict; x]; % add base to dictionary

% estimate scaling power s02 via ML
nums02ML = nums02ML + lambda * (y - y_mean)^2 / sy2;
dens02ML = dens02ML + lambda; s02 = nums02ML / dens02ML;

% delete a basis if necessary
m = size(dict,1);
if m > M
    % MSE pruning criterion
    errors = (Q*mu) ./ diag(Q);
    criterion = abs(errors);
    [~, r] = min(criterion); % remove element which incurs in the min. err.
    smaller = 1:m; smaller(r) = [];
    if r == m, % remove the element we just added (perform reduced update)
        Q = Qold;
    else
        Qs = Q(smaller, r);
        qs = Q(r,r); Q = Q(smaller, smaller);
        Q = Q - (Qs*Qs') / qs; % prune inverse kernel matrix
    end
    mu = mu(smaller); % prune posterior mean
    Sigma = Sigma(smaller, smaller); % prune posterior covariance
    dict = dict(smaller,:); % prune dictionary
end