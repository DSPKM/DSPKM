function [y,coefs] = Y1(tk,yk,t,T0)
nk = length(tk);
S = sinc((repmat(tk,1,nk) - repmat(tk',nk,1))/T0)/T0;
B = pinv(S);
[y,coefs] = interpSinc(tk,yk,t,T0,B);