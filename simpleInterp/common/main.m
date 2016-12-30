function solution = main(conf)

for m = 1:conf.NREPETS
    conf.I = m; fprintf('Executing run %d...\n',m);
    % Specified dataset is generated or loaded
    [Xtrain,Ytrain,Xtest,Ytest] = load_data(conf);
    % Specified algorithms are used
    for ialg = 1:length(conf.machine.algs)
        conf.machine.function_name = conf.machine.algs{ialg};
        alg = func2str(conf.machine.function_name);
        % Free parameters are selected by a searching function
        conf.machine.value_range = conf.cv.value_range(conf.machine.ind_params{ialg});
        param_selec = conf.cv.searchfunc(Xtrain,Ytrain,conf,Xtest,Ytest);
        ind_params = conf.machine.ind_params{ialg};
        for ip = 1:length(ind_params)
            solution.(alg)(m).(conf.machine.params_name{ind_params(ip)}) = param_selec{ip};
        end
        % Adjusted algorithms are trained and applied to predict
        [Ypred,coefs] = conf.machine.function_name(Xtrain,Ytrain,Xtest,param_selec{:});
        solution.(alg)(m).coefs = coefs;
        solution.(alg)(m).Ytestpred = Ypred;
        solution.(alg)(m).Ytest = Ytest;
        solution.(alg)(m).Xtest = Xtest;
        solution.(alg)(m).Xtrain = Xtrain;
        solution.(alg)(m).Ytrain = Ytrain;
        for ie = 1:length(conf.evalfuncs)
            evalfunc = conf.evalfuncs{ie};
            evalname = func2str(evalfunc);
            solution.(alg)(m).(evalname) = evalfunc(Ypred,Ytest);
        end
    end
end