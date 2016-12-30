% Parameters defining the data generation (in @genDataInterp)
conf.data.FNAME = 'MSSF';
conf.data.f = 0.8;
conf.vector_loop1 = conf.data.T/10; % (u)
conf.vector_loop2 = [40 30 20 10]; % dB (SNR)
% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@Y2, @SVM_Dual, @SVM_RBF, @SVM_aCorr, @Wiener};
conf.machine.params_name={'T0','gamma','epsilon','C','paso'};
conf.machine.ind_params={1:2, 1:4, 1:4, 2:5, 5};
conf.cv.value_range{1} = linspace(conf.data.T/2, 2*conf.data.T, 10); % T0
conf.cv.value_range{2} = logspace(-9,1,10);   % gamma
conf.cv.value_range{3} = logspace(-6,1,5);    % epsilon
conf.cv.value_range{4} = logspace(-1,3,5);    % C
conf.cv.value_range{5} = [1e-3 1e-2 1e-1];    % paso