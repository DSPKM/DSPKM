% SBL_ESTIMATE	Estimate hyperparameters for a sparse Bayesian model
% 
% [W,USED,ML,A,B,G]	= SBL_ESTIMATE(PHI,T,A,B,MAXITS,MONITS)
% 
%	W		trained weights (subset of full model)
%	USED		index into column of PHI of relevant basis
%	ML		marginal likelihood of final model
%	A		estimated 'alpha' values
%	B		estimated 'beta' for regression
%	G		estimated 'gamma' (well-determinedness) parameters
% 
%	PHI		basis function/design matrix
%	T		target vector
%	A		initial alpha value (scalar)
%	B		initial beta value (negative to fix in regression,
%			zero for classification)
%	MAXITS		maximum number of iterations to run for
%	MONITS		monitor training info every MONITS iterations
%			[optional] 
% 
% (c) Microsoft Corporation. All rights reserved. 
%

function [weights, used, marginal, alpha, beta, gamma] = ...
    sbl_estimate(PHI,t,alpha,beta,maxIts,monIts)

getEnvironment;

% Terminate estimation when no log-alpha value changes by more than this
MIN_DELTA_LOGALPHA	= 1e-3;
% Prune basis function when its alpha is greater than this
ALPHA_MAX		= 1e12;
% Iteration number during training where we switch to 'analytic pruning'
PRUNE_POINT		= 50;		% percent

if beta==0
  % Classification settings
  REGRESSION	= 0;
  PM_MAXITS	= 25;	% Posterior mode-finder
else
  % Regression settings
  REGRESSION	= 1;
  FIXED_BETA	= beta<0;
  beta		= abs(beta);
end
% If not monitoring specified, we won't do any
if ~exist('monIts')
  monIts	= 0;
end

[N,M]	= size(PHI);
w	= zeros(M,1);
PHIt	= PHI'*t;

alpha		= alpha*ones(M,1);
gamma		= ones(M,1);
nonZero		= logical(ones(M,1));
PRUNE_POINT	= maxIts * (PRUNE_POINT/100);
LAST_IT		= 0;
marginal    = zeros(1,maxIts);

for i=1:maxIts
  % 
  % Prune large values of alpha
  % 
  nonZero	= (alpha<ALPHA_MAX);
  alpha_nz	= alpha(nonZero);
  w(~nonZero)	= 0;
  M		= sum(nonZero);
  % Work with non-pruned basis
  % 
  PHI_nz	= PHI(:,nonZero);
  if REGRESSION
    Hessian	= (PHI_nz'*PHI_nz)*beta + diag(alpha_nz);
    U		= chol(Hessian);
    Ui		= inv(U);
    w(nonZero)	= (Ui * (Ui' * PHIt(nonZero)))*beta;
    
    ED		= sum((t-PHI_nz*w(nonZero)).^2); % Data error
    betaED	= beta*ED;
    logBeta	= N*log(beta); 
  else
    % Must call posterior mode finder, which returns mode and inverse
    % Cholesky factor of the Hessian
    [w(nonZero) Ui betaED] = ...
	sbl_postMode(PHI_nz,t,alpha_nz,w(nonZero),PM_MAXITS);
    logBeta	= 0;
  end
  % Quick ways to get determinant and diagonal of posterior weight
  % covariance matrix 'SIGMA'
  logdetH	= -2*sum(log(diag(Ui)));
  diagSig	= sum(Ui.^2,2);
  % well-determinedness parameters
  gamma		= 1 - alpha_nz.*diagSig;

  % Compute marginal likelihood (approximation for classification case)
  marginal(i)	= -0.5* (logdetH - sum(log(alpha_nz)) - ...
			 logBeta + betaED + (w(nonZero).^2)'*alpha_nz);

	% from spider ....
	if(marginal(i)==-Inf)
	    break;
	end
 
  % Output info if requested and appropriate monitoring iteration
  if ENV.InfoLevel & (LAST_IT | (monIts & ~rem(i,monIts)))
    if REGRESSION
      fprintf(ENV.logID,'%5d> L = %.3f\t Gamma = %.2f (nz = %d)\t s=%.3f\n',...
	      i, marginal(i), sum(gamma), sum(nonZero), sqrt(1/beta));
    else
      fprintf(ENV.logID,'%5d> L = %.3f\t Gamma = %.2f (nz = %d)\n',...
	      i, marginal(i), sum(gamma), sum(nonZero));
    end
  end

  if ~LAST_IT
    % 
    % alpha and beta re-estimation on all but last iteration
    % (we just update the posterior statistics the last time around)
    % 
    logAlpha		= log(alpha(nonZero));
    if i<PRUNE_POINT
      % MacKay-style update given in original NIPS paper
      alpha(nonZero)	= gamma ./ w(nonZero).^2;
    else
      % Hybrid update based on NIPS theory paper and AISTATS submission
      alpha(nonZero)	= gamma ./ (w(nonZero).^2./gamma - diagSig);
      alpha(alpha<=0)	= inf; % This will be pruned later
    end
    anz		= alpha(nonZero);
    maxDAlpha	= max(abs(logAlpha(anz~=0)-log(anz(anz~=0))));
    % Terminate if the largest alpha change is judged too small
    if maxDAlpha<MIN_DELTA_LOGALPHA
      LAST_IT	= 1;
      if ENV.InfoLevel>=2
	fprintf(ENV.logID,...
		'Terminating: max log(alpha) change is %g (<%g).\n', ...
		maxDAlpha, MIN_DELTA_LOGALPHA);
      end
    end
    %
    % Beta re-estimate in regression (unless fixed)
    % 
    if REGRESSION & ~FIXED_BETA
      beta	= (N - sum(gamma))/ED;
    end
  else
    % Its the last iteration due to termination, leave outer loop
    break;	% that's all folks!
  end
end
% Tidy up return values
weights	= w(nonZero);
used	= find(nonZero);

if ENV.InfoLevel>=2
  fprintf(ENV.logID,'*\nHyperparameter estimation complete\n');
  fprintf(ENV.logID,'non-zero parameters:\t%d\n', length(weights));
  fprintf(ENV.logID,'log10-alpha min/max:\t%.2f/%.2f\n', ...
	  log10([min(alpha_nz) max(alpha_nz)]));
end
  
  