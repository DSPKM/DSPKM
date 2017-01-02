% 3-step ahead prediction on the respiratory motion time series.
clear, clc
currentdir = pwd; cd ../kafbox/; install; cd(currentdir)
%% Parameters
h = 3; % prediction horizon
L = 8; % embedding
n = 1000; % number of data
sigma = 7; % kernel parameter
% Uncomment one of the following algorithms. All use a Gaussian kernel.
% kaf = norma(struct('lambda',1E-4,'tau',30,'kernelpar',sigma,'eta',0.99));
% kaf = qklms(struct('epsu',1,'kernelpar',sigma,'eta',0.99));
kaf = swkrls(struct('M',50,'kernelpar',sigma,'c',1E-4));
% kaf = krlst(struct('M',50,'lambda',0.999,'sn2',1E-4,'kernelpar',sigma));
%% Prepare data
data = load('respiratorymotion3.dat');
X = zeros(n,L);
for i = 1:L,
    X(i:n,i) = data(1:n-i+1,1); % time embedding
end
y = data((1:n)+h);
%% Run algorithm
MSE = zeros(n,1);
y_est_all = zeros(n,1);
title_ = upper(class(kaf)); % store algorithm name
fprintf('Training %s',title_)
for i = 1:n,
    if ~mod(i,floor(n/10)), fprintf('.'); end % progress indicator  
    xi = X(i,:);
    yi = y(i);
    y_est = kaf.evaluate(xi); % evaluate on test data
    MSE(i) = (yi-y_est)^2; % test error
    y_est_all(i) = y_est;
    kaf = kaf.train(xi,yi); % train with one input-output pair    
end
fprintf('\n');
%% Output
fprintf('Mean MSE: %.2fdB\n\n',10*log10(mean(MSE))); 
figure(1); clf; hold all;
t = (1:n)/26; % sample rate is 26 Hz
plot(t,y), plot(t,y_est_all,'r')
legend({'original',sprintf('%s prediction',title_)},'Location','SE');
