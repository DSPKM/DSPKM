function y = symbolic6(x,h)

% Example of use on command window:
% syms t
% x = exp(-3*t) .* heaviside(t);
% h = heaviside(t) - heaviside(t-3);
% y = symbolic6(x,h)

syms t tau
x = subs(x,t,tau);   
h = subs(h,t,t-tau); 
y = int( x.*h, tau, -Inf, Inf);