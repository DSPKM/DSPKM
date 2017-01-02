k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
y = k' * alpha; % evaluate function output
err = d - y; % instantaneous error
kaf.dict = [kaf.dict; x]; % add base to dictionary
kaf.alpha = [kaf.alpha; kaf.eta*err]; % add new coefficient