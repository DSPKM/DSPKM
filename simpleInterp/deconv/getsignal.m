function x  = getsignal(N,tipo)
x = zeros(N,1);
switch tipo
    case 1
        x([20 25 47 71 95]) = [8 6.845 -5.4 4 -3.6];
    case 2
        Q = 15;
        p = 0.05;
        while ~sum(x)
            aux = rand(N-Q,1);
            q   = (aux<=p);
            x(1:N-Q) = randn(N-Q,1).*q;
        end
end