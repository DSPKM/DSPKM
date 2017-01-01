% Assume X data matrix: N samples, d features: N x d
% 1: 'mean': Average distance between all samples
D = pdist(X); sigma.mean = mean(D(D>0));
% 2:  'median': Median of the distances between all samples
D = pdist(X); sigma.median = median(D(D>0));
% 3:  'quantiles': 10 values in the range of 0.05-0.95 distance percentiles
D = pdist(X); sigma.quantiles = quantile(D(D>0),linspace(0.05,0.95,10));
% 4:  'histo': Sigma proportional to the dimensionality and feature variance
sigma.sampling = sqrt(d) * median(var(X));
% 5:  'range': 10 values to try in the range of 0.2-0.5 of the feature range
mm = minmax(X'); sigma.range = median(mm(:,2)-mm(:,1))*linspace(0.2,0.5,10);
% 6:  'silverman': Median of the Silverman's rule per feature
sigma.silverman = median( ((4/(d+2))^(1/(d+4))) * n^(-1/(d+4)).*std(X,1) );
% 7:  'scott': Median of the Scott's rule per feature
sigma.scott = median( diag( n^(-1/(d+4))*cov(X).^(1/2)) );