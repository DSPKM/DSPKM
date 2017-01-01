function model = trainNN(X,Y)

% Set to non-zero to use it (for instance, vfold = 4)
vfold = 0;

% Cross validation
rand('seed',0)
r = randperm(size(Y,1)); % random index
Ntrain = round(size(Y,1) * 0.66);

% Training
X1 = X(r(1:Ntrain),:);
Y1 = Y(r(1:Ntrain),:);

% Validation
X2 = X(r((Ntrain+1):end),:);
Y2 = Y(r((Ntrain+1):end),:);

% From 'help train'
% 'The validation vectors are used to stop training early if further training on
%  the primary vectors will hurt generalization to the validation vectors'
if vfold == 0
    VV.P = X2';
    VV.T = Y2';
else
    error('vfold not tested: comment line this and use at your own risk')
end

% [nin  nsam] = size(X1');
% [nout nsam] = size(Y1');
nout = size(Y1,2);

method  = 'trainlm';
epochs  = 100;
neurons = 2:2:30;

newnet = @newff;

limits = [min(X1); max(X1)]';

k = 0;
redes = cell(1,numel(neurons));
RMSEs = zeros(1,numel(neurons));
for nh = neurons
    
    k = k +1;
    
    net = newnet(limits, [nh nout], {'tansig', 'purelin'}, method); % 1 hidden layer

    % Do not display anything
    net.trainParam.show = NaN;
    net.trainParam.showWindow = false;
    net.trainParam.epochs = epochs;
  
    if vfold == 0
        % Train
        net = train(net,X1',Y1',[],[],VV,[]);    
        % Save network
        redes{nh} = net;
        % Simulate and save results for the VALIDATION set
        PredictV = sim(net,X2');
        % RMSE
        RMSEs(k) = mean(sqrt(mean((Y2'-PredictV).^2)));
    else
        indices = crossvalind('kfold', size(X1,1), vfold);
        vf_RMSE = zeros(1,vfold);
        for i = 1:vfold
           testind  = (indices == i); trainind = ~test;
           VV.P = X1(testind,:)'; VV.T = Y1(testind,:)';
           warning('matlab:warning', 'Must each net be re-initialized?')
           net = train(net,X1(trainind,:)',Y1(trainind,:)',[],[],VV,[]);
           YP = sim(net,X2');
           vf_RMSE(i) = mean(sqrt(mean((Y2'-YP).^2)));
        end
        % RMSE
        RMSEs(k) = mean(vf_RMSE);
        warning('matlab:warning', 'Probably a new net should be initialized and trained')
    end
end

% Select the best network structure (minimum validation error):
[val,idx] = min(RMSEs);
bestnet = neurons(idx);
net = redes{bestnet}; % best network

% We are already near to the optimal: refine a little bit more using all data
net.trainParam.epochs = 10; % There is no further validation set, fix number of epochs
% model = train(net,X',Y',[],[],[],[]); % best model with all data
model = train(net,X',Y'); % best model with all data
