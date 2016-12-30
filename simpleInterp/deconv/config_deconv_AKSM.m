% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@deconv_L1, @deconv_GM, @deconv_AKSM};
conf.machine.params_name={'lambda','gamma','alfa','gamma','epsilon','C'};
conf.machine.ind_params={1, 2:3, 4:6};
conf.cv.value_range{1} = 2.0;  % linspace(0,8,10);  % lambda
conf.cv.value_range{2} = 0.8;  % logspace(-9,1,10); % gamma (GM)
conf.cv.value_range{3} = 8.0;  % linspace(0,8,10);  % alfa
conf.cv.value_range{4} = 1e-3; % logspace(-6,1,10); % gamma (AKSM)
conf.cv.value_range{5} = 2.4;  % logspace(-9,1,10); % epsilon
conf.cv.value_range{6} = 100;  % logspace(-1,3,5);  % C

% Parameters defining visualization function
conf.displayfunc = @display_results_deconv;

% Vector with different values of SNR (Signal Noise Rate)
conf.varname_loop1 = 'SNR';
conf.vector_loop1 = [4,10,16,20]; %9