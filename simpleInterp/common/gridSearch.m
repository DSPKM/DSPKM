function param_selec = gridSearch(XTrain,YTrain,conf,XValid,YValid)

% Cell array of free parameters
value_range = conf.machine.value_range;
pos_str = false(1,length(value_range));
for i = 1:length(value_range); pos_str(i) = ischar(value_range{i}); end
str_args = value_range(pos_str);
value_range(pos_str) = {0};

% With more than one parameter do grid search
ind_combs = combvec(value_range{:});
[nparams,ncombs] = size(ind_combs);
param_selec = cell(nparams,1);
if sum(pos_str)>0; value_range(pos_str) = str_args; end
% With just one comb just return
if ncombs == 1; param_selec = value_range; return; end

err = inf + ones(1,ncombs);
% Loop over parameters
fprintf('Finding best free parameters in a %dD grid search...\n(There are %d combinations)\n',nparams,ncombs)
if conf.parallelize; parforArg = inf; else parforArg = 0; end
parfor (ic = 1:ncombs, parforArg)
    if mod(ic,1000) == 0; fprintf('Combination %d of %d\n',ic,ncombs); end
    params = cell(nparams,1);
    for ip = 1:nparams
        params{ip} = ind_combs(ip,ic);
    end
    if sum(pos_str)>0; params(pos_str) = str_args; end
    % Train
    prediction = conf.machine.function_name(XTrain,YTrain,XValid,params{:});
    % Validation error
    err(ic) = conf.cv.evalfunc(prediction,YValid);
end
[~,indMin] = min(err);
for ip = 1:nparams
    param_selec{ip} = ind_combs(ip,indMin);
end
if sum(pos_str)>0; param_selec(pos_str) = str_args; end