% ESTIMATESIGMA This function estimates reasonable sigma values for the RBF kernel using different methods.
%
%    sigma = estimateSigma(X,Y,method)
%
%    INPUTS:
%       X      : data matrix: n samples, d features: n x d
%       Y      : labels for data, n x 1 (optional)
%       method :
%
%         ---unsupervised approaches, call: estimateSigma(X,[],method)
%
%          1:  'mean' (default)  ........ Average distance between all samples
%          2:  'median' ................. Median of the distances between all samples
%          3:  'mode' ................... Mode of the distances between all samples
%          4:  'quantiles' .............. 10 values to try in the range of 0.05-0.95
%                                         percentiles of the distances between all samples
%          5:  'histo' .................. Sigma proportional to the dimensionality and feature variance
%          6:  'range' .................. 10 values to try in the range of 0.2-0.5 of the feature range
%          7:  'silverman' .............. Median of the Silverman's rule per feature
%          8:  'scott' .................. Median of the Scott's rule per feature
%          9:  'maxlike' ................ Maximum likelihood estimate (with standard cross-validation)
%         10:  'bayes' .................. Maximum Bayes estimate (with standard cross-validation)
%         11:  'entropy' ................ Maximum Entropy estimate (with standard cross-validation)
%         12:  'ksdens' ................. Average estimate of univariate/marginal kernel density estimates
%         13:  'kde' .................... KDE using Gaussian kernel
%                                       (http://www.ics.uci.edu/~ihler/code/kde.html is needed)
%
%         ---supervised approaches, call: estimateSigma(X,Y,method)
%
%         14:  'alignment' .............. Kernel alignment (i.e. HSIC maximization between data and labels)
%         15:  'krr' .................... Kernel ridge regression
%
%    OUTPUTS:
%       sigma  : the estimated sigmas in a Matlab structure
%       cost   : the estimated CPU time for computing the corresponding sigma
%
% Gustau Camps-Valls, 2013
%   gustau.camps@uv.dot.es, http://isp.uv.es
%
% JoRdI, 2016
%   jordi@uv.dot.es

function [sigma cost] = estimateSigma(X,Y,method)

if ~exist('Y','var')
    Y = [];
end
if ~exist('method','var')
    method = 'mean';
end

% Subsampling
[n d] = size(X);
idx = randperm(n);
if n > 1000
    n = 1000;
    X = X(idx(1:n),:);
    if ~isempty(Y)
        Y = Y(idx(1:n),:);
    end
end

% Range of sigmas
ss = 20;
SIGMAS = logspace(-3,3,ss);

if sum(strcmpi(method,'mean'))
    tic
    D = pdist(X);
    sigma = mean(D(D>0));
    cost = toc;
end

if sum(strcmpi(method,'median'))
    tic
    D = pdist(X);
    sigma = median(D(D>0));
    cost = toc;
end

if sum(strcmpi(method,'mode'))
    tic
    D = pdist(X);
    sigma = mode(D(D>0));
    cost = toc;
end

if sum(strcmpi(method,'quantiles'))
    tic
    D = pdist(X);
    sigma =  quantile(D(D>0),linspace(0.05,0.95,10));
    cost = toc;
end

if sum(strcmpi(method,'histo'))
    tic
    sigma = sqrt(d)*median(var(X));
    cost = toc;
end

if sum(strcmpi(method,'range'))
    tic
    mm = minmax(X');
    sigma = median(mm(:,2)-mm(:,1))*linspace(0.2,0.5,10);
    cost = toc;
end

if sum(strcmpi(method,'silverman'))
    tic
    sigma = median( ((4/(d+2))^(1/(d+4))) * n^(-1/(d+4)).*std(X,1) );
    cost = toc;
end

if sum(strcmpi(method,'scott'))
    tic
    sigma = median( diag( n^(-1/(d+4))*cov(X).^(1/2) ));
    cost = toc;
end

if sum(strcmpi(method,'maxlike'))
    tic
    mle = zeros(1,ss);
    r = randperm(n);
    ntrain = round(n*0.9);
    X1 = X(r(1:ntrain),:)';
    X2 = X(r(ntrain+1:end),:)';
    n1sq = sum(X1.^2);
    n1 = size(X1,2);
    n2sq = sum(X2.^2,1);
    n2 = size(X2,2);
    D = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*X1'*X2;
    for i = 1:ss
        s = SIGMAS(i);
        K = (1/(s*sqrt(2*pi)))*exp(-D/(2*s^2));
        mle(i) = sum(log(sum(K)./size(K,2)));
    end
    [~, idx] = max(mle);
    sigma = SIGMAS(idx);
    cost = toc;
end

if sum(strcmpi(method,'bayes'))
    tic
    bayes = zeros(1,ss);
    r = randperm(n);
    ntrain = round(n*0.9);
    X1 = X(r(1:ntrain),:)';
    X2 = X(r(ntrain+1:end),:)';
    n1sq = sum(X1.^2);
    n1 = size(X1,2);
    n2sq = sum(X2.^2,1);
    n2 = size(X2,2);
    D = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*X1'*X2;
    for i = 1:ss
        s = SIGMAS(i);
        K = (1/(s*sqrt(2*pi)))*exp(-D/(2*s^2));
        bayes(i) = sum(log(sum(K)./size(K,2)))+log(1./SIGMAS(i));
    end
    [~, idx] = max(bayes);
    sigma = SIGMAS(idx);
    cost = toc;
end

if sum(strcmpi(method,'entropy'))
    tic
    entropy = zeros(1,ss);
    r = randperm(n);
    ntrain = round(n*0.9);
    X1 = X(r(1:ntrain),:)';
    X2 = X(r(ntrain+1:end),:)';
    n1sq = sum(X1.^2);
    n1 = size(X1,2);
    n2sq = sum(X2.^2,1);
    n2 = size(X2,2);
    D = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*X1'*X2;
    for i = 1:ss
        s = SIGMAS(i);
        K = (1/(s*sqrt(2*pi)))*exp(-D/(2*s^2));
        entropy(i) = sum(K(:));
    end
    [~, idx] = max(entropy);
    sigma = SIGMAS(idx);
    cost = toc;
end

if sum(strcmpi(method,'ksdens'))
    tic
    estim = zeros(1,d);
    for i=1:size(X,2)
        [~,~,estim(i)]= ksdensity(X(:,i));
    end
    sigma = mean(estim);
    cost = toc;
end

if sum(strcmpi(method,'kde'))
    tic
    px = kde(X','lcv');
    s  = getBW(px);
    sigma = unique(s);
    cost = toc;
end

if sum(strcmpi(method, 'alignment')) && ~isempty(Y)
    tic   
    H = eye(n) - 1/n*ones(n,n);
    Ky = Y * Y';
    ka = zeros(1,ss);
    SIGMAS = logspace(-3,3,ss);
    for i = 1:ss
        s = SIGMAS(i);
        Kx = kernelmatrix('rbf',X',X',s);
        ka(i) = trace(H * Kx * H * Ky);
    end
    [~, idx] = max(ka);
    sigma = SIGMAS(idx);
    cost = toc;  
end

if sum(strcmpi(method, 'krr')) && ~isempty(Y)
    tic   
    r = randperm(n);
    ntrain = round(n*0.9);
    X1 = X(r(1:ntrain),:);  X2 = X(r(ntrain+1:end),:);
    Y1 = Y(r(1:ntrain),:);  Y2 = Y(r(ntrain+1:end),:);
    res = zeros(ss*10,3);
    k = 0;
    for i = 1:ss
        s = SIGMAS(i);
        K = kernelmatrix('rbf',X1',X1',s);
        for g=logspace(-4,4,10)
            k=k+1;
            alpha = (K+g*eye(size(K)))\Y1;
            Ktest = kernelmatrix('rbf',X2',X1',s);
            Yp    = Ktest*alpha;
            res(k,:) = [s g norm(Y2-Yp,'fro')];
        end
    end
    [~, idx] = min(res(:,3));
    sigma = res(idx,1);
    cost = toc;  
end

% fprintf('method: %s, sigma: %f, cpmp. time: %f\n', method, sigma, cost)
