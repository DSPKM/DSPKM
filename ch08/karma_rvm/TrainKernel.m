function [Y2hat,results,model] = TrainKernel(K,K2,Y,Y2,D,p,gamma,e,C,regression)

if strcmpi(regression,'krr')
    
    H = K + gamma*eye(size(K));
    model = H \ Y(p+1:end-D);
    Y2hat = K2 * model;
    svs = 100;
    
elseif strcmpi(regression,'svr')
    
    % -----------------------------------------------------------------------------
    % Training
    % -----------------------------------------------------------------------------
    H = K;	% Standard SVR
    model = mexsvmtrain(Y(p+1:end-D),H,['-t 4 -s 3 -c ' num2str(C) ' -p ' num2str(e)]);
    svs = 100*length(model.SVs)/length(Y(p+1:end-D));
    
    % -----------------------------------------------------------------------------
    % Testing
    % -----------------------------------------------------------------------------
    H2 = K2;	% Standard SVR
    Y2hat = mexsvmpredict(Y2(p+1:end-D),H2,model);
    
elseif strcmpi(regression,'rvm')
    
    % Training
    H = K; YT  = Y(p+1:end-D);
    % Testing
    H2 = K2;
    
    % Fixed hyperparameters
    alpha 	= 1;
    beta 	= 1e3;
    maxIts  = 1000;
    monIts  = 1;
    [weights, used] = sbl_estimate(H,YT,alpha,beta,maxIts,monIts);
    
    PHI2  = H2(:,used);
    Y2hat = PHI2 * weights;
    svs   = 100 * length(weights~=0)/length(YT);
    model.weights = weights; model.used = used;
    model.H = H; model.H2 = H2; model.YT = YT;
end

% --------------------------------------------------------------------------------------------------------------------------
% Results in test
% --------------------------------------------------------------------------------------------------------------------------
results = ComputeResults(Y2hat,Y2(p+1:end-D));
results.svs = svs;
