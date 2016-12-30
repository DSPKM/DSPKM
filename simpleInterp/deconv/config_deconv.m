% Parameters defining experiment setting
conf.NREPETS = 100; % Number of executions
% Parameters defining the data generation (in @genDataInterp)
conf.data.N         = 2^7; % Signal length
conf.data.Q         = 15;  % Impulse response length
conf.data.typeNoise = 1;   % 1: Gaussian noise, 2: Uniform, 3: Laplacian
% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@deconv_L1, @deconv_GM};
conf.machine.params_name={'lambda','gamma','alfa'};
conf.machine.ind_params={1, 2:3};
% Parameters defining evaluation criterion
conf.evalfuncs={@MSE, @F, @Fnull};
% Parameters defining free parameters searching
conf.cv.searchfunc=@gridSearch;
conf.cv.evalfunc = @MSE;
conf.cv.value_range{1} = 2.0; %linspace(0,8,10);   % lambda
conf.cv.value_range{2} = 0.8; %logspace(-9,1,10);  % gamma
conf.cv.value_range{3} = 8.0; %linspace(0,8,10);   % alfa
% Parameters defining visualization function
conf.displayfunc = @display_results_deconv;
% Vector with different values of SNR (Signal Noise Rate)
conf.varname_loop1 = 'SNR';
conf.vector_loop1 = 10; % 4:2:20