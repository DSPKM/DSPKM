function w = getSvmWeights(maq)

% Gets weights from a SVM machine struct
w = 0;
if ~isempty(maq)
    w = maq.sv_coef'*maq.SVs;
end
