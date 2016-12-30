function symbolic7

syms t w
x = heaviside(t+2) - heaviside(t-2);
X = fourier(x,t,w);
ezplot(X,[-2*pi,2*pi]), axis tight, grid on
