y = x' * w; % evaluate filter output
err = d - y; % instantaneous error
g = P * x / (lambda + x'*P*x); % gain vector
w = w + g * err; % update filter coefficients
P = lambda \ (P - g*x'*P); % update inverse autocorrelation matrix