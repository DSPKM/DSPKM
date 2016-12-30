function solution_summary = display_results_HRV(solution,conf)

% Init. params.
fmin = 0.04;
% Loading data
load('patient_HRV_preprocessed.mat')
if  strcmp(conf.recordType, 'NN') % NN intervals
    auxX = patient.sNNx2;
    auxY = patient.sNNy2;
else                              % RR intervals
    auxX = patient.sRRx;
    auxY = patient.sRRy;
end
X = auxX(patient.idx_segmentos_utiles);
Y = auxY(patient.idx_segmentos_utiles);
% Figures
fs = 1000 / conf.Tinterp;
f_interp = linspace(0, fs/2, conf.Lfft/2);
algs=['Original';fields(solution)];
nalgs=length(algs);
for ia=1:nalgs
    alg=algs{ia};
    if ia==1
        [F.(alg), T.(alg), EG.(alg)] = getSpectrogram(X, Y, conf);
    else
        for i=1:length(solution.(alg)); Ypred{i}=solution.(alg)(i).Ytestpred; end
        [F.(alg), T.(alg), EG.(alg)] = getSpectrogram(f_interp, Ypred, conf);
    end
    fmin2 = find(F.(alg)(1,:) > fmin, 1); fmax2 = find(F.(alg)(1,:) > 0.5, 1);
    subplot(3,1,ia);
    mesh(F.(alg)(:,fmin2:fmax2), T.(alg)(:,fmin2:fmax2), EG.(alg)(:,fmin2:fmax2)); view(10, 30)
    title([strrep(alg,'_','-'),' Interpolated HRV spectrogram']);
    axis([0 0.5 1 length(X) 0 0.2]);
    xlabel('f (Hz)'); ylabel('Segment index');
end
figure;
extra={' segment',' interpolated',' interpolated'};
for ia=1:nalgs
    alg=algs{ia};
    subplot(3,1,ia); hold on;
    for n = 1:size(EG.(alg),1),
        plot(F.(alg)(1,:),EG.(alg)(n,:),'k');
    end
    axis([0 0.5 0 1]);
    title([strrep(alg,'_','-'),extra{ia},' spectra (accumulated plot)']);
end
xlabel('Hz');
%% Performance summary
solution_summary = results_summary(solution,conf);
