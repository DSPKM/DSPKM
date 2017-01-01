function [Hx,Hy,Hx2,Hy2] = BuildData(X,Y,X2,Y2,D,p)

Hx  = buffer(X(D+2:end),p,p-1,'nodelay');	% input, train
Hy  = buffer(Y(1:end-1-D),p,p-1,'nodelay');	% output, train
Hx2 = buffer(X2(D+2:end),p,p-1,'nodelay');	% input, test
Hy2 = buffer(Y2(1:end-1-D),p,p-1,'nodelay'); % output, test
