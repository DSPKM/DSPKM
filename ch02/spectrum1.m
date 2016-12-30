N = 1024;
t = 0:N-1;
w1 = 0.3*pi; w2 = 0.7*pi; w3 = 0.8*pi; % Frequencies
x = sin(w1*t) + sin(w2*t) + sin(w3*t); % Signal
x = x + 0.4 * randn(size(x));          % Noise added
