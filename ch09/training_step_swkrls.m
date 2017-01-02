dict = [dict; x]; % add base to dictionary
dict_d = [dict_d; d];	% add d to output dictionary
k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
Kinv = grow_kernel_matrix(Kinv,k,c); % calculate new inverse kernel matrix
if (size(dict,1) > M) % prune
    dict(1,:) = []; % remove oldest base from dictionary
    dict_d(1) = []; % remove oldest d from output dictionary
    Kinv = prune_kernel_matrix(Kinv); % prune inverse kernel matrix
end
alpha = Kinv * dict_d; % obtain new filter coefficients