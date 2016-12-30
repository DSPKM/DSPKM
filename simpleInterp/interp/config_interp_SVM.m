% Parameters defining algorithms and theirs free parameters
conf.machine.algs = {@Y1, @Y2, @S1, @S2, @S3, @SVM_Primal, @SVM_Dual, @SVM_RBF};
conf.machine.params_name = {'T0', 'gamma', 'epsilon', 'C'};
conf.machine.ind_params = {1, 1:2, 1, 1, 1, 1:4, 1:4, 1:4};
conf.cv.value_range{1} = linspace(conf.data.T/2, 2*conf.data.T, 10); % T0
conf.cv.value_range{2} = logspace(-9,1,10);   % gamma
conf.cv.value_range{3} = logspace(-6,1,5);    % epsilon
conf.cv.value_range{4} = logspace(-1,3,5);    % C