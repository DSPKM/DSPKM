function model = trainGPR(X1,Y1)

[Nsamples Nfeatures] = size(X1);

% Define the kernel matrix structure:
% We use a composite kernel accounting for different signal (spectra) and
% noise relations. Specifically, we adopt an RBF kernel for signal
% relations (covSum) with adaptive lengthscale (covSEard), and a diagonal
% noise covariance matrix.

K = {'covSum', {'covSEardj','covNoise'}};
% K = {'covSEiso'};

% We have now specified the functional form of the covariance -the kernel- function
% but we still need to specify values of the parameters of these
% covariance functions. In our case we have 3 parameters (also sometimes
% called hyperparameters):
%  - width for the RBF kernel
%  - a signal scaling factor for the kernel
%  - standard deviation of the noise. The logarithm
% of these parameters are specified

% We will model weights by maximizing the marginal likelihood instead of
% doing a free parameters tuning, as this is very expensive with our
% superflexible kernel.

lengthscales = log((max(X1)-min(X1))/2)';
SignalPower  = var(Y1);
NoisePower   = SignalPower/4;

% lengthscales = zeros(Nfeatures,1);
% SignalPower  = 1;
% NoisePower   = 0.2;

[loghyper fvals iter] = minimize([lengthscales; 0.5*log(SignalPower); 0.5*log(NoisePower)], 'gpr', -100, K, X1, Y1);

model.loghyper = loghyper;
model.fvals = fvals;
model.iter = iter;
model.K = K;
model.Xtrain = X1;
model.Ytrain = Y1;

