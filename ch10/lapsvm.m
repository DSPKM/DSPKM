function [alpha,b]=lapsvm(K,Y,L,lambda1,lambda2)

I = eye(size(K,1)); lab = find(Y); l = length(lab);

if isempty(L) || lambda2 == 0 % SVM
    G = I / (2*lambda1) ;     % Csvmmax = 1 / (2*lambda1*l) = 1/(2*gA*l)
else                          % Laplacian SVM
    G = (2*lambda1*I + 2*lambda2*L*K) \ I;
end
Gram = K*G; Gram = Gram(lab,lab); Ylab=Y(lab);
% Calling libSVM
C = 1; % C = 1 in Laplacian SVM
model = mexsvmtrain(Ylab, Gram, ['-t 4 -s 0 -c ' num2str(C)]);
betay = model.sv_coef; svs = model.SVs; nlab = model.Label;
% b = model.rho;
% nsv = model.nSV; 
if nlab(1) == -1, betay = -betay; end;
Betay = zeros(l,1); Betay(svs+1) = betay';
alpha = G(:,lab) * Betay; b = 0; % Laplacian SVM dual weights