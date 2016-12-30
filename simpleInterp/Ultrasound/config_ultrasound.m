conf.NREPETS=165;               % It is used to load different scans.

conf.machine.params_name={'gamma','gamma','epsilon','C','alfa','lambda'};
conf.machine.algs={@deconv_GM, @deconv_L1, @deconv_AKSM};
conf.machine.ind_params={[1 5], 6, 2:4};

conf.evalfuncs={@MSE};
conf.cv.searchfunc = @gridSearch;
conf.cv.evalfunc = @MSE;

conf.cv.value_range{1} = 0.8;   % gamma (of GM)
conf.cv.value_range{2} = 1e-3;  % gamma (of AKSM)
conf.cv.value_range{3} = 0.15;  % epsilon
conf.cv.value_range{4} = 100;   % C
conf.cv.value_range{5} = 8;     % alfa
conf.cv.value_range{6} = 2.00;  % lambda

conf.displayfunc = @display_results_ultrasound;


