% Paramaters of data generation
conf.path_acorr='dopplerCardiac/acorr_dopplerCardiac.mat';
conf.data.path='realImage.mat';
conf.data.path_map='DopplerMap.mat';
conf.NREPETS=1;      % It is used to load different segments

% Parameters defining algorithms
conf.evalfuncs={@MSE,@MAE,@R2};
conf.cv.searchfunc=@cross_validation;
conf.cv.n_folds=10;
conf.cv.evalfunc=@MSE;
conf.machine.params_name={'gamma','nu','C','path'};
conf.machine.algs={@SVM_AutoCorr};
conf.machine.ind_params={1:4};
conf.cv.value_range{1} = 0.1;  %logspace(-6,1,10);       % gamma
conf.cv.value_range{2} = 0.35; %linspace(0.01,0.99,10);  % nu
conf.cv.value_range{3} = 621;  %logspace(-1,3,5);        % C
conf.cv.value_range{4} = conf.path_acorr;                % acorr

conf.varname_loop1 = 'Ntrain';
conf.vector_loop1 = [100,500,1000,2000,3000];
conf.varname_loop2 = 'sampleType';
conf.vector_loop2 = {'random','edges','amplitude','gradient','secondDerivative'};

conf.displayfunc = @display_results_dopplerCardiac;
