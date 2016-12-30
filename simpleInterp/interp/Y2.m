function [y,coefs] = Y2(tk,yk,t,T0,gamma)
nk = length(tk);
S = sinc((repmat(tk,1,nk) - repmat(tk',nk,1))/T0)/T0;
B = (S'*S + gamma*eye(size(S))) \ S';
[y,coefs] = interpSinc(tk,yk,t,T0,B);