function data = genDataDeconv(conf)
% Signal
x      = getsignal(conf.data.N,1);
% Convolution
h      = getri(conf.data.Q);
y      = filter(h,1,x);
% Noise Variance calculation
SNR    = 10.^(conf.SNR/10);
signal = norm(y)^2/length(y);
noise  = sqrt(signal./SNR);
% Signal with noise
switch conf.data.typeNoise
    case 1 % Signal with Gaussian noise
        z = y + noise*randn(size(y));
    case 2 % Signal with uniform noise
        z = y + noise*rand(size(y));
    case 3 % Signal with laplacian noise
        z = y + laplace_noise(length(y),1,noise);
end
% Return data structure
data.z=z; data.y=y; data.h=h; data.x=x; data.u=[];