% Example of EGPR
clear, clc
% GENERATING DATA
sig_e = 0.6; % std of the noise
X = -15:0.6:15; N = length(X); Y = sin(X) + sig_e * randn(1,N);
% kernel function
delta = 2; k = @(z1,z2) exp(-(z1-z2).^2/(2*delta^2));
% Inputs test
x_pr = -20:0.2:20;
% Complete GPR
% Kernel matrix
z1 = meshgrid(X); K = k(z1,z1');
Lambda = (K + sig_e^2 * eye(N));
% Posterior mean and variance of the complete GP
f_mean = zeros(1,length(x_pr)); sig_post = f_mean;
for i = 1:length(x_pr)
    kx = k(x_pr(i),X);
    f_mean(i) = kx / Lambda * Y'; % posterior mean
    sig_post(i) = k(x_pr(i),x_pr(i)) -  kx / Lambda * kx'; % posterior var.
end
% Partial GPs
R = 5; % number of partial GPs
Nr = fix(N/5); % number of data per GP (other choices are possible)
fr = zeros(R,length(x_pr)); sr = fr;
for r = 1:R
    pos = randperm(N,Nr); % random pick
    Xr = X(pos); Yr = Y(pos);
    zr = meshgrid(Xr); Kr = k(zr,zr');
    Lambda_r = (Kr + sig_e^2 * eye(Nr)); % for the partial GPs
    % posterior mean and variance for the partial GPs
    for i = 1:length(x_pr)
        kx_r = k(x_pr(i),Xr);
        fr(r,i) = kx_r / Lambda_r * Yr'; % partial posterior mean
        sr(r,i) = k(x_pr(i),x_pr(i)) - kx_r / Lambda_r * kx_r'; % p.p. var.
    end
end
% Ensemble GP solution
Prec = 1./sr; % precision
Den = sum(1./sr); Wn_prec = Prec./repmat(Den,R,1); % normalized weights
f_EGP = sum(Wn_prec.*fr); sig_ESP = mean(Wn_prec);
% Represent
figure(1), clf, plot(x_pr,f_EGP,'b','LineWidth',5), hold on
	plot(x_pr,fr,'--','LineWidth',2)
	plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',12)
axis([-20 20 -3.5 3.5]), set(gca,'Fontsize',20)
legend('Ensemble GP','Partial GPs'); box on
figure(2), clf, plot(x_pr,f_EGP,'b','LineWidth',5), hold on
    plot(x_pr,f_mean,'k--','LineWidth',2)
    plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',12)
axis([-20 20 -3.5 3.5]), set(gca,'Fontsize',20)
legend('Ensemble GP','Standard GP'); box on