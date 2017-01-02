k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
if (max(k) <= mu0), % coherence criterion
    dict = [dict; x]; % add base to dictionary
    alpha = [alpha; 0]; % reserve spot for new coefficient
end
k = kernel(dict,x,kerneltype,kernelpar); % kernels with new dictionary
y = k' * alpha; % evaluate function output
err = d - y; % instantaneous error
alpha = alpha + eta/(eps + k'*k)*err*k; % update coefficients