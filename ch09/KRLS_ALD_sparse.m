function [expansionCoefficient, dictionaryIndex, ...
    learningCurve, networkSizeCurve, CI] = KRLS_ALD_sparse(datos, ...
    typeKernel, paramKernel, regularizationFactor, forgettingFactor, ...
    th1, NtramasTest)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function KRLS_ALDs Kernel Recursive Least Squares
% with approximate linear dependency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% trainInput:    input signal inputDimension*trainSize, inputDimension
%                    is the input dimension and
%                    trainSize is the number of training data
% trainTarget:   desired signal for training trainSize*1
%
% testInput:     testing input, inputDimension*testSize, testSize is
%                    the number of the test data
% testTarget:    desired signal for testing testSize*1
%
% typeKernel:    'Gauss', 'Poly'
% paramKernel:   h (kernel size) for Gauss and p (order) for poly
%
% regularizationFactor: regularization parameter in Newton's recursion
%
% forgettingFactor: expoentially weighted value
%
% th1:           thresholds used in approximate linear dependency
%
% flagLearningCurve:    control if calculating the learning curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% baseDictionary:       dictionary stores all the bases centers
% expansionCoefficient: coefficients of the kernel expansion
% learningCurve:        trainSize*1 used for learning curve
% networkSizeCurve:     trainSize*1 used for network growth curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MaxDictSize = Inf;

[X,T,indtrain] = signal_gen(datos.Ntramas,datos.mod,datos.SNR,datos.A);
X = 1000*[real(X) ; imag(X)];

% trainSize = datos.Ntramas*142;
trainInput = X(:,indtrain ~= 0);
trainTarget = T(datos.SNR.ref,indtrain ~= 0);

% memory initialization
trainSize = size(trainInput,2);

learningCurve = zeros(datos.Ntramas,1);
learningCurve(1) = trainTarget(1)^2;

k_vector = ker_eval(trainInput(:,1),trainInput(:,1),typeKernel,paramKernel);
predictionVar = regularizationFactor * forgettingFactor + k_vector;
Q_matrix = 1 / predictionVar;
expansionCoefficient = Q_matrix * trainTarget(1);

% dictionary
dictionaryIndex = 1;
dictSize = 1;

networkSizeCurve = zeros(trainSize,1);
networkSizeCurve(1) = 1;

CI = zeros(trainSize,1);
CI(1) = log(predictionVar) / 2;

% start training
for n = 2:trainSize
    % calc the Conditional Information
    k_vector = ker_eval(trainInput(:,n),trainInput(:,dictionaryIndex), ...
        typeKernel,paramKernel);
    n_vector = ker_eval(trainInput(:,n),trainInput(:,n),typeKernel,paramKernel);
    
    networkOutput = expansionCoefficient * k_vector;
    predictionError = trainTarget(n) - networkOutput;
    f_vector = Q_matrix * k_vector;
    
    predictionVar = regularizationFactor * forgettingFactor^(n) + ...
        n_vector - k_vector' * f_vector;
    
    CI(n) = log(predictionVar) / 2;
    
    if CI(n) > th1
        
        % update Q_matrix
        s = 1 / predictionVar;
        Q_tmp = zeros(dictSize+1,dictSize+1);
        Q_tmp(1:dictSize,1:dictSize) = Q_matrix + f_vector * f_vector' * s;
        Q_tmp(1:dictSize,dictSize+1) = -f_vector * s;
        Q_tmp(dictSize+1,1:dictSize) = Q_tmp(1:dictSize,dictSize+1)';
        Q_tmp(dictSize+1,dictSize+1) = s;
        Q_matrix = Q_tmp;
        
        % updating coefficients
        dictSize = dictSize + 1;
        dictionaryIndex(dictSize) = n;
        expansionCoefficient(dictSize) = s * predictionError;
        expansionCoefficient(1:dictSize-1) = expansionCoefficient...
            (1:dictSize-1) - f_vector' * expansionCoefficient(dictSize);
        
        %if dictSize > MaxDictSize
        %    dictSize = MaxDictSize
        %    expansionCoefficient = expansionCoefficient(2:end);
        %    dictionaryIndex = dictionaryIndex(2:end);
        %    Q_matrix = Q_matrix(2:end,2:end);
        %end
        
        networkSizeCurve(n) = length(expansionCoefficient);
        
    else % redundant
        networkSizeCurve(n) = networkSizeCurve(n-1);
    end
    
    if ~rem(n,26)
        learningCurve(n/26) = error_function(n/26, datos, ...
            trainInput(:,dictionaryIndex), expansionCoefficient, ...
            typeKernel, paramKernel, NtramasTest);
        figure(1),semilogy(1:datos.Ntramas,learningCurve),
        xlabel(num2str(n/26)),drawnow
    end
end