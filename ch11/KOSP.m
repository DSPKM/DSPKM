function [D,sigmas] = KOSP(patterns,target,background)
ss = logspace(-2,2,21);j = 0;
for sigma = ss
    j = j+1;sigmas(j) = sigma; Xbd = [background;target];
    K_mm = kernelmatrix('rbf',Xbd',Xbd',sigma);
    K_bb = kernelmatrix('rbf',background',background',sigma);
    K_m = kernelmatrix('rbf',Xbd',target',sigma);
    K_mr = kernelmatrix('rbf',Xbd',patterns',sigma);
    K_bd = kernelmatrix('rbf',background',target',sigma);
    K_br = kernelmatrix('rbf',background',patterns',sigma);
    [Gamma values] = eig(K_mm);
    Gamma = Gamma./repmat(diag(values)',size(Gamma,1),1);
    [Beta values] = eig(K_bb);
    Beta = Beta./repmat(diag(values)',size(Beta,1),1);
    D(j,:) = (K_md'*(Gamma*Gamma')*K_mr)-(K_bd'*(Beta*Beta')*K_br);
end