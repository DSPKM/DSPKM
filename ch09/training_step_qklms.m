k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
y = k' * alpha; % evaluate function output
err = d - y; % instantaneous error
[d2,j] = min(sum((dict - repmat(x,m,1)).^2,2)); % distance to dictionary
if d2 <= epsu^2,
    alpha(j) = alpha(j) + eta*err; % reduced coefficient update
else
    dict = [dict; x]; % add base to dictionary
    alpha = [alpha; eta*err]; % add new coefficient
end