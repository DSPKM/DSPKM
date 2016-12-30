function [y,coefs] = S1(tk,yk,t,T0)
B = 1; [y,coefs] = interpSinc(tk,yk,t,T0,B);