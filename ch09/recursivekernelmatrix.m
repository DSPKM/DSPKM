% RECURSIVEKERNELMATRIX

% Kimn = recursivekernelmatrix(x1,x2,parameters);
%
% Inputs:
%	x1:	data matrix with training samples in rows and features in columns
%	x2:	data matrix with test samples in rows and features in columns
%	parameters: ker: {'lin' 'poly' 'rbf'}
%       p1
%           width of the RBF kernel
%           bias in the linear and polinomial kernel
%           degree in the polynomial kernel
%       P  filter order (tap)
%       mu gamma and Laguerre filters free parameter
%
% Output:
%	Kimn: recursive kernels (one per tap!)

function Kimn = recursivekernelmatrix(x1,x2,sigma,p,mu)

N1 = length(x1);	% Training samples
N2 = length(x2);	% Test samples
% Compute Kimn = K^i(m,n).
Kimn = zeros(p,N1,N2);
Kimn(1,:,:) = kernelmatrix('rbf',x1,x2,sigma*sigma);
for i = 2:p
    for m = 2:N1
        for n = 2:N2
            Kaux1 = 0;
            if m > 2
                for j = 2:(m-1)
                    Kaux1 = Kaux1 + (1-mu)^(j-1) * Kimn(i-1,m-j,n-1);
                end
            end
            Kaux2 = 0;
            if n > 2
                for j = 2:(n-1)
                    Kaux2 = Kaux2 + (1-mu)^(j-1) * Kimn(i-1,m-1,n-j);
                end
            end
            Kimn(i,m,n) = (1-mu)^2*Kimn(i,m-1,n-1) + ...
                mu^2 * Kimn(i-1,m-1,n-1) + mu^2 * (Kaux1+Kaux2);
        end
    end
end