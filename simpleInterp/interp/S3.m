function [y,coefs] = S3(tk,yk,t,T0)
nk = length(tk);
S = sinc((repmat(tk,1,nk) - repmat(tk',nk,1))/T0);
b = T0./sum(S.^2);
B = diag(b,0);
[y,coefs] = interpSinc(tk,yk,t,T0,B);