function volterra1
for P = 1:2:7 % From order 1 to 7
    [b,a] = butter(4,0.005); randn('seed', 0);
    D = 5; % Dimension of the input
    C = volt(D,P); % Compute the volterrra monomial indexes
    % System, training data
    m = randn(1,1000);
    xm = filter(b,a,m)+fliplr(filter(b,a,m));
    x = 10*sin(0.1*(1:1000)).*xm; % Modulated signal
    y = system(x); % Apply distortion
    % System, test data
    m = randn(1,1000);
    xm = filter(b,a,m)+fliplr(filter(b,a,m));
    xt = 10*sin(0.1*(1:1000)).*xm;
    yt = system(xt);
    %  Train
    X = buffer(x,D,D-1,'nodelay');
    XX = volterraMatrix(X,C);
    XX = [XX ; ones(1,size(XX,2))]; %  Add a constant for the bias
    % Compute the MMSE coefficients
    w = pinv(XX*XX')*XX*y(1:size(XX,2));
    % Test
    Xtst = buffer(xt,D,D-1,'nodelay');
    XXtst = volterraMatrix(Xtst,C);
    XXtst = [XXtst ; ones(1,size(XXtst,2))];
    Ytst_ = XXtst'*w;
    % Represent the signal
    hold off, plot(Ytst_),hold all, plot(yt), drawnow
    pause
end

%%  Callback functions

%  Compute the indexes of the monomials
function C = volt(D,P)
x = (1:D)';
for i = 1:P-1
    x = coefficients(x);
    C.(['x' num2str(i+1)]) = x;
end
C.P = P; % Store the order

%  Compute the next set of indices from indices x
function z = coefficients(x)
z = [];
d = max(x(:));
for i = 1:size(x,1)
    for k = x(i,end):d
        z = [z; [x(i,:) k]];
    end
end

% Compute all monomials of vectors in X
function XX = volterraMatrix(X,C)
XX = X;
P = C.P;
for i = 2:P
    aux = 1;
    idx = C.(['x' num2str(i)]);
    for j = 1:size(idx,2)
        aux = aux.* X(idx(:,i),:);
    end
    XX = [XX ; aux];
end

% Nonlinear system that filters and compresses the signal
function y = system(x)
a = [0.1 0.1 0.43 0.9 0.81]';
X = buffer(x,5,4,'nodelay');
z = X'*a; y = tansig(0.7*z);
