function consistency
addpath ../libsvm/
c = 1;                  % Set C = 1 in the functional
NN = 10:500;            % Number of samples from 10 to 500
Remp = zeros(1000,190); % Matrix to store empirical risc
R = Remp;               % Matrix to store test risk
for i = 1:100
    for j = 1:length(NN)
        [X,Y] = data(NN(j),1);                  % Produce training data
        options = ['-s 0 -t 0 -c ' num2str(c)]; % SVM options
        model = mexsvmtrain(Y,X,options);       % Train the SVM
        [~,p] = mexsvmpredict(Y,X,model);      % Test the SVM with training data
        Remp(i,j) = 1-p(1)/100;                 % Compute the empirical risk
        [X,Y] = data(1000,1);                   % Produce test data
        [~,p] = mexsvmpredict(Y,X,model);      % Test with it
        R(i,j) = 1-p(1)/100;                    % Compute the test risk
    end
    % Plot the results
    figure(1), plot(NN,mean(Remp(1:i,:)),'r'), grid on, hold on
    plot(NN,mean(R(1:i,:))), hold off; drawnow
end
keyboard % this allows to inspect variables before exiting the function

function [X,Y] = data(N,sigma)
w = ones(1,10) / sqrt(10); % A vector in a 10 dimension space
w1 = w .* [ 1  1  1  1  1 -1 -1 -1 -1 -1]; % One more orthogonal to the first
w2 = w .* [-1 -1  0  1  1 -1 -1  0  1  1]; % One more orthogonal to the previous ones
w2 = w2 / norm(w2);                        % Normalize
% The following four vectors are centers of four clusters forming a square
x(1,:) = zeros(1,10); x(2,:) = x(1,:) + sigma * w1;
x(3,:) = x(1,:) + sigma * w2; x(4,:) = x(3,:) + sigma * w1;
% The following data are the four clusters pf data labelled with +1 and -1
X1 = x + sigma * repmat(w,4,1) / 2; X2 = x - sigma * repmat(w,4,1) / 2;
% The previous eight clusters are the edges of a cube in a 3D space
X1 = repmat(X1,2*N,1); X2 = repmat(X2,2*N,1); X = [X1;X2];
Y = [ones(4*2*N,1) ; -ones(4*2*N,1)]; Z = randperm(8*2*N); Z = Z(1:N);
X = X(Z,:) + 0.4 * sigma * randn(size(X(Z,:))); Y = Y(Z);