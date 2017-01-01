% COMPUTERESULTS
%
%	This function computes different accuracy/bias measurements from an actual and predicted signals.
%
% INPUTS:
% 		Des	:	Desired (actual) signal
% 		Pred:   Prediction (estimation) signal
%
% OUTPUTS:
%		ME:		Mean error (mean of the residuals). Bias
%		MSE:	Mean square error
%		MAE:	Mean absolute error
%		r:		Correlation coefficient
%		nMSE:	Normalized MSE
% 
% Gustavo Camps-Valls, 2006(c)
% gcamps@ieee.org

function results = ComputeResults(Pred,Des)

results.ME = mean(Des-Pred);
results.MSE = mean((Des-Pred).^2);
results.MAE = mean(abs(Des-Pred));
rr = corrcoef(Des,Pred); 
results.r = rr(1,2);
results.nMSE = log10(sqrt(results.MSE/var(Des)));
