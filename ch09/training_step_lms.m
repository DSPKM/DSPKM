y = x' * w; % evaluate filter output
err = d - y; % instantaneous error
w = w + mu * x * err'; % update filter coefficients