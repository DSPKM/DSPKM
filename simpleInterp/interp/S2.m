function [y,coefs] = S2(tk,yk,t,T0)
nk = length(tk);
tkdesp = zeros(nk,1);
tkdesp(2:nk) = tk(1:nk-1);
subtr = tk(2:end) - tkdesp(2:end);
subtr = [subtr(:); mean(subtr(1:end-1))];
B = diag(subtr,0);
[y,coefs] = interpSinc(tk,yk,t,T0,B);