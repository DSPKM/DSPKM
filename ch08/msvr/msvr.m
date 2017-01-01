% Multioutput SVR
% We have m labeled examples, d dimensions and k outputs to predict.

% inputs:   - x : training patterns (m x d),
%           - y : training targets (m x k),
%           - ker : kernel type ('lin', 'poly', 'rbf'),
%           - C : cost parameter,
%           - par : kernel parameter (see function 'kernelmatrix') ,
%           - tol : tolerance.

function [Beta,NSV,H,i1] = msvr(x,y,ker,C,epsi,par,tol)

n_m = size(x,1); % samples
n_k = size(y,2); % output data dimensionality (output variables)

% build the kernel matrix on the labeled samples
H = kernelmatrix(ker,x',x',par);

% create matrix for regression parameters
Beta = zeros(n_m,n_k);

% E = prediction error per output (n_m x n_k)
E = y - H * Beta;
u = sqrt(sum(E.^2,2));

% RMSE
RMSE(1,1) = sqrt(mean(u.^2));

% points for which prediction error is larger than epsilon
i1 = find(u >= epsi);

% set initial values of alphas
a = 2 * C * (u - epsi) ./ u;

% contains the loss!
% Lp = zeros(1,1000);

% L (n_m x 1)
L = zeros(size(u));

% we modify only entries for which  u > epsi. with the sq slack
% L(i) = (RSE(i) - epsi).^2
L(i1) = u(i1).^2 - 2 * epsi * u(i1) + epsi^2;

% Lp is the quantity to minimize (sq norm of parameters + slacks)
Lp(1,1) = sum(diag(Beta'*H*Beta)) / 2 + C * sum(L) / 2;

k = 2;
do = 1;

while (do)
    Beta_a = Beta;
    u_a = u;
    i1_a = i1;
    % M1 = K + D_a + 1 = y (only for obs i1. see above)
    M1 = (H(i1,i1) + diag(1./a(i1))) + 1e-10 * eye(length(a(i1)));
    % compute betas
    sal1 = M1 \ y(i1,:);
    
    eta = 1;
    Beta = zeros(size(Beta));
    Beta(i1,:) = sal1;
    
    % error
    E = y - H * Beta;
    % RSE
    u = sqrt(sum(E.^2,2));
    i1 = find(u >= epsi);
    
    L = zeros(size(u));
    L(i1) = u(i1).^2 - 2 * epsi * u(i1) + epsi^2;
    % recompute the loss function
    Lp(k,1) = sum(diag(Beta'*H*Beta)) / 2 + C * sum(L) / 2;
    
    % Loop where we keep alphas and modify betas
    while (Lp(k,1) > Lp(k-1,1))
        eta = eta / 10;
        i1 = i1_a;
        
        Beta = zeros(size(Beta));
        % the new betas are a combination of the current (sal1)
        % and of the previous iteration (Beta_a)
        Beta(i1,:) = eta * sal1 + (1-eta) * Beta_a(i1,:);
        
        E = y - H * Beta;
        u = sqrt(sum(E.^2,2));
        i1 = find(u >= epsi);
        
        L = zeros(size(u));
        L(i1) = u(i1).^2 - 2 * epsi * u(i1) + epsi^2;
        Lp(k,1) = sum(diag(Beta'*H*Beta)) / 2 + C * sum(L) / 2;
        % stopping criterion #1
        if (eta < 1e-16)
            'stop 0';
            Lp(k,1) = Lp(k-1,1) - 1e-15;
            Beta = Beta_a;
            % ---------------
            u = u_a;
            i1 = i1_a;
            % ---------------
            do = 0;
        end
    end
    
    % here we modify the alphas and keep betas.
    a = 2 * C * (u - epsi) ./ u;
    RMSE(k,1) = sqrt(mean(u.^2));
    
    % stopping criterion #2
    if ((Lp(k-1,1)-Lp(k,1)) / Lp(k-1,1) < tol)
        do = 0;
    end
    
    k = k + 1;
    
    % stopping criterion #3 - algorithm does not converge. (val = -1)
    if (isempty(i1))
        do = 0;
        Beta = zeros(size(Beta));
        %val = -1;
        'stop 2';
    end
end

NSV = length(i1);
