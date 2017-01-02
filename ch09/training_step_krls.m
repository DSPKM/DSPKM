k = kernel(dict,x,kerneltype,kernelpar); % kernels between dictionary and x
kxx = kernel(x,x,kaf.kerneltype,kaf.kernelpar); % kernel on x
a = Kinv * k; % coefficients of closest linear combination in feature space
gamma = kxx - k' * a; % residual of linear approximation in feature space
y = k' * alpha; % evaluate function output
err = d - y; % instantaneous error
if gamma>nu % new datum is not approximately linear dependent
    dict = [dict; x]; % add base to dictionary
    Kinv = 1/gamma*[gamma*Kinv+a*a',-a;-a',1]; % update inv. kernel matrix
    Z = zeros(size(P,1),1);
    P = [P Z; Z' 1]; % add linear combination coeff. to projection matrix
    ode = 1/gamma*err;
    alpha = [alpha - a*ode; ode]; % full update of coefficients
else % perform reduced update of alpha
    q = P * a / (1 + a'*P*a);
    P = P - q * (a' * P); % update projection matrix
    alpha = alpha + Kinv * q * err; % reduced update of coefficients
end