function data = genDataHRV(conf)

load('patient_HRV_preprocessed.mat')

if  strcmp(conf.recordType, 'NN') % NN intervals
    auxX = patient.sNNx2;
    auxY = patient.sNNy2;
else                              % RR intervals
    auxX = patient.sRRx;
    auxY = patient.sRRy;
end

% Segments (with less than 10% of NaNs) to train and test
X = auxX(patient.idx_segmentos_utiles);
Y = auxY(patient.idx_segmentos_utiles);

data.Xtrain = X{conf.I};
data.Ytrain = Y{conf.I} - mean(Y{conf.I});
data.Xtest = data.Xtrain(1):conf.Tinterp:data.Xtrain(end);
data.Ytest = zeros(length(data.Xtest),1);

% Segments used to obtain autocorrelation vector
idx_without_nan = patient.idx_segmentos_sin_nan; % segments without NaNs
if ~conf.load_acorr && conf.I==1 % rxx is calculated only the first time
    X_withoutNaNs = auxX(idx_without_nan(selected_idx_for_rxx));
    Y_withoutNaNs = auxY(idx_without_nan(selected_idx_for_rxx));
    [rxx,t_rxx] = calcularRxx(X_withoutNaNs, Y_withoutNaNs, conf);
    save(conf.path_acorr,'rxx','t_rxx')
end

