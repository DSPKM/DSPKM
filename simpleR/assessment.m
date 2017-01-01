function RESULTS = assessment(Labels,PreLabels,par)

%
%   function RESULTS = assessment(Labels,PreLabels,par)
%
%   INPUTS:
%
%   Labels         : A vector containing the true (actual) labels for a given set of sample.
%   PreLabels      : A vector containing the estimated (predicted) labels for a given set of sample.
%	par			   : 'class' or 'regress'
%
%   OUTPUTS: (all contained in struct RESULTS)
%
%   ConfusionMatrix: Confusion matrix of the classification process (True labels in columns, predictions in rows)
%   Kappa          : Estimated Cohen's Kappa coefficient
%   OA             : Overall Accuracy
%   varKappa       : Variance of the estimated Kappa coefficient
%   Z              : A basic Z-score for significance testing (considering that Kappa is normally distributed)
%   CI             : Confidence interval at 95% for the estimated Kappa coefficient
%   Wilcoxon, sign test and McNemar's test of significance differences
%
%   Gustavo Camps-Valls, 2007(c)
%   gcamps@uv.es
%   
%   Formulae in:
%   Assessing the Accuracy of Remotely Sensed Data
%   by Russell G Congalton, Kass Green. CRC Press
%

switch lower(par)
	case {'class'}
	
	Etiquetas = union(Labels,PreLabels);     % Class labels (usually, 1,2,3.... but can work with text labels)
	NumClases = length(Etiquetas); % Number of classes
	
	% Compute confusion matrix
    ConfusionMatrix = zeros(NumClases);
	for i=1:NumClases
	        for j=1:NumClases
	                ConfusionMatrix(i,j) = length(find(PreLabels==Etiquetas(i) & Labels==Etiquetas(j)));
	        end;
	end;
	          
	% Compute Overall Accuracy and Cohen's kappa statistic
	n      = sum(ConfusionMatrix(:));                     % Total number of samples
	PA     = sum(diag(ConfusionMatrix));
	OA     = PA/n;
	
	% Estimated Overall Cohen's Kappa (suboptimal implementation)
	npj = sum(ConfusionMatrix,1);
	nip = sum(ConfusionMatrix,2);
	PE  = npj*nip;
    if (n*PA-PE) == 0 && (n^2-PE) == 0
        % Solve indetermination
        warning('0 divided by 0')
        Kappa = 1;
    else
    	Kappa  = (n*PA-PE)/(n^2-PE);
    end
	
	% Cohen's Kappa Variance
	theta1 = OA;
	theta2 = PE/n^2;
	theta3 = (nip'+npj) * diag(ConfusionMatrix)  / n^2;
	
	suma4 = 0;
	for i=1:NumClases
	for j=1:NumClases
		suma4 = suma4 + ConfusionMatrix(i,j)*(nip(i) + npj(j))^2;
	end;
	end;
	theta4 = suma4/n^3;
	varKappa = ( theta1*(1-theta1)/(1-theta2)^2     +     2*(1-theta1)*(2*theta1*theta2-theta3)/(1-theta2)^3      +     (1-theta1)^2*(theta4-4*theta2^2)/(1-theta2)^4  )/n;
	Z = Kappa/sqrt(varKappa);
	CI = [Kappa + 1.96*sqrt(varKappa), Kappa - 1.96*sqrt(varKappa)];
	
	if NumClases==2
	    % Wilcoxon test at 95% confidence interval
	    [p1,h1] = signrank(Labels,PreLabels);
	    if h1==0
	        RESULTS.WilcoxonComment	= 'The null hypothesis of both distributions come from the same median can be rejected at the 5% level.';
	    elseif h1==1
	        RESULTS.WilcoxonComment	= 'The null hypothesis of both distributions come from the same median cannot be rejected at the 5% level.';
	    end;
	    RESULTS.WilcoxonP		= p1;
	
	    % Sign-test at 95% confidence interval
	    [p2,h2] = signtest(Labels,PreLabels);
	    if h2==0
	        RESULTS.SignTestComment	= 'The null hypothesis of both distributions come from the same median can be rejected at the 5% level.';
	    elseif h2==1
	        RESULTS.SignTestComment	= 'The null hypothesis of both distributions come from the same median cannot be rejected at the 5% level.';
	    end;
	    RESULTS.SignTestP		= p2;
	
	    % McNemar
	    RESULTS.Chi2 = (abs(ConfusionMatrix(1,2)-ConfusionMatrix(2,1))-1)^2/(ConfusionMatrix(1,2)+ConfusionMatrix(2,1));
	    if RESULTS.Chi2<10
	        RESULTS.Chi2Comments = 'The Chi^2 is not approximated by the chi-square distribution. Instead, the sign test should be used.';
	    else
	        RESULTS.Chi2Comments = 'The Chi^2 is approximated by the chi-square distribution. The greater Chi^2, the lower p<0.05 and thus the difference is more statistically significant.';
	    end
	end
	
	% Store results:
	RESULTS.ConfusionMatrix = ConfusionMatrix;
	RESULTS.Kappa           = Kappa;   
	RESULTS.OA              = 100*OA;      
	RESULTS.varKappa        = varKappa;
	RESULTS.Z               = Z;       
	RESULTS.CI              = CI;
	
case 'regress'
	
	RESULTS.ME   = mean(Labels-PreLabels);
	RESULTS.RMSE = sqrt(mean((Labels-PreLabels).^2));
	RESULTS.MAE  = mean(abs(Labels-PreLabels));
	[rr, pp]     = corrcoef(Labels,PreLabels);
	RESULTS.R    = rr(1,2);
	RESULTS.RP   = pp(1,2);

otherwise
	disp('Unknown learning paradigm.')
end
 


