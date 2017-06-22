function K = kernelcentering(K, Ktrain)

% function K = kernelcentering(K, Ktrain)
%
% Centers the matrix K to have zero mean the mapped samples in the feature espace
% (opt) centers K with respect to a mean in the feature space from a noncentered training kernel Ktrain
%
% INPUTS
%  K = the kernel matrix to be centered (train or test if Ktrain is provided)
%  Ktrain = the uncentered kernel matrix of the samples used to center K (or the sum of its columns)
%
% OUTPUTS
%  Kc = the centered kernel matrix
%
% Mean of training mapped samples fm=1/N*sum{f(x)}
%   Kc(x,y) = fc(x)' * fc(y) = (fc(x) - fm)' * (fc(y) - fm) =
%     = K(x,y) - 1/N*sumi{K(x,xi)} - 1/N*sumi{K(xi,y)} + 1/N^2*sumij{K(xi,xj)}
%     = K(x,y) - 1/N*1'*kx - 1/N*1'*ky + 1/N^2*1'*K*1
%
% Luis.Gomez-Chova@uv.es, 2010(c)
% For more info, see www.kernel-methods.net

[Ni,Nj] = size(K);

if nargin == 1
    % CENTERING OF A TRAINING KERNEL (SQUARE AND SYMMETRIC: SAME MEAN FOR ROW AND COLUMN SAMPLES)
    %  S = sum(K)/Ni; %1/N*sumi{K(xi,*)}=1/N*1'*K row
    %  K = K - S'*ones(1,Nj) - ones(Ni,1)*S + (sum(S)/Ni)*ones(Ni,Nj);
    % CENTERING OF A GENERAL KERNEL (ROW AND COLUMN SAMPLES RESPECT ITS CORRESPONDING MEAN)
    %  Si = sum(K,1)/Ni; %1/Ni*sumi{K(xi,*)}=1/Ni*1'*K row Nj
    %  Sj = sum(K,2)/Nj; %1/Nj*sumj{K(*,xj)}=1/Nj*K*1' column Ni
    %  K = K - Sj*ones(1,Nj) - ones(Ni,1)*Si + (sum(Si)/Nj+sum(Sj)/Ni)*ones(Ni,Nj);
    K = K - mean(K,2)*ones(1,Nj) - ones(Ni,1)*mean(K,1) + mean(K(:));
else
    % CENTERING OF A TEST KERNEL (NON-SQUARE AND NON-SYMMETRIC) WITH RESPECT TO K (mean of mapped samples in rows: left)
    if all(size(Ktrain) > 1), % Ktrain == uncentered training kernel
        if any(size(Ktrain) ~= Ni), error('Ktrain size is not NxN'); end
        S = sum(Ktrain) / Ni; % 1/N*sumi{K(xi,*)}=1/N*1'*K row
    else % Ktrain == sum of the columns of the uncentered training kernel
        if numel(Ktrain) ~= Ni, error('Ktrain sum size is not 1xN'); end
        S = Ktrain / Ni; % 1/N*sumi{K(xi,*)}=1/N*1'*K row
    end
    K = K - S' * ones(1,Nj) - (ones(Ni,1)/Ni) * sum(K) + (sum(S)/Ni);
end
K(isnan(K)) = 0;
K(isinf(K)) = 0;

return

% function K=kernelcentering(K, Ktest)

% CENTERING OF A TRAINING KERNEL (SQUARE AND SYMMETRIC)
N = size(K,1);
% original kernel matrix stored in variable K
% output uses the same variable K
%  K is of dimension ell x ell
%  S is a row vector storing the column averages of K
%  E is the average of all the entries of K
S = sum(K) / N; % 1/N*sumi{K(xi,*)}=1/N*1'*K row
% E = sum(S)/N; % 1/N^2*sumij{K(xi,xj)}
% J = ones(N,1) * S; % expand to matrix size
%  Kc = K - J - J' + E * ones(N);
%  Kc = K - ones(N,1)*sum(K) - (1/N*ones(N,1)*sum(K))' + 1/N^2*sum(K(:))* ones(N); % one line
K = K - S'*ones(1,N)  - ones(N,1)*S + (sum(S)/N)*ones(N); % faster
% matrix notation
%  H = eye(N)-1/N*ones(N); %H=eye(N)-1/N*ones(N,1)*ones(1,N); % centering matrix of the training kernel
%  Kc = H * K * H;
% note: H is a general centering matrix. H = eye(N) - 1/N * ones(N); Xc = X * H; will center the rows of X (zero mean)
K(isnan(K)) = 0;
K(isinf(K)) = 0;

% CENTERING OF A TEST KERNEL (NON-SQUARE AND NON-SYMMETRIC) WITH RESPECT TO K
[N,Nt] = size(Ktest);
Ktest = Ktest - S'*ones(1,Nt) - (ones(N,1)/N) * sum(Ktest) + (sum(S)/N) * ones(N,Nt); % faster in one codeline
% matrix notation
% Ktest = H*(Ktest-S' * ones(1,Nt));
Ktest(isnan(Ktest)) = 0;
Ktest(isinf(Ktest)) = 0;

return
