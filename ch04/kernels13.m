function kernels13
sn = 0.05;     % Noise std
L = 4;         % Filter length
p = sqrt(2)*2; % Kernel parameter
N = 1000;
h = [1 0.5-1j*0.5 .1+1j*.1]; % Linear channel impulse response

% Data
d = sign(randn(1,N)) + 1j*sign(randn(1,N));
d_test = sign(randn(1,N)) + 1j*sign(randn(1,N));

% Channel 
x = channel(d,h,sn);
x_test = channel(d_test,h,sn);

% Data matrix
X = buffer(x,L,L-1)';
X_test = buffer(x_test,L,L-1)';

% Equalization with Linear MMSE
R = X' * X;
R = R + sn^2*eye(size(R));
w = d * X / R;
y = w * X_test';
figure(1), plotresults(y,d_test), title('Linear MMSE eq.')

% Equalization with Kernel MMSE
K = kernel_matrix(X,X,p);
alpha = d * pinv(K + sn^2*eye(size(K)));
K_test = kernel_matrix(X_test,X,p);
y = alpha * K_test;
figure(2), plotresults(y,d_test), title('Kernel MMSE eq.')

function x = channel(d,h,s)
% Channel: Linear section
xl = filter(h,1,d);
% Channel: Nonlinear section
xnl = xl.^(1/3) + xl / 3;
% Noise
x = xnl + s*(randn(size(xl)) + 1j*randn(size(xl)));

function K = kernel_matrix(X1,X2,p)
N1 = size(X1,1);
N2 = size(X2,1);
aux = kron(X1,ones(N2,1)) - kron(ones(1,N1),X2')';
D = buffer(sum(aux.*conj(aux),2),N2,0);
K = exp(-D/(2*p));

function plotresults(y,d)
plot(real(y(d == 1+1j)),  imag(y(d == 1+1j)),  'bo'), hold on
plot(real(y(d == -1-1j)), imag(y(d == -1-1j)), 'rs')
plot(real(y(d == 1-1j)),  imag(y(d == 1-1j)),  'm^')
plot(real(y(d == -1+1j)), imag(y(d == -1+1j)), 'kv'), hold off
axis equal, grid on