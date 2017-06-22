function [L,Ls,Ld] = Laplacians(X1,U1,Y1,X2,U2,Y2)

graph.nn = 6;
graph.mu = 0.5;

Y = [Y1;Y2];

% Build graphs
G1 = buildKNNGraph([X1,U1]',graph.nn,1);
G2 = buildKNNGraph([X2,U2]',graph.nn,1);
W = blkdiag(G1,G2);
W = double(full(W));

Ws  = repmat(Y,1,length(Y)) == repmat(Y,1,length(Y))'; Ws(Y == 0,:) = 0; 
Ws(:,Y == 0) = 0; 
Ws = double(Ws);

Wd  = repmat(Y,1,length(Y)) ~= repmat(Y,1,length(Y))'; 
Wd(Y == 0,:) = 0; 
Wd(:,Y == 0) = 0; 
Wd = double(Wd);

Sws = sum(sum(Ws));
Sw  = sum(sum(W));
Ws  = Ws / Sws * Sw;

Swd = sum(sum(Wd));
Wd  = Wd / Swd * Sw;

Ds  = sum(Ws,2); Ls = diag(Ds) - Ws;
Dd  = sum(Wd,2); Ld = diag(Dd) - Wd;
D   = sum(W,2); 
L   = diag(D) - W;