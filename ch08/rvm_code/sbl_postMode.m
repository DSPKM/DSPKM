% SBL_POSTMODE	Find posterior mode for sparse Bayes classification 
% 
%
% (c) Microsoft Corporation. All rights reserved. 
%

function [w, Ui, betaED] = sbl_postMode(PHI,t,alpha,w,its)

getEnvironment;

STOP_CRITERION	= 1e-6;
LAMBDA_MIN	= 2^(-8);

[N d]	= size(PHI);
M 	= length(w);

A	= diag(alpha);

errs	= zeros(its,1);
PHIw	= PHI*w;
y	= sigmoid(PHIw);
t	= logical(t);

data_term	= -(sum(log(y(t))) + sum(log(1-y(~t))))/N;
regulariser	= (alpha'*(w.^2))/(2*N);
err_new		=  data_term + regulariser;

for i=1:its
  vary	= y.*(1-y);
  PHIV	= PHI .* (vary * ones(1,d));
  e	= (t-y);
  
  g		= PHI'*e - alpha.*w;
  Hessian	= (PHIV'*PHI + A);

  if i==1
    condHess	= rcond(Hessian);
    if condHess<eps
      fprintf(2,'(postMode) warning: ill-conditioned Hessian (%g)\n', ...
	      condHess);
      fprintf(2,'(postMode) returning immediately for alpha-update\n');
      return
    end
  end

  errs(i)	= err_new;
  if ENV.InfoLevel>=3
    fprintf(ENV.logID,'PostMode Cycle: %2d\t error: %.6f\n', i, errs(i));
  end
  if i>=2 & norm(g)/M<STOP_CRITERION
    errs	= errs(1:i);
    if ENV.InfoLevel>=3
      fprintf(ENV.logID,['(postMode) converged (<%g) after %d iterations, ' ...
	    'gradient = %g\n'], STOP_CRITERION,i,norm(g)/M);
    end
    break
  end
 
  U		= chol(Hessian);
  delta_w	= U \ (U' \ g);
  lambda	= 1;
  while lambda>LAMBDA_MIN
    w_new	= w + lambda*delta_w;
    PHIw	= PHI*w_new;
    y		= sigmoid(PHIw);
       
    if any(y(t)==0) | any(y(~t)==1)
      err_new	= inf;
    else
      data_term		= -(sum(log(y(t))) + sum(log(1-y(~t))))/N;
      regulariser	= (alpha'*(w_new.^2))/(2*N);
      err_new		=  data_term + regulariser;
   end
       if err_new>errs(i)
      lambda	= lambda/2;
      if ENV.InfoLevel>=3
	fprintf(ENV.logID,['(postMode) error increase! Backing off ... (' ...
	' %.3f)\n'], lambda);
      end
    else
      w		= w_new;
      lambda	= 0;
    end
  end
  if lambda
    if ENV.InfoLevel>=3
      fprintf(ENV.logID,['(postMode) stopping due to back-off limit,' ...
			 'gradient = %g\n'],sum(abs(g)));
    end
    break;
  end
end

Ui	= inv(U);
betaED	= e'*(e.*vary);


%%
%%
function y = sigmoid(x)
y = 1./(1+exp(-x));