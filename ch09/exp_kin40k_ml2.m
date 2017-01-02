% This demo estimates the optimal hyperparameters on the KIN40K data and
% performs online regression learning. The estimated parameters are:
% forgetting factor lambda, regularization c and Gaussian kernel width.
clear, clc; rng(1); % fix random seed, for reproducibility
currentdir = pwd; cd ../kafbox/; install; cd(currentdir)
%% Parameters
n_hyper = 1000; % number of data to use for hyperparameter estimation
n_train = 5000; % number of data for online training
n_test = 5000; % number of data for testing
test_every = 50; % run test every time this number of iterations passes
%% Selected algorithms are defined below
load('kin40k'); % data and hyperparameters
% Prepare data
indp = randperm(length(y)); % random permudation
ind_hyper = indp(1:n_hyper);
ind_train = indp(n_hyper+1:n_hyper+n_train);
ind_test = indp(n_hyper+n_train+1:n_hyper+n_train+n_test);
X_hyper = X(ind_hyper,:); % data for hyperparameter estimation
y_hyper = y(ind_hyper);
X_train = X(ind_train,:); % training data
y_train = y(ind_train);
X_test = X(ind_test,:); % test data
y_test = y(ind_test);
%% Estimate KRLS-T parameters
fprintf('Estimating KRLS-T parameters...\n\n')
[sigma,reg,ff] = kafbox_parameter_estimation(X_hyper,y_hyper);
%% Select algorithms
i = 1;
algos{i} = qklms(struct('eta',0.5,'epsu',1.2,'kernelpar',sigma)); i=i+1;
algos{i} = aldkrls(struct('nu',.32,'kernelpar',sigma)); i=i+1;
algos{i} = fbkrls(struct('M',500,'lambda',reg,'kernelpar',sigma)); i=i+1;
algos{i} = krlst(struct('lambda',ff,'M',500,'sn2',reg,'kernelpar',sigma)); i=i+1;
n_algos = length(algos);
MSE = nan * zeros(n_train,1);
titles = cell(n_algos,1);
final_dict_size = zeros(n_algos,1);
for j = 1:n_algos
    kaf = algos{j};
    titles{j} = upper(class(kaf));
    fprintf(sprintf('Running %s with estimated parameters...\n',titles{j}))
    for i = 1:n_train,
        if ~mod(i,floor(n_train/10)), fprintf('.'); end % progress indicator
        kaf = kaf.train(X_train(i,:),y_train(i)); % train with one input-output pair
        if mod(i,test_every) == 0 % run test only every
            y_est = kaf.evaluate(X_test); % predict on test set
            MSE(i,j) = mean((y_test-y_est).^2);
        end
    end
    if isprop(kaf, 'dict'), final_dict_size(j) = size(kaf.dict,1); end
    fprintf('\n');
    algos{j} = kaf;
end
%% Output
figure(1); clf; xs = find(~isnan(MSE(:,1)));
plot(xs,10*log10(MSE(xs,:))), legend(titles)
fprintf('\n');
fprintf('        Estimated\n');
fprintf('sigma:  %.4f\n',sigma)
fprintf('c:      %e\n',reg)
fprintf('lambda: %.4f\n\n',ff)
disp(final_dict_size)